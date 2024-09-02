

import UIKit

class SaveFiltersViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    var viewModel: HomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        createView()
    }
    
    private func createView() {
        frontView.layer.cornerRadius = 30
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let saveButtonTitle = NSAttributedString(
            string: "Save",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 18),
                .foregroundColor: UIColor.systemBlue
            ]
        )
        saveButton.setAttributedTitle(saveButtonTitle, for: .normal)
    }

    private func saveCurrentFilters() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
               let context = appDelegate.persistentContainer.viewContext
        
        let roverName = viewModel.selectedRover ?? "All"
            let cameraName = viewModel.selectedCamera ?? "All"
            let selectedDate = viewModel.selectedDate ?? Date()
            
            let newFilter = FiltersMode(context: context)
            newFilter.roverName = roverName
            newFilter.cameraName = cameraName
            newFilter.selectedDate = selectedDate
            
            do {
                try context.save()
            } catch {
                print("Failed to save filter: \(error)")
            }
    }

       private func navigateToHistoryScreen() {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let historyVC = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
           navigationController?.pushViewController(historyVC, animated: true)
       }
    
    @IBAction func saveButton(_ sender: UIButton) {
        saveCurrentFilters()
        dismiss(animated: true, completion: nil)
        }
        
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
