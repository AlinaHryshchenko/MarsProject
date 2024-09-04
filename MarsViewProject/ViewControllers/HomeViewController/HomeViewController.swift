

import UIKit
import CoreData

class HomeViewController: UIViewController, FilterSelectionDelegate, HistoryViewControllerDelegate {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var roverFilterButton: UIButton!
    @IBOutlet weak var cameraFilterButton: UIButton!
    @IBOutlet weak var roverView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var roverFilterLabel: UILabel!
    @IBOutlet weak var cameraFilterLabel: UILabel!
    @IBOutlet weak var dateFilterLabel: UILabel!
    
    private var emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "EmptyImage")
        imageView.isHidden = true
        return imageView
    }()
    
    private var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select a rover, camera, and date to view photos."
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.isHidden = true
        return label
    }()
    
    private let viewModel = HomeViewModel()
    private let roundView = UIView()
    var selectedFilter: MarsViewFilters?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createTableView()
        createView()
        navigationController?.isNavigationBarHidden = true
        
        setupInitialData()
    }
    
    private func setupUI() {
           view.addSubview(emptyStateImageView)
           view.addSubview(emptyStateLabel)
        
           NSLayoutConstraint.activate([
               emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               emptyStateImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
               emptyStateImageView.widthAnchor.constraint(equalToConstant: 145),
               emptyStateImageView.heightAnchor.constraint(equalToConstant: 145),
               
               emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 21),
               emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
           ])
       }
    
    private func checkEmptyState() {
        let hasData = viewModel.numberOfPhotos > 0
        emptyStateImageView.isHidden = hasData
        emptyStateLabel.isHidden = hasData
        homeTableView.isHidden = !hasData
    }
    
    private func createTableView() {
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
    }
    
    private func createView() {
        calendarButton.setTitle("", for: .normal)
        roverFilterButton.setTitle("", for: .normal)
        addButton.setTitle("", for: .normal)
        cameraFilterButton.setTitle("", for: .normal)
        roverView.layer.cornerRadius = 10
        cameraView.layer.cornerRadius = 10
        roundView.frame.size = CGSize(width: 70, height: 70)
        roundView.backgroundColor = .blue
        roundView.layer.cornerRadius = 35
        roundView.layer.masksToBounds = true
        roundView.backgroundColor = UIColor(named: "accentOne")!
        roundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(roundView)
        
        NSLayoutConstraint.activate([
            roundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            roundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -21),
            roundView.widthAnchor.constraint(equalToConstant: 70),
            roundView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        let historyButton = UIButton(type: .custom)
        historyButton.setImage(UIImage(named: "History"), for: .normal)
        historyButton.translatesAutoresizingMaskIntoConstraints = false
        historyButton.addTarget(self, action: #selector(historyButtonTappedAction), for: .touchUpInside)
        
        roundView.addSubview(historyButton)
        
        NSLayoutConstraint.activate([
            historyButton.leadingAnchor.constraint(equalTo: roundView.leadingAnchor, constant: 13),
            historyButton.trailingAnchor.constraint(equalTo: roundView.trailingAnchor, constant: -13),
            historyButton.topAnchor.constraint(equalTo: roundView.topAnchor, constant: 13),
            historyButton.bottomAnchor.constraint(equalTo: roundView.bottomAnchor, constant: -13)
        ])
    }
    
    private func switchActivityIndicator(isOn: Bool) {
        activityIndicator.isHidden = !isOn
        if isOn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    private func setupInitialData() {
        switchActivityIndicator(isOn: true)
        
        viewModel.fetchFilters { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    updateData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async { [weak self] in
                    self?.checkEmptyState()
                    self?.switchActivityIndicator(isOn: false)
                }
            }
        }
        
        
        func updateData() {
            guard
                let selectedFilter = viewModel.filters.last,
                let filtersDate = selectedFilter.selectedDate
            else {
                didSelectAllRovers()
                didSelectAllCameras()
                updateTableViewData()
                
                return
            }
            
            viewModel.selectedDate = selectedFilter.selectedDate
            viewModel.selectedRover = selectedFilter.nameRover
            viewModel.selectedCamera = selectedFilter.nameCamera
            
            roverFilterLabel.text = selectedFilter.nameRover
            cameraFilterLabel.text = selectedFilter.nameCamera
            
            didSelectDate(filtersDate)
            
            updateTableViewData()
        }
    }
    
    func didSelectRover(_ rover: Rover) {
        roverFilterLabel.text = rover.name
        viewModel.selectedRover = rover.name
        viewModel.selectedCamera = nil
        didSelectAllCameras()
        
        updateTableViewData()
    }
    
    func didSelectAllRovers() {
        roverFilterLabel.text = "All"
        viewModel.selectedRover = nil
        viewModel.selectedCamera = nil
        updateTableViewData()
    }
    
    func didSelectCamera(_ camera: CameraElement) {
        cameraFilterLabel.text = camera.fullName
        viewModel.selectedCamera = camera.name
        updateTableViewData()
    }
    
    func didSelectAllCameras() {
        cameraFilterLabel.text = "All"
        viewModel.selectedCamera = nil
        updateTableViewData()
    }
    
    func didSelectDate(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "MMMM d, yyyy"
        dateFilterLabel.text = dateFormatter.string(from: date)
        viewModel.selectedDate = date
        updateTableViewData()
    }
    
    private func updateTableViewData() {
        guard viewModel.selectedDate != nil else {
            switchActivityIndicator(isOn: false)
            checkEmptyState()
            return
        }
        
        switchActivityIndicator(isOn: true)
        
        viewModel.fetchPhotos {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                homeTableView.reloadData()
                switchActivityIndicator(isOn: false)
                checkEmptyState()
            }
        }
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func historyViewController(_ controller: MenuCardViewController, didSelectFilter filter: MarsViewFilters) {
        viewModel.selectedRover = filter.nameRover
        viewModel.selectedCamera = filter.nameCamera
        viewModel.selectedDate = filter.selectedDate
    
        updateFiltersUI()
        updateTableViewData()
        navigationController?.popViewController(animated: true)
    }
    
    private func updateFiltersUI() {
        if let selectedRover = viewModel.selectedRover {
            roverFilterLabel.text = selectedRover
        } else {
            roverFilterLabel.text = "All"
        }
        
        if let selectedCamera = viewModel.selectedCamera {
            cameraFilterLabel.text = selectedCamera
        } else {
            cameraFilterLabel.text = "All"
        }
        
        if let selectedDate = viewModel.selectedDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFilterLabel.text = dateFormatter.string(from: selectedDate)
        } else {
            dateFilterLabel.text = "Any Date"
        }
    }
    
    @IBAction func saveFilterButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let saveFiltersVC = storyboard.instantiateViewController(withIdentifier: "SaveFiltersViewController") as? SaveFiltersViewController {
            saveFiltersVC.viewModel = viewModel
            saveFiltersVC.modalPresentationStyle = .overCurrentContext
            saveFiltersVC.modalTransitionStyle = .crossDissolve
            present(saveFiltersVC, animated: true)
        }
    }
    
    private func saveCurrentFilters() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let newFilter = MarsViewFilters(context: context)
        newFilter.nameRover = viewModel.selectedRover ?? "All"
        newFilter.nameCamera = viewModel.selectedCamera ?? "All"
        newFilter.selectedDate = viewModel.selectedDate ?? Date()
        
        do {
            try context.save()
            print("Filter saved successfully.")
        } catch {
            print("Failed to save filter: \(error)")
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let historyVC = storyboard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
        navigationController?.pushViewController(historyVC, animated: true)
    }
    
    func historyButtonTapped() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func historyButtonTappedAction() {
        historyButtonTapped()
    }
    
    @IBAction func roverFilterButtonTapped(_ sender: UIButton) {
        if presentedViewController == nil {
            switchActivityIndicator(isOn: true)
            viewModel.fetchRovers {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
                    vc.initialLabelText = "Rover"
                    vc.isRoverSelection = true
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .crossDissolve
                    vc.rovers = self.viewModel.rovers
                    vc.delegate = self
                    
                    self.switchActivityIndicator(isOn: false)
                    
                    self.present(vc, animated: true)
                }
            }
        }
    }
    
    @IBAction func cameraFilterButtonTapped(_ sender: UIButton) {
        if let selectedRover = viewModel.selectedRover {
            let rover = viewModel.rovers.first { $0.name == selectedRover }
            showCameraFilter(for: rover?.cameras ?? [])
        } else {
            let allCameras = viewModel.rovers.flatMap { $0.cameras ?? [] }
            showCameraFilter(for: allCameras)
        }
        
    }
    
    private func showCameraFilter(for cameras: [CameraElement]) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        vc.initialLabelText = "Camera"
        vc.isRoverSelection = false
        vc.cameras = cameras
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @IBAction func dateFilterButtonTapped(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "DateViewController") as! DateViewController
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, HomeCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPhotos
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        
        let photo = viewModel.photo(at: indexPath.row)
        cell.photo = photo
        cell.delegate = self
        cell.roverTextLabel.text = photo.rover?.name
        
        if let earthDate = photo.earthDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: earthDate) {
                dateFormatter.dateFormat = "MMMM d, yyyy"
                cell.dateTextLabel.text = dateFormatter.string(from: date)
            }
        }
        
        let cameraLabelText = NSAttributedString(string: "Camera:  ", attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .light),
            .foregroundColor: UIColor(named: "layerTwo") ?? UIColor.gray
        ])
        
        let cameraNameText = NSAttributedString(string: photo.camera?.fullName ?? "", attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: UIColor.black
        ])
        
        let fullText = NSMutableAttributedString()
        fullText.append(cameraLabelText)
        fullText.append(cameraNameText)
        cell.cameraTextLabel.attributedText = fullText
        
        if let urlString = photo.imgSrc {
               cell.marsImageView.loadImageAndCache(urlString: urlString)
           } else {
               cell.marsImageView.image = nil
           }
        
        return cell
    }
    
    func homeCell(_ cell: HomeCell, didTapShowImageFor photo: Photo) {
        guard let indexPath = homeTableView.indexPath(for: cell) else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewPhotoVC = storyboard.instantiateViewController(withIdentifier: "ViewRoverPhotoViewController") as! ViewRoverPhotoViewController
        viewPhotoVC.photoURLs = viewModel.photos.map { $0.imgSrc ?? "" }
        viewPhotoVC.initialIndex = IndexPath(item: indexPath.row, section: 0)
        navigationController?.pushViewController(viewPhotoVC, animated: true)
    }
    
}
