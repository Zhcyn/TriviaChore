import UIKit
import CoreData
class SelectedChoreVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    var controller: NSFetchedResultsController<ChoreEvent>!
    var itemToEdit: ChoreType? 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if let title = itemToEdit?.name {
            self.title = title
        }
        attemptFetch()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func configureCell (cell: SelectedChoreCell, indexPath: NSIndexPath){
        let chore = controller.object(at: indexPath as IndexPath)
        cell.configureCell(chore: chore)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects, objs.count > 0 {
            let chore = objs[indexPath.row]
            performSegue(withIdentifier: "ChoreDetailsVC", sender: chore)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChoreDetailsVC" {
            if let destination = segue.destination as? ChoreDetailsVC {
                if let chore = sender as? ChoreEvent {
                    destination.itemToEdit = chore
                }
            }
        }
        if segue.identifier == "ChoreDetailsVCNew" {
            if let destination = segue.destination as? ChoreDetailsVC {
                destination.currentChoreType = self.itemToEdit
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedChoreCell", for: indexPath) as! SelectedChoreCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<ChoreEvent> = ChoreEvent.fetchRequest()
        let ascDateSort = NSSortDescriptor(key: "date", ascending: true)
        let descDateSort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.predicate = NSPredicate(format: "date != nil and choreType.name == %@", (itemToEdit?.name)!)
        if segment.selectedSegmentIndex == 0 {
            fetchRequest.sortDescriptors = [descDateSort]
        } else if segment.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [ascDateSort]
        }
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        self.controller = controller
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    @IBAction func segmentChanged(_ sender: Any) {
        attemptFetch()
        tableView.reloadData()
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case.update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! SelectedChoreCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }
}
