//
//  LLMService.swift
//  ArtificialIntelligence
//
//  Created by Theo Sementa on 01/04/2026.
//

import Foundation
import MLX
import MLXLLM
import MLXLMCommon

@MainActor @Observable
public class LLMService {
    
    public var downloadProgress: Int = 0
    public var isRunning: Bool = false
    
    public var streamingOutput: LLMOutput = LLMOutput(raw: "")
    public var history: [ChatMessage] = []
    
    public var kvCacheTokens: Int = 0
    public var tokensPerSecond: Double? = nil
    
    public var selectedModel: ModelOption = .mistral7B
    private let parameters: GenerateParameters = GenerateParameters(maxKVSize: 4096, kvBits: 4, temperature: 0.1)
    
    private var modelContext: ModelContext? = nil
    private var kvCache: [KVCache] = []

    public init() {
        setGPUCacheLimit()
    }

}

// MARK: - Computed variables
extension LLMService {

    public var isModelLoaded: Bool {
        modelContext != nil
    }

}

// MARK: - Public methods
extension LLMService {

    public func loadModel() async throws {
        guard isModelLoaded == false else { return }

        #if targetEnvironment(simulator)
        throw LLMError.simulatorNotSupported
        #endif
        
        modelContext = try await MLXLMCommon.loadModel(configuration: selectedModel.configuration) { progress in
            Task { @MainActor in
                self.downloadProgress = Int(progress.fractionCompleted * 100)
            }
        }
    }

    public func askInSession(prompt: String) async {
        guard let modelContext, !isRunning else { return }

        isRunning = true
        streamingOutput = LLMOutput(raw: "")
        
        history.append(ChatMessage(role: .user, content: prompt))

        do {
            let lmInput = try await modelContext.processor.prepare(
                input: UserInput(chat: [Chat.Message(role: .user, content: prompt)])
            )

            if kvCache.isEmpty {
                kvCache = modelContext.model.newCache(parameters: parameters)
            }

            let stream = try MLXLMCommon.generate(
                input: lmInput,
                cache: kvCache,
                parameters: parameters,
                context: modelContext
            )

            var output = ""
            for await generation in stream {
                if let chunk = generation.chunk {
                    output += chunk
                    streamingOutput = LLMOutput(raw: output)
                    kvCacheTokens = kvCache.first?.offset ?? 0
                } else if let info = generation.info {
                    tokensPerSecond = info.tokensPerSecond
                }
            }

            kvCacheTokens = kvCache.first?.offset ?? 0
            handleOutput(output)
        } catch {
            handleOutput("Error: \(error.localizedDescription)")
        }

        isRunning = false
    }

    public func clearHistory() {
        history.removeAll()
        streamingOutput = LLMOutput(raw: "")
        kvCache = []
        kvCacheTokens = 0
        tokensPerSecond = nil
        MLX.GPU.clearCache()
    }

}

// MARK: - Private methods
private extension LLMService {

    func setGPUCacheLimit() {
        let memory = ProcessInfo.processInfo.physicalMemory
        let cacheLimit = memory / 4
        MLX.GPU.set(cacheLimit: Int(cacheLimit))
    }

    func handleOutput(_ output: String) {
        let finalOutput = LLMOutput(raw: output)
        streamingOutput = finalOutput
        history.append(ChatMessage(role: .assistant, content: finalOutput.cleanOutput))
    }

}
