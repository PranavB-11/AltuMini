import Foundation

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let role: ChatRole
    let text: String
}

enum ChatRole {
    case user
    case model
}

