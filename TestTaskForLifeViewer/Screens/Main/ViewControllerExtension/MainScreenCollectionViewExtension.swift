import UIKit
import RxSwift
import RxCocoa

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoWidgetCell.cellId, for: indexPath) as? PhotoWidgetCell else {fatalError()}
        
        let photos = viewModel.getPhotos()
        
        if photos == nil || photos?.isEmpty == true {
            cell.setupEmptyPhoto()
        }
        
        viewModel.photos.asObservable().observeOn(MainScheduler.instance).bind { (mediaItem) in
            guard mediaItem != nil else {return}
            let photos = self.viewModel.getPhotos()
            if let photos = photos, !photos.isEmpty {
                cell.setupWithPhoto(images: photos)
            } else {
                cell.setupEmptyPhoto()
            }
        }.disposed(by: self.bag)
        
        cell.setupDidTapAction {
            if let photos = photos, !photos.isEmpty {
                print("Open photos preview")
            } else {
                self.openImagePicker()
            }
        }
        
        return cell
    }
}
