import UIKit
class ChoreTypeCell: UITableViewCell {
    @IBOutlet weak var choreName: UILabel!
    @IBOutlet weak var completionDate: UILabel!
    @IBOutlet weak var choreNotes: UITextView!
    func configureCell(chore: ChoreType) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        choreName.text = chore.name
        choreNotes!.layer.borderWidth = 1
        choreNotes!.layer.borderColor = UIColor.black.cgColor
    }
}
