import UIKit

/// Coordinates the initial application flow and root navigation.
final class AppCoordinator {

    private let window: UIWindow
    private let navigationController = UINavigationController()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let repository = AlvinStationsRepository()
        let persistence = ProgressPersistenceService(userDefaults: .standard)
        let schnitzeljagdCoordinator = SchnitzeljagdCoordinator(
            navigationController: navigationController,
            repository: repository,
            persistenceService: persistence
        )
        schnitzeljagdCoordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
