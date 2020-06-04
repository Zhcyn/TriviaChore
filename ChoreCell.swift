import UIKit
class ChoreCell: UITableViewCell {
    @IBOutlet weak var choreName: UILabel!
    @IBOutlet weak var completionDate: UILabel!
    @IBOutlet weak var choreNotes: UITextView!
    func configureCell(chore: ChoreEvent) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        choreName.text = chore.choreType?.name
        if chore.date != nil {
            completionDate.text = (chore.date as! Date).getElapsedInterval()
        } else {
            completionDate.text = "No Entries"
        }
        choreNotes.text = chore.notes
        choreNotes!.layer.borderWidth = 1
        choreNotes!.layer.borderColor = UIColor.black.cgColor
    }
}
