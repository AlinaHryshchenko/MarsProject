

import Foundation
protocol HomeCellDelegate: AnyObject {
    func homeCell(_ cell: HomeCell, didTapShowImageFor photo: Photo)
}
