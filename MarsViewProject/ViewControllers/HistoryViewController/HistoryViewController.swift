

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var historyTableView: UITableView!
    
    var coreDataService = CoreDataService()
    
    var filters: [FiltersMode] = []
    private let viewModel = HomeViewModel()
    
    weak var delegate: HistoryViewControllerDelegate?
    weak var delegateFilter: FilterSelectionDelegate?
    
    private let emptyStateImageView: UIImageView = {
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
        label.text = "Browsing history is empty."
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createTableView()
        fetchFilters()
    }
    
    private func fetchFilters() {
        coreDataService.fetchFilters { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let filters):
                self.filters = filters
                self.historyTableView.reloadData()
                
                self.updateUI()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func createTableView() {
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.register(UINib(nibName: "HistoryCell", bundle: nil), forCellReuseIdentifier: "HistoryCell")
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
        
        cancelButton.setTitle("", for: .normal)
    }
    
    private func updateUI() {
            let hasData = !filters.isEmpty
            historyTableView.isHidden = !hasData
            emptyStateImageView.isHidden = hasData
            emptyStateLabel.isHidden = hasData
            historyTableView.reloadData()
        }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        let filter = filters[indexPath.row]
        cell.roverTextLabel.text = filter.roverName
        cell.cameraTextLabel.text = filter.cameraName
        if let date = filter.selectedDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            cell.dateTextLabel.text = dateFormatter.string(from: date)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedFilter = filters[indexPath.row]
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let menuCardVC = sb.instantiateViewController(withIdentifier: "MenuCardViewController") as? MenuCardViewController {
            menuCardVC.selectedFilter = selectedFilter
            
            if let homeVC = self.navigationController?.viewControllers.first(where: { $0 is HomeViewController }) as? HomeViewController {
                menuCardVC.delegate = homeVC
            }
            
            menuCardVC.onDeleteFilter = { [weak self] in
                self?.filters.remove(at: indexPath.row)
                self?.historyTableView.deleteRows(at: [indexPath], with: .automatic)
                self?.updateUI()
            }
            
            menuCardVC.modalPresentationStyle = .overCurrentContext
            menuCardVC.modalTransitionStyle = .crossDissolve
            present(menuCardVC, animated: true)
        }
    }
}
