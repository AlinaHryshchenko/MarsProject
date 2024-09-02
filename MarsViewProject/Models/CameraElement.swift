

import Foundation
struct CameraElement: Codable {
    let name, fullName: String?

    enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
    }
}
