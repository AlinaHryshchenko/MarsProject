

import Foundation

final class NetworkService {
    static let shared = NetworkService()
    
    var cachedRoversList: [Rover]?
    
    let apiKey = "5Fc6p18UVwLupLbHig0VBGnHVCbxbqUWf6mPCLqY"
    let baseURL = "https://api.nasa.gov/mars-photos/api/v1/rovers/"
    
    func fetchRovers(completion: @escaping ([Rover]?) -> Void) {
        if let cachedRoversList {
            completion(cachedRoversList)
            return
        }
        
        let urlString = "\(baseURL)?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }
            
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(RoversResponse.self, from: data)
                    
                    cachedRoversList = response.rovers
                    completion(response.rovers)
                    
                } catch {
                    print("Error decoding data: \(error)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    func fetchPhotos(rover: String, camera: String?, date: String?, completion: @escaping ([Photo]?) -> Void) {
        var urlString = "\(baseURL)\(rover)/photos?api_key=\(apiKey)"
        
        if let camera = camera {
            urlString += "&camera=\(camera)"
        }
        
        if let date = date {
            urlString += "&earth_date=\(date)"
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(PhotosResponse.self, from: data)
                    completion(response.photos)
                } catch {
                    print("Error decoding data: \(error)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    func fetchPhotosForAllRovers(rovers: [Rover], date: String?, completion: @escaping ([Photo]?) -> Void) {
        var allPhotos: [Photo] = []
        let group = DispatchGroup()
        
        for rover in rovers {
            group.enter()
            fetchPhotos(rover: rover.name!, camera: nil, date: date) { photos in
                if let photos = photos {
                    allPhotos.append(contentsOf: photos)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion(allPhotos)
        }
    }
    
}

