import Foundation

/// Describes persistence operations for storing Schnitzeljagd progress.
protocol ProgressPersistenceProtocol: AnyObject {
    func saveAnswer(_ answer: String, for stationID: UUID)
    func loadAnswer(for stationID: UUID) -> String?
    func saveCodeFragment(_ fragment: String, for stationID: UUID)
    func loadCodeFragment(for stationID: UUID) -> String?
    func reset()
}

/// Persists answers and collected code fragments using `UserDefaults`.
final class ProgressPersistenceService: ProgressPersistenceProtocol {

    private enum Keys {
        static let answers = "de.alvin.schnitzeljagd.answers"
        static let fragments = "de.alvin.schnitzeljagd.fragments"
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    func saveAnswer(_ answer: String, for stationID: UUID) {
        var stored = userDefaults.dictionary(forKey: Keys.answers) as? [String: String] ?? [:]
        stored[stationID.uuidString] = answer
        userDefaults.setValue(stored, forKey: Keys.answers)
    }

    func loadAnswer(for stationID: UUID) -> String? {
        let stored = userDefaults.dictionary(forKey: Keys.answers) as? [String: String]
        return stored?[stationID.uuidString]
    }

    func saveCodeFragment(_ fragment: String, for stationID: UUID) {
        var stored = userDefaults.dictionary(forKey: Keys.fragments) as? [String: String] ?? [:]
        stored[stationID.uuidString] = fragment
        userDefaults.setValue(stored, forKey: Keys.fragments)
    }

    func loadCodeFragment(for stationID: UUID) -> String? {
        let stored = userDefaults.dictionary(forKey: Keys.fragments) as? [String: String]
        return stored?[stationID.uuidString]
    }

    func reset() {
        userDefaults.removeObject(forKey: Keys.answers)
        userDefaults.removeObject(forKey: Keys.fragments)
    }
}
