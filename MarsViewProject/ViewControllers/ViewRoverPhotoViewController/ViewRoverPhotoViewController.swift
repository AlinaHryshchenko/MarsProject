
import UIKit

class ViewRoverPhotoViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    
    var photoURLs: [String] = []
    var initialIndex: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        createCollectionView()
        createView()
        
        if let initialIndex = initialIndex {
                   collectionView.scrollToItem(at: initialIndex, at: .centeredHorizontally, animated: false)
               }
    }
    
    func createCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ViewCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ViewCollectionCell")
               if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                   layout.scrollDirection = .horizontal
                   layout.minimumLineSpacing = 0
               }
               collectionView.isPagingEnabled = true
    }
    
    private func createView() {
        cancelButton.setTitle("", for: .normal)
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
extension ViewRoverPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return photoURLs.count
        
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewCollectionCell", for: indexPath) as! ViewCollectionCell
          cell.configure(with: photoURLs[indexPath.item])
          return cell
      }
      
      // MARK: - UICollectionViewDelegateFlowLayout
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
            
      }
    
    
    
    
}
