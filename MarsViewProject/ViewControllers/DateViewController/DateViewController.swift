
import UIKit

class DateViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    weak var delegate: FilterSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
    }
    
    private func createView() {
        cancelButton.setTitle("", for: .normal)
        confirmButton.setTitle("", for: .normal)
        backgroundView.layer.cornerRadius = 40
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOpacity = 0.1
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        backgroundView.layer.shadowRadius = 10
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }

    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        delegate?.didSelectDate(datePicker.date)
        dismiss(animated: true, completion: nil)
    }
    
}

