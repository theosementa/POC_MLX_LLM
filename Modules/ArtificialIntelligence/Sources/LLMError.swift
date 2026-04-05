//
//  LLMError.swift
//  ArtificialIntelligence
//
//  Created by Theo Sementa on 01/04/2026.
//

import Foundation

public enum LLMError: LocalizedError {
    case simulatorNotSupported

    public var errorDescription: String? {
        switch self {
        case .simulatorNotSupported:
            return "MLX doesn't work on simulator. Use a real device."
        }
    }
}
