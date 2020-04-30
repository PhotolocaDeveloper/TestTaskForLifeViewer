import UIKit

enum PhotoWidgetCellState {
    case empty
    case withPhotos
}

class PhotoWidgetCell: UICollectionViewCell {
    static let cellId = "PhotoWidgetCell"
    
    let titleLabel = UILabel()
    let cameraIconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.pinkColor
        
        titleLabel.text = "Attach Photo"
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = Fonts.mediumSeventeen
        titleLabel.textColor = Colors.whiteColor
        addSubview(titleLabel)
        
        cameraIconImageView.image = Icons.cameraIcon
        cameraIconImageView.contentMode = .scaleAspectFit
        addSubview(cameraIconImageView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        
        cameraIconImageView.pin
            .right(8)
            .top(8)
            .width(20)
            .height(20)
        
        titleLabel.pin
            .left(8)
            .top(8)
            .right(to: cameraIconImageView.edge.left)
            .sizeToFit(.width)
        
    }
}
