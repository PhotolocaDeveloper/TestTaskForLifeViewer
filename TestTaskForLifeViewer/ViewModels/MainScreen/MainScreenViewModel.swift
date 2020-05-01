import Foundation
import RxSwift
import RxCocoa
import YPImagePicker

class MainScreenViewModel: MainScreenViewModelProtocol {
    
    var photos: BehaviorRelay<[YPMediaPhoto]?> = BehaviorRelay(value: nil)
    var viewedPhotoIndex: Int?
    
    func setPhotos(photos: [YPMediaPhoto]?) {
        if let photos = photos {
         
            let photosRxValue = self.photos.value
            
            if let photosValue = photosRxValue {
                var localPhotos = photosValue
                localPhotos.append(contentsOf: photos)
                self.photos.accept(localPhotos)
            } else {
                 self.photos.accept(photos)
            }
            
        } else {
            self.photos.accept(nil)
        }
    }
    
    func setPhotoIndex(_ index: Int) {
        self.viewedPhotoIndex = index
    }
    
    
    func delete(images: UIImage) {
        
    }
    
    func getPhotos() -> [UIImage]? {
        guard let photosWithMedia =  self.photos.value else {return nil}
        
        var images = [UIImage]()
        
        photosWithMedia.forEach { (mediaItem) in
            images.append(mediaItem.image)
        }
        
        return images
    }
}
