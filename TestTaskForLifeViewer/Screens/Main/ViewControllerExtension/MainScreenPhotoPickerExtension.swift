import UIKit
import YPImagePicker

extension MainScreenViewController {
    func openImagePicker() {
        YPImagePickerConfiguration.shared = getImagePickerConfig()
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            var itemsToSave = [YPMediaPhoto]()
            
            for mediaItem in items {
                switch mediaItem {
                case .photo(p: let photo):
                    itemsToSave.append(photo)
                case .video: continue
                }
            }
            
            self.viewModel.setPhotos(photos: itemsToSave)
            picker.dismiss(animated: true, completion: nil)
        }
        self.present(picker, animated: true, completion: nil)
    }
    
    private func getImagePickerConfig() -> YPImagePickerConfiguration {
        var config = YPImagePickerConfiguration()
        config.library.options = nil
        config.library.onlySquare = false
        config.library.isSquareByDefault = true
        config.library.minWidthForItem = nil
        config.library.mediaType = YPlibraryMediaType.photo
        config.showsPhotoFilters = false
        config.library.defaultMultipleSelection = false
        config.library.maxNumberOfItems = 999
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 4
        config.library.spacingBetweenItems = 1.0
        config.library.skipSelectionsGallery = false
        config.library.preselectedItems = nil
        return config
    }
}
