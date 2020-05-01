import Foundation
import RxSwift
import RxCocoa
import YPImagePicker

class MainScreenViewModel: MainScreenViewModelProtocol {
    var photos: BehaviorRelay<[YPMediaPhoto]?> = BehaviorRelay(value: nil)
    
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
    
    func delete(imageAtIndex: Int) {
        var photosRxValue = self.photos.value
        photosRxValue?.remove(at: imageAtIndex)
        if photosRxValue?.isEmpty ?? true {
            self.photos.accept(nil)
        } else {
            self.photos.accept(photosRxValue)
        }
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
