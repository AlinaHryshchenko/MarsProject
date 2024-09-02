

import Foundation
protocol HistoryViewControllerDelegate: AnyObject {
    
    func historyViewController(_ controller: MenuCardViewController, didSelectFilter filter: FiltersMode)

}
