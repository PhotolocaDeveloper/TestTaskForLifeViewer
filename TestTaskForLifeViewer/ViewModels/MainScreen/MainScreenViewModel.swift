import Foundation
import RxSwift
import RxCocoa
import YPImagePicker

class MainScreenViewModel: MainScreenViewModelProtocol {
    var photos: BehaviorRelay<[YPMediaPhoto]?> = BehaviorRelay(value: nil)
    
    func setPhotos(photos: [YPMediaPhoto]?) {
        self.photos.accept(photos)
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
