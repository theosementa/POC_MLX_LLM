//
//  ModelOption.swift
//  ArtificialIntelligence
//
//  Created by Theo Sementa on 05/04/2026.
//

import Foundation
import MLXLLM
import MLXLMCommon

public enum ModelOption: String, CaseIterable {
    case llama3B = "Llama 3.2 3B (4bit)"
    case mistral7B = "Mistral 7B (4bit)"
    case lfm2_5_1B = "LFM 2.5 1B (16bit)"
    case gemma42B = "Gemma 4 2B (4bit)"
}

extension ModelOption {
    
    public var systemPrompt: String {
        return """
            You are a helpful assistant. Always answer in the language of the prompt written by the user.
            """
    }
    
    public var configuration: ModelConfiguration {
        var model = switch self {
        case .llama3B:
            LLMRegistry.llama3_2_3B_4bit
        case .mistral7B:
            LLMRegistry.mistral_7b_instruct_4bit
        case .lfm2_5_1B:
            LLMRegistry.lfm2_5_1b_16bit
        case .gemma42B:
            LLMRegistry.gemma4_2b_4bit
        }
        
        model.defaultPrompt = systemPrompt
        return model
    }
    
}
