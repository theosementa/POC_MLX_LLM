//
//  File.swift
//  ArtificialIntelligence
//
//  Created by Theo Sementa on 01/04/2026.
//

import Foundation
import MLXLLM
import MLXLMCommon

extension LLMRegistry {
    
    static let llama3_2_3b_instruct_4bit: ModelConfiguration = ModelConfiguration(
        id: "mlx-community/Llama-3.2-3B-Instruct-4bit",
        overrideTokenizer: "PreTrainedTokenizerFast"
    )
    
    static let mistral_7b_instruct_4bit: ModelConfiguration = ModelConfiguration(
        id: "mlx-community/Mistral-7B-Instruct-v0.3-4bit",
        overrideTokenizer: "PreTrainedTokenizerFast"
    )
    
    static let lfm2_5_1b_16bit: ModelConfiguration = ModelConfiguration(
        id: "mlx-community/LFM2.5-1.2B-Instruct-bf16",
        overrideTokenizer: "PreTrainedTokenizerFast"
    )
    
    static let gemma4_2b_4bit: ModelConfiguration = ModelConfiguration(
        id: "mlx-community/gemma-4-e4b-it-4bit",
        overrideTokenizer: "PreTrainedTokenizerFast"
    )
    
}
