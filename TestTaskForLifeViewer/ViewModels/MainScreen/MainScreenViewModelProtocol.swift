import Foundation
import RxSwift
import RxCocoa
import YPImagePicker

protocol MainScreenViewModelProtocol {
    var photos: BehaviorRelay<[YPMediaPhoto]?> {get}
    
    func delete(imageAtIndex: Int)
    func setPhotos(photos: [YPMediaPhoto]?)
    func getPhotos() -> [UIImage]?
}
