//
//  ContentView.swift
//  POC_MLX
//
//  Created by Theo Sementa on 01/04/2026.
//

import SwiftUI
import ArtificialIntelligence

struct ContentView: View {

    // MARK: States
    @State private var llmService = LLMService()
    @State private var currentPrompt: String = ""

    // MARK: - View
    var body: some View {
        VStack(spacing: 0) {
            if llmService.isModelLoaded {
                conversationView
                Divider()
                askSectionView
            } else {
                loadModelSectionView
            }
        }
    }
}

// MARK: - Subviews
fileprivate extension ContentView {

    @ViewBuilder
    var conversationView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(llmService.history) { message in
                        ChatBubbleView(message: message)
                    }

                    if llmService.isRunning {
                        streamingBubbleView
                            .id("streaming")
                    }
                }
                .padding()
            }
            .onChange(of: llmService.streamingOutput.cleanOutput) {
                proxy.scrollTo("streaming", anchor: .bottom)
            }
            .onChange(of: llmService.history.count) {
                proxy.scrollTo(llmService.history.last?.id, anchor: .bottom)
            }
        }
    }

    @ViewBuilder
    var streamingBubbleView: some View {
        VStack(alignment: .leading, spacing: 6) {
            if !llmService.streamingOutput.cleanOutput.isEmpty {
                Text(llmService.streamingOutput.cleanOutput)
                    .padding(12)
                    .background(.blue.opacity(0.08), in: RoundedRectangle(cornerRadius: 14))
            } else {
                ProgressView()
                    .padding(12)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    var loadModelSectionView: some View {
        if llmService.downloadProgress > 0 {
            VStack(spacing: 8) {
                ProgressView(value: Double(llmService.downloadProgress), total: 100)
                    .progressViewStyle(.linear)
                Text("\(llmService.downloadProgress)%")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
        } else {
            VStack(spacing: 16) {
                Picker("Model", selection: $llmService.selectedModel) {
                    ForEach(ModelOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.menu)

                Button {
                    Task {
                        do {
                            try await llmService.loadModel()
                        } catch {
                            print("Error : \(error.localizedDescription)")
                        }
                    }
                } label: {
                    Text("Load model")
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    @ViewBuilder
    var statsView: some View {
        HStack(spacing: 16) {
            Label("\(llmService.kvCacheTokens) tokens", systemImage: "memorychip")
            if let tps = llmService.tokensPerSecond {
                Label(String(format: "%.1f tok/s", tps), systemImage: "bolt")
            }
            Spacer()
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding(.horizontal)
        .padding(.top, 4)
    }

    @ViewBuilder
    var askSectionView: some View {
        statsView
        HStack(spacing: 8) {
            TextField("Ask something...", text: $currentPrompt)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button {
                Task {
                    let prompt = currentPrompt
                    currentPrompt = ""
                    await llmService.askInSession(prompt: prompt)
                }
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
            }
            .disabled(currentPrompt.isEmpty || llmService.isRunning)

            Button {
                llmService.clearHistory()
            } label: {
                Image(systemName: "trash")
                    .font(.title2)
                    .foregroundStyle(.red)
            }
            .disabled(llmService.history.isEmpty)
        }
        .padding()
    }

}

// MARK: - ChatBubbleView
fileprivate struct ChatBubbleView: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.role == .user { Spacer() }

            Text(message.content)
                .padding(12)
                .background(
                    message.role == .user ? Color.blue : Color(.systemGray5),
                    in: RoundedRectangle(cornerRadius: 14)
                )
                .foregroundStyle(message.role == .user ? .white : .primary)
                .frame(maxWidth: 280, alignment: message.role == .user ? .trailing : .leading)

            if message.role == .assistant { Spacer() }
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
