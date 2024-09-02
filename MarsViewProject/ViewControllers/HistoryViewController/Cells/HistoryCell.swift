

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var roverTextLabel: UILabel!
    @IBOutlet weak var cameraTextLabel: UILabel!
    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var frontView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
   
    func createView() {
        frontView.layer.cornerRadius = 30
        frontView.layer.shadowColor = UIColor.black.cgColor
        frontView.layer.shadowOpacity = 0.1
        frontView.layer.shadowOffset = CGSize(width: 0, height: 1)
        frontView.layer.shadowRadius = 10
    }
}
