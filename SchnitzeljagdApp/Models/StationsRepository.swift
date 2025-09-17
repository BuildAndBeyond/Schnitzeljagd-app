import Foundation

/// Contract for retrieving stations for the scavenger hunt.
protocol StationsRepositoryProtocol {
    func fetchStations() -> [Station]
}

/// Provides the Alvin themed story and station data.
struct AlvinStationsRepository: StationsRepositoryProtocol {
    func fetchStations() -> [Station] {
        return [
            makeStartStation(),
            makeLibraryStation(),
            makeFinalStation()
        ]
    }

    private func makeStartStation() -> Station {
        Station(
            title: "Willkommen im HQ",
            narrative: [
                Nachricht(sender: .alvin, text: "Hey, du bist da! Die Mission wartet nicht."),
                Nachricht(sender: .alvin, text: "Im Gemeinschaftsraum liegt etwas, das nicht hierher gehört."),
                Nachricht(sender: .system, text: "Finde den ersten Hinweis und gib das Kennwort ein."),
                Nachricht(sender: .alvin, text: "Es riecht nach Popcorn, aber wer hat den Filmabend geplant?")
            ],
            question: "Welcher Film liegt auf dem Couchtisch?",
            answer: "gadget agents",
            tips: [
                Tipp(text: "Auf dem Tisch liegt eine DVD-Hülle."),
                Tipp(text: "Schau auf die Rückseite der Hülle für das Passwort.", isCritical: true)
            ],
            successMessage: "Genau! Damit öffnen sich die Türen zum nächsten Raum.",
            codeFragment: "GA",
            type: .question
        )
    }

    private func makeLibraryStation() -> Station {
        Station(
            title: "Geheime Bibliothek",
            narrative: [
                Nachricht(sender: .alvin, text: "Gut gemacht! Jetzt schnell in die Bibliothek."),
                Nachricht(sender: .alvin, text: "Zwischen den dicken Wälzern steckt ein Briefumschlag."),
                Nachricht(sender: .system, text: "Im Umschlag findest du eine verschlüsselte Notiz.")
            ],
            question: "Welche Jahreszahl verbirgt sich im Rätsel?",
            answer: "1985",
            tips: [
                Tipp(text: "Die Notiz spricht von dem Jahr, in dem Alvin das erste Gadget baute."),
                Tipp(text: "Auf dem Foto an der Wand steht eine Widmung mit der gesuchten Zahl.")
            ],
            successMessage: "Exzellent! Der Code war schwieriger als gedacht.",
            codeFragment: "19",
            type: .question
        )
    }

    private func makeFinalStation() -> Station {
        Station(
            title: "Tresorraum",
            narrative: [
                Nachricht(sender: .alvin, text: "Letzte Etappe! Der Tresor erwartet dich."),
                Nachricht(sender: .system, text: "Setze alle Codefragmente zusammen, um den Tresor zu öffnen."),
                Nachricht(sender: .alvin, text: "Wenn er aufspringt, wartet eine Überraschung!")
            ],
            question: "Wie lautet der vollständige Code?",
            answer: "GA1985",
            tips: [
                Tipp(text: "Du brauchst alle Fragmente aus den vorherigen Stationen."),
                Tipp(text: "Ordne sie in der Reihenfolge der Stationen an.")
            ],
            successMessage: "Der Tresor öffnet sich und Alvin applaudiert!",
            codeFragment: "",
            type: .finale
        )
    }
}
