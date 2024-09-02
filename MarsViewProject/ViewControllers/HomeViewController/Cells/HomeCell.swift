

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet weak var roverLabel: UILabel!
    @IBOutlet weak var roverTextLabel: UILabel!
    @IBOutlet weak var cameraTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var marsImageView: UIImageView!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var showImageButton: UIButton!
    
    weak var delegate: HomeCellDelegate?
    var photo: Photo?
       
    override func awakeFromNib() {
        super.awakeFromNib()
        createView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func createView() {
        frontView.layer.cornerRadius = 30
        marsImageView.layer.cornerRadius = 20
        frontView.layer.shadowColor = UIColor.black.cgColor
        frontView.layer.shadowOpacity = 0.1
        frontView.layer.shadowOffset = CGSize(width: 0, height: 1)
        frontView.layer.shadowRadius = 10
        showImageButton.setTitle("", for: .normal)
    }
    
    @IBAction func showImageButtonAction(_ sender: UIButton){
        if let photo = photo {
                   delegate?.homeCell(self, didTapShowImageFor: photo)
               }
    }
}
