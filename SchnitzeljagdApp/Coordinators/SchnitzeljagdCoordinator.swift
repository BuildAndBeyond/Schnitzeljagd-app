import UIKit

/// Handles the Schnitzeljagd flow and presents the chat interface.
final class SchnitzeljagdCoordinator {

    private let navigationController: UINavigationController
    private let repository: StationsRepositoryProtocol
    private let persistenceService: ProgressPersistenceProtocol

    init(
        navigationController: UINavigationController,
        repository: StationsRepositoryProtocol,
        persistenceService: ProgressPersistenceProtocol
    ) {
        self.navigationController = navigationController
        self.repository = repository
        self.persistenceService = persistenceService
    }

    func start() {
        let viewModel = SchnitzeljagdViewModel(
            repository: repository,
            persistenceService: persistenceService
        )
        viewModel.onShowTresorSuccess = { [weak self] in
            self?.presentTresorCelebration()
        }
        let controller = ChatViewController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: false)
    }

    private func presentTresorCelebration() {
        let alert = UIAlertController(
            title: "Mission erfüllt",
            message: "Der Tresor ist offen und Alvin jubelt!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Weiter", style: .default))
        navigationController.present(alert, animated: true)
    }
}
