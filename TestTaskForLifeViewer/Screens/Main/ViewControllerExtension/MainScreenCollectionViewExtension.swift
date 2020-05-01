import UIKit
import RxSwift
import RxCocoa

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoWidgetCell.cellId, for: indexPath) as? PhotoWidgetCell else {fatalError()}
        
        var photos = viewModel.getPhotos()
        
        if let photos = photos, !photos.isEmpty {
            cell.setupWithPhoto(images: photos)
        } else {
            cell.setupEmptyPhoto()
        }
        
        viewModel.photos.asObservable().observeOn(MainScheduler.instance).bind { (mediaItem) in
            photos = self.viewModel.getPhotos()
            
            if let photos = photos, !photos.isEmpty {
                cell.setupWithPhoto(images: photos)
            } else {
                cell.setupEmptyPhoto()
            }
        }.disposed(by: self.bag)
        
        cell.setupDidTapAction {
            DispatchQueue.main.async {
                if let photos = photos, !photos.isEmpty {
                    self.presentPhotoView()
                } else {
                    self.openImagePicker()
                }
            }
        }
        
        return cell
    }
}
