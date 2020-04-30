import UIKit
import PinLayout
import AlignedCollectionViewFlowLayout

final class MainScreenView: UIView {
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let widgetsCollectionView: UICollectionView
    
    init() {
        let widgetCollectionViewLayout = AlignedCollectionViewFlowLayout()
        widgetCollectionViewLayout.horizontalAlignment = .left
        
        let spacingBetweenItems: CGFloat = 5
        let spacingToScreenEdges: CGFloat = 32
        let itemWidth: CGFloat = (UIScreen.main.bounds.width / 2) - spacingToScreenEdges - spacingBetweenItems
        
        widgetCollectionViewLayout.estimatedItemSize = CGSize(width: itemWidth, height: itemWidth)
        widgetsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: widgetCollectionViewLayout)
        
        super.init(frame: .zero)
        backgroundColor = Colors.whiteColor
        
        titleLabel.text = "My day"
        titleLabel.textColor = Colors.blackColor
        titleLabel.font = Fonts.semiBoldThirtyOne
        addSubview(titleLabel)
        
        dateLabel.text = "Tuesday, 5 May 2029"
        dateLabel.textColor = Colors.grayColor
        dateLabel.font = Fonts.regularSeventeen
        addSubview(dateLabel)
        
        widgetsCollectionView.backgroundColor = Colors.whiteColor
        addSubview(widgetsCollectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.pin
            .top(safeAreaInsets.top + 20)
            .left(16)
            .right(16)
            .sizeToFit(.width)
        
        dateLabel.pin
            .top(to: titleLabel.edge.bottom)
            .marginTop(8)
            .left(16)
            .right(16)
            .sizeToFit(.width)
        
        widgetsCollectionView.pin
            .top(to: dateLabel.edge.bottom)
            .marginTop(8)
            .left(16)
            .right(16)
            .bottom(safeAreaInsets.bottom)
    }
}
