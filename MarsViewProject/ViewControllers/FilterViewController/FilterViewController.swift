
import UIKit

class FilterViewController: UIViewController {
    
    @IBOutlet weak var filterPicker: UIPickerView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var nameFilterLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var frontView: UIView!
    
    var rovers: [Rover] = []
    var cameras: [CameraElement] = []
    var delegate: FilterSelectionDelegate?
    var initialLabelText: String?
    var isRoverSelection: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterPicker.delegate = self
        filterPicker.dataSource = self
        createView()
        nameFilterLabel.text = initialLabelText
        if isRoverSelection {
            let allRovers = Rover(id: nil, name: "All", landingDate: nil, launchDate: nil, status: nil, maxSol: nil, maxDate: nil, totalPhotos: nil, cameras: nil)
            self.rovers = [allRovers] + rovers
        } else {
            let allCameras = CameraElement(name: "All", fullName: "All")
            self.cameras = [allCameras] + cameras
        }
    }
    
    private func createView() {
        cancelButton.setTitle("", for: .normal)
        confirmButton.setTitle("", for: .normal)
        frontView.layer.cornerRadius = 50
        frontView.layer.shadowColor = UIColor.black.cgColor
        frontView.layer.shadowOpacity = 0.3
        frontView.layer.shadowOffset = CGSize(width: 0, height: 2)
        frontView.layer.shadowRadius = 10
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        let selectedRow = filterPicker.selectedRow(inComponent: 0)
        
        if isRoverSelection {
            let selectedRover = rovers[selectedRow]
            if selectedRover.name == "All" {
                delegate?.didSelectAllRovers()
            } else {
                delegate?.didSelectRover(selectedRover)
            }
        } else {
            let selectedCamera = cameras[selectedRow]
            if selectedCamera.name == "All" {
                delegate?.didSelectAllCameras()
            } else {
                delegate?.didSelectCamera(selectedCamera)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return isRoverSelection ? rovers.count : cameras.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if isRoverSelection {
            return rovers[row].name
        } else {
            return cameras[row].fullName
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if isRoverSelection {
        } else {
            let selectedCamera = cameras[row]
            if selectedCamera.name == "All" {
                delegate?.didSelectAllCameras()
            } else {
                delegate?.didSelectCamera(selectedCamera)
            }
        }
    }
}
