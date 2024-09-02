

import CoreData
import UIKit

final class CoreDataService {
    func fetchFilters(completion: @escaping (Result<[FiltersMode], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FiltersMode> = FiltersMode.fetchRequest()
        
        do {
            let filters = try context.fetch(fetchRequest)
            completion(.success(filters))
        } catch let error {
            print("Failed to fetch filters: \(error)")
            completion(.failure(error))
        }
    }
}
