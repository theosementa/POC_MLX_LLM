//
//  LLMOutput.swift
//  ArtificialIntelligence
//
//  Created by Theo Sementa on 01/04/2026.
//

import Foundation

public struct LLMOutput {
    public let raw: String
    public let cleanOutput: String

    public init(raw: String) {
        self.raw = raw
        self.cleanOutput = raw.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
