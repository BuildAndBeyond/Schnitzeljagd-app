import Foundation

/// Handles the Schnitzeljagd progression, answer validation and messaging bridge for the UI.
final class SchnitzeljagdViewModel {

    typealias MessagesHandler = ([Nachricht]) -> Void
    typealias StationHandler = (Station) -> Void
    typealias TextHandler = (String) -> Void
    typealias CompletionHandler = () -> Void

    private let repository: StationsRepositoryProtocol
    private let persistenceService: ProgressPersistenceProtocol
    private let dateProvider: () -> Date

    private var stations: [Station] = []
    private var currentIndex: Int = 0
    private var revealedTips: [UUID: Int] = [:]

    private var messages: [Nachricht] = [] {
        didSet { onMessagesUpdated?(messages) }
    }

    var onMessagesUpdated: MessagesHandler?
    var onStationChanged: StationHandler?
    var onShowSuccess: TextHandler?
    var onShowFailure: TextHandler?
    var onShowTresorSuccess: CompletionHandler?

    init(
        repository: StationsRepositoryProtocol,
        persistenceService: ProgressPersistenceProtocol,
        dateProvider: @escaping () -> Date = Date.init
    ) {
        self.repository = repository
        self.persistenceService = persistenceService
        self.dateProvider = dateProvider
    }

    /// Loads stations and prepares the initial chat history.
    func start() {
        stations = repository.fetchStations()
        currentIndex = resolvedStartIndex()
        messages.removeAll()
        revealedTips.removeAll()
        guard !stations.isEmpty else { return }
        presentCurrentStation(restoringProgress: true)
    }

    /// Returns the number of stations to allow progress display in the UI.
    func totalStations() -> Int {
        return stations.count
    }

    /// Returns the index of the station the player is currently facing.
    func currentStationNumber() -> Int {
        return currentIndex + 1
    }

    /// Requests a hint for the current station if available.
    func requestTip() {
        guard let station = currentStation else { return }
        let usedTips = revealedTips[station.id] ?? 0
        guard usedTips < station.tips.count else { return }
        let tip = station.tips[usedTips]
        revealedTips[station.id] = usedTips + 1
        appendSystemMessage(tip.text)
    }

    /// Validates an answer provided by the player.
    func submit(answer: String) {
        guard let station = currentStation else { return }
        let trimmed = sanitize(answer)
        guard !trimmed.isEmpty else { return }
        appendPlayerMessage(answer)

        if compare(trimmed, to: station.answer) {
            handleCorrectAnswer(for: station)
        } else {
            onShowFailure?("Fast! Prüfe nochmal deine Hinweise.")
            appendSystemMessage("Das passt noch nicht.")
        }
    }

    /// Clears all persisted progress.
    func resetProgress() {
        persistenceService.reset()
        start()
    }

    private var currentStation: Station? {
        guard stations.indices.contains(currentIndex) else { return nil }
        return stations[currentIndex]
    }

    private func resolvedStartIndex() -> Int {
        for (index, station) in stations.enumerated() {
            if persistenceService.loadAnswer(for: station.id)?.caseInsensitiveCompare(station.answer) != .orderedSame {
                return index
            }
        }
        return max(stations.count - 1, 0)
    }

    private func presentCurrentStation(restoringProgress: Bool) {
        guard let station = currentStation else { return }
        onStationChanged?(station)
        if restoringProgress {
            preloadProgressMessages(before: station)
        }
        for message in station.narrative {
            appendMessage(message)
        }
        appendSystemMessage(station.question)
    }

    private func preloadProgressMessages(before station: Station) {
        for previous in stations.prefix(while: { $0.id != station.id }) {
            guard let savedAnswer = persistenceService.loadAnswer(for: previous.id) else { continue }
            appendPlayerMessage(savedAnswer)
            appendSystemMessage(previous.successMessage)
        }
    }

    private func handleCorrectAnswer(for station: Station) {
        persistenceService.saveAnswer(station.answer, for: station.id)
        if !station.codeFragment.isEmpty {
            persistenceService.saveCodeFragment(station.codeFragment, for: station.id)
        }
        appendSystemMessage(station.successMessage)
        onShowSuccess?(station.successMessage)

        if station.type == .finale {
            onShowTresorSuccess?()
            return
        }
        advanceToNextStation()
    }

    private func advanceToNextStation() {
        currentIndex += 1
        guard stations.indices.contains(currentIndex) else { return }
        presentCurrentStation(restoringProgress: false)
    }

    private func appendMessage(_ message: Nachricht) {
        messages.append(message)
    }

    private func appendSystemMessage(_ text: String) {
        let systemMessage = Nachricht(sender: .system, text: text, timestamp: dateProvider())
        appendMessage(systemMessage)
    }

    private func appendPlayerMessage(_ text: String) {
        let playerMessage = Nachricht(sender: .spieler, text: text, timestamp: dateProvider())
        appendMessage(playerMessage)
    }

    private func sanitize(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    private func compare(_ lhs: String, to rhs: String) -> Bool {
        return sanitize(lhs) == sanitize(rhs)
    }
}
