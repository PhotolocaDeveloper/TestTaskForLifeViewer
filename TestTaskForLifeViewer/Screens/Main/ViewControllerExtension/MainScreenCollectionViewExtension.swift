import UIKit
import RxSwift
import RxCocoa

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photos = viewModel.getPhotos()
        
        if let photos = photos, !photos.isEmpty {
            print("Open photos preview")
        } else {
            openImagePicker()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoWidgetCell.cellId, for: indexPath) as? PhotoWidgetCell else {fatalError()}
        
        let photos = viewModel.getPhotos()
        if let photos = photos, !photos.isEmpty {
            cell.setupCell(type: .withPhotos, photos: photos)
        } else {
            cell.setupCell(type: .empty)
        }
        
        viewModel.photos.asObservable().observeOn(MainScheduler.instance).bind { (mediaItem) in
            guard mediaItem != nil else {return}
            let photos = self.viewModel.getPhotos()
            
            if let photos = photos, !photos.isEmpty {
                cell.setupCell(type: .withPhotos, photos: photos)
            } else {
                cell.setupCell(type: .empty)
            }
            
        }.disposed(by: self.bag)
        
        return cell
    }
}
