import UIKit

/// Shows the Schnitzeljagd conversation and forwards user interactions to the view model.
final class ChatViewController: UIViewController {

    private let viewModel: SchnitzeljagdViewModel
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let dataSource = ChatMessagesDataSource()
    private let inputBar = ChatInputView()

    init(viewModel: SchnitzeljagdViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Schnitzeljagd"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        setupNavigation()
        bindViewModel()
        viewModel.start()
    }

    override var inputAccessoryView: UIView? {
        return inputBar
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .interactive
        tableView.dataSource = dataSource
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: ChatMessageCell.reuseIdentifier)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Tipp",
            style: .plain,
            target: self,
            action: #selector(tipTapped)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Reset",
            style: .plain,
            target: self,
            action: #selector(resetTapped)
        )
        inputBar.onSendTapped = { [weak self] text in
            self?.viewModel.submit(answer: text)
        }
    }

    private func bindViewModel() {
        viewModel.onMessagesUpdated = { [weak self] messages in
            guard let self = self else { return }
            self.dataSource.update(messages: messages, in: self.tableView)
            let lastRow = max(messages.count - 1, 0)
            let indexPath = IndexPath(row: lastRow, section: 0)
            if messages.isEmpty { return }
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }

        viewModel.onShowSuccess = { [weak self] message in
            self?.showToast(text: message)
        }

        viewModel.onShowFailure = { [weak self] message in
            self?.showToast(text: message)
        }

        viewModel.onShowTresorSuccess = { [weak self] in
            self?.presentTresorSuccess()
        }
    }

    @objc private func tipTapped() {
        viewModel.requestTip()
    }

    @objc private func resetTapped() {
        viewModel.resetProgress()
    }

    private func showToast(text: String) {
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true)
        }
    }

    private func presentTresorSuccess() {
        let alert = UIAlertController(title: "Geschafft!", message: "Der Tresor ist offen!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Feiern", style: .default))
        present(alert, animated: true)
    }
}
