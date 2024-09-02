

import UIKit

class MenuCardViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var selectedFilter: FiltersMode?
    weak var delegate: HistoryViewControllerDelegate?
    var onDeleteFilter: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
    }
    
    func createView() {
        frontView.layer.cornerRadius = 30
        frontView.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 30
        cancelButton.layer.masksToBounds = true
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let cancel = NSAttributedString(
            string: "Cancel",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 18),
                .foregroundColor: UIColor.systemBlue
            ]
        )
        let delete = NSAttributedString(
            string: "Delete",
            attributes: [
                .foregroundColor: UIColor.systemRed
            ]
        )
        cancelButton.setAttributedTitle(cancel, for: .normal)
        deleteButton.setAttributedTitle(delete, for: .normal)
        
    }
    
    @IBAction func useButtonTapped(_ sender: UIButton) {
        if let filter = selectedFilter {
            delegate?.historyViewController(self, didSelectFilter: filter)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        deleteSelectedFilter()
        onDeleteFilter?()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func deleteSelectedFilter() {
        guard let filter = selectedFilter else { return }
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(filter)
        do {
            try context.save()
        } catch {
            print("Failed to delete filter: \(error)")
        }
    }
    
}
