

import Foundation
import CoreData
import UIKit

final class HomeViewModel {
    var rovers: [Rover] = []
    var selectedRover: String?
    var selectedCamera: String?
    var selectedDate: Date?
    var photos: [Photo] = []
    
    var filters: [FiltersMode] = []
    var allData: [Photo] = []
    var filteredData: [Photo] = []
    
    var numberOfPhotos: Int {
        return photos.count
    }
    
    var coreDataService = CoreDataService()
    
    func fetchRovers(completion: @escaping () -> Void) {
        NetworkService.shared.fetchRovers { rovers in
            self.rovers = rovers ?? []
            completion()
        }
    }
    func fetchPhotos(completion: @escaping () -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = (selectedDate != nil) ? dateFormatter.string(from: selectedDate!) : nil
        
        if selectedRover == nil {
            NetworkService.shared.fetchPhotosForAllRovers(rovers: self.rovers, date: formattedDate) { photos in
                self.photos = photos ?? []
                completion()
            }
        } else {
            if selectedCamera == nil || selectedCamera == "All" {
                NetworkService.shared.fetchPhotos(rover: selectedRover!, camera: nil, date: formattedDate) { photos in
                    self.photos = photos ?? []
                    completion()
                }
            } else {
                NetworkService.shared.fetchPhotos(rover: selectedRover!, camera: selectedCamera, date: formattedDate) { photos in
                    self.photos = photos ?? []
                    completion()
                }
            }
        }
        
    }
    
    func photo(at index: Int) -> Photo {
        return photos[index]
    }
    
    func fetchFilters(completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataService.fetchFilters { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let filters):
                self.filters = filters
                completion(.success(()))
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}
