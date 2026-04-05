//
//  ChatMessage.swift
//  ArtificialIntelligence
//
//  Created by Theo Sementa on 01/04/2026.
//

import Foundation

public struct ChatMessage: Identifiable {
    public let id: UUID
    public let role: Role
    public let content: String
    public let date: Date

    public enum Role {
        case user
        case assistant
    }

    public init(role: Role, content: String) {
        self.id = UUID()
        self.role = role
        self.content = content
        self.date = Date()
    }

    var asDictionary: [String: String] {
        let roleString = role == .user ? "user" : "assistant"
        return ["role": roleString, "content": content]
    }
}
