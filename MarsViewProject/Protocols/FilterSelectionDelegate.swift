
import Foundation
protocol FilterSelectionDelegate: AnyObject {
    func didSelectRover(_ rover: Rover)
    func didSelectCamera(_ camera: CameraElement)
    func didSelectDate(_ date: Date)
    func didSelectAllRovers()
    func didSelectAllCameras()
    
}
