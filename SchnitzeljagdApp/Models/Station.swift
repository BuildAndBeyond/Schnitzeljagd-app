import Foundation

/// Represents a single station within the scavenger hunt.
struct Station: Identifiable, Equatable {
    enum StationType {
        case question
        case finale
    }

    let id: UUID
    let title: String
    let narrative: [Nachricht]
    let question: String
    let answer: String
    let tips: [Tipp]
    let successMessage: String
    let codeFragment: String
    let type: StationType

    init(
        id: UUID = UUID(),
        title: String,
        narrative: [Nachricht],
        question: String,
        answer: String,
        tips: [Tipp],
        successMessage: String,
        codeFragment: String,
        type: StationType = .question
    ) {
        self.id = id
        self.title = title
        self.narrative = narrative
        self.question = question
        self.answer = answer
        self.tips = tips
        self.successMessage = successMessage
        self.codeFragment = codeFragment
        self.type = type
    }
}
