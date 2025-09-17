import UIKit

/// Input accessory view that allows the player to send messages.
final class ChatInputView: UIView {

    var onSendTapped: ((String) -> Void)?

    private let textField = UITextField()
    private let sendButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        backgroundColor = .systemBackground
        textField.placeholder = "Antwort eingeben"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false

        sendButton.setTitle("Senden", for: .normal)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(textField)
        addSubview(sendButton)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            textField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),

            sendButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 8),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            sendButton.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 80),

            heightAnchor.constraint(equalTo: textField.heightAnchor, constant: 16)
        ])
    }

    @objc private func sendTapped() {
        let text = textField.text ?? ""
        textField.text = nil
        onSendTapped?(text)
    }
}
