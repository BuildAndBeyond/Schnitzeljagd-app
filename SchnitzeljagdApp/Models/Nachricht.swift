import Foundation

/// Represents a chat message displayed in the UI.
struct Nachricht: Identifiable, Equatable {
    enum Sender {
        case alvin
        case spieler
        case system
    }

    let id: UUID
    let sender: Sender
    let text: String
    let timestamp: Date

    init(id: UUID = UUID(), sender: Sender, text: String, timestamp: Date = Date()) {
        self.id = id
        self.sender = sender
        self.text = text
        self.timestamp = timestamp
    }
}
