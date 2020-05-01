import UIKit
import AXPhotoViewer

extension MainScreenViewController {
    
    func presentPhotoView() {
        guard let photos = self.viewModel.getPhotos() else {return}
        
        //MARK: Init Photo preview library with data source
        let axPhotos = prepearImageForAxPhotoViewer(images: photos)
        let dataSource = AXPhotosDataSource(photos: axPhotos)
        let photosViewController = AXPhotosViewController(dataSource: dataSource)
        
        //MARK: Setup buttons
        let editButton = UIButton()
        editButton.setTitle("Edit", for: .normal)
        let editButtonItem = UIBarButtonItem(customView: editButton)
        
        let closeButton = UIButton()
        closeButton.setTitle("Close", for: .normal)
        let closeButtonItem = UIBarButtonItem(customView: closeButton)
        
        //MARK: Bind close button
        closeButton.rx.tap.bind { (_) in
            photosViewController.dismiss(animated: true)
        }.disposed(by: self.bag)
        
        
        //MARK: Bind to edit button
        editButton.rx.tap.bind { (_) in
            //MARK: Present action sheet
            self.presentAlertController(photosViewController: photosViewController, addMorePhotos: {
                photosViewController.dismiss(animated: true) { self.openImagePicker() }
            }) {
                //MARK: Get current page index
                let index = photosViewController.currentPhotoViewController?.pageIndex ?? 0
                
                //MARK: Delete image at index
                self.viewModel.delete(imageAtIndex: index)
                
                let _photos = self.viewModel.getPhotos()

                guard let photos = _photos, photos.isEmpty == false else {
                    photosViewController.dismiss(animated: true, completion: nil)
                    return
                }
                
                //MARK: Get photos
                let axPhotos = self.prepearImageForAxPhotoViewer(images: photos)
                
                if photos.count == 1 {
                    //MARK: Remove title if is ony one photo
                    photosViewController.overlayView.title = ""
                    //MARK: Set data source
                    let dataSource = AXPhotosDataSource(photos: axPhotos, initialPhotoIndex: 0)
                    photosViewController.dataSource = dataSource
                } else {
                    //MARK: Get new index
                    let newIndex = index - 1
                    
                    //MARK: Set data source
                    let dataSource = AXPhotosDataSource(photos: axPhotos, initialPhotoIndex: newIndex)
                    photosViewController.dataSource = dataSource
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
            photos.append(getPhoto(image: image))
        }
        
        return photos
    }
    
    private func getPhoto(image: UIImage) -> AXPhoto {
        let axPhotoObj = AXPhoto(attributedTitle: nil, attributedDescription: nil, attributedCredit: nil, imageData: nil, image: image, url: nil)
        return axPhotoObj
    }
}
