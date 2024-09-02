

import Foundation

struct Rover: Codable {
    let id: Int?
    let name, landingDate, launchDate, status: String?
    let maxSol: Int?
    let maxDate: String?
    let totalPhotos: Int?
    let cameras: [CameraElement]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case landingDate = "landing_date"
        case launchDate = "launch_date"
        case status
        case maxSol = "max_sol"
        case maxDate = "max_date"
        case totalPhotos = "total_photos"
        case cameras
    }
}
