import UIKit

/// Displays a single chat message in the conversation list.
final class ChatMessageCell: UITableViewCell {
    static let reuseIdentifier = "ChatMessageCell"

    private let messageLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    /// Configures the label with the provided message information.
    func apply(message: Nachricht) {
        messageLabel.text = message.text
        switch message.sender {
        case .spieler:
            contentView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
            messageLabel.textAlignment = .right
        case .alvin:
            contentView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
            messageLabel.textAlignment = .left
        case .system:
            contentView.backgroundColor = UIColor.secondarySystemBackground
            messageLabel.textAlignment = .center
        }
    }

    private func configure() {
        selectionStyle = .none
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageLabel)

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
