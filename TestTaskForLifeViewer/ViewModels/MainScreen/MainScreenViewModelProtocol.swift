import Foundation
import RxSwift
import RxCocoa
import YPImagePicker

protocol MainScreenViewModelProtocol {
    var photos: BehaviorRelay<[YPMediaPhoto]?> {get}
    var viewedPhotoIndex: Int? {get}
    
    func delete(images: UIImage)
    func setPhotoIndex(_ index: Int)
    func setPhotos(photos: [YPMediaPhoto]?)
    func getPhotos() -> [UIImage]?
}
