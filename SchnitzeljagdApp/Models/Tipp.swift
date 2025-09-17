import Foundation

/// Represents a hint that can be shown for a station.
struct Tipp: Identifiable, Equatable {
    let id: UUID
    let text: String
    let isCritical: Bool

    init(id: UUID = UUID(), text: String, isCritical: Bool = false) {
        self.id = id
        self.text = text
        self.isCritical = isCritical
    }
}
