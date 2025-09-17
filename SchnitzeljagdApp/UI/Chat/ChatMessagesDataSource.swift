import UIKit

/// Provides a simple data source for the chat messages table view.
final class ChatMessagesDataSource: NSObject, UITableViewDataSource {

    private var messages: [Nachricht] = []

    func update(messages: [Nachricht], in tableView: UITableView) {
        self.messages = messages
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatMessageCell.reuseIdentifier, for: indexPath) as? ChatMessageCell else {
            return UITableViewCell()
        }
        cell.apply(message: messages[indexPath.row])
        return cell
    }
}
