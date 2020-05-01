import UIKit
import AXPhotoViewer

extension MainScreenViewController: AXPhotosViewControllerDelegate {
    
    func presentPhotoView() {
        guard let photos = self.viewModel.getPhotos() else {return}
        let axPhotos = prepearImageForAxPhotoViewer(images: photos)
        let dataSource = AXPhotosDataSource(photos: axPhotos)
        let photosViewController = AXPhotosViewController(dataSource: dataSource)
        photosViewController.delegate = self
        
        let editButton = UIButton()
        editButton.setTitle("Edit", for: .normal)
        let editButtonItem = UIBarButtonItem(customView: editButton)
        
        let closeButton = UIButton()
        closeButton.setTitle("Close", for: .normal)
        let closeButtonItem = UIBarButtonItem(customView: closeButton)
        
        closeButton.rx.tap.bind { (_) in
            photosViewController.dismiss(animated: true)
        }.disposed(by: self.bag)
        
        editButton.rx.tap.bind { (_) in
            self.presentAlertController(photosViewController: photosViewController, addMorePhotos: {
                photosViewController.dismiss(animated: true) { self.openImagePicker() }
            }) {
                let index = photosViewController.currentPhotoViewController?.pageIndex ?? 0
                
                self.viewModel.delete(imageAtIndex: index)
                
                let _photos = self.viewModel.getPhotos()

                guard let photos = _photos, photos.isEmpty == false else {
                    photosViewController.dismiss(animated: true, completion: nil)
                    return
                }
                
                let axPhotos = self.prepearImageForAxPhotoViewer(images: photos)
                let dataSource = AXPhotosDataSource(photos: axPhotos)
                photosViewController.dataSource = dataSource
                
                if photos.count == 1 {
                    photosViewController.overlayView.title = ""
                }
            }
        }.disposed(by: self.bag)
        
        photosViewController.overlayView.rightBarButtonItem? = editButtonItem
        photosViewController.overlayView.leftBarButtonItem? = closeButtonItem
        
        self.present(photosViewController, animated: true)
    }
    
    private func presentAlertController(
        photosViewController: AXPhotosViewController,
        addMorePhotos: @escaping() -> Void,
        deleteThisPhotos: @escaping() -> Void) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
       
        let addmorePhotos = UIAlertAction(title: "Add more photos", style: .default) { (_) in
            addMorePhotos()
        }
        
        let deleteThisPhoto = UIAlertAction(title: "Delete this photos", style: .default) { (_) in
            deleteThisPhotos()
        }
        
        let closeAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addmorePhotos)
        alertController.addAction(deleteThisPhoto)
        alertController.addAction(closeAction)
        
        photosViewController.present(alertController, animated: true, completion: nil)
    }
    
    private func prepearImageForAxPhotoViewer(images: [UIImage]) -> [AXPhoto] {
        var photos = [AXPhoto]()
        
        for image in images {
            let axPhotoObj = AXPhoto(attributedTitle: nil, attributedDescription: nil, attributedCredit: nil, imageData: nil, image: image, url: nil)
            photos.append(axPhotoObj)
        }
        
        return photos
    }
}
