import UIKit
import RxSwift
import RxCocoa

enum PhotoWidgetCellState {
    case empty
    case withPhotos
}

class PhotoWidgetCell: UICollectionViewCell {
    static let cellId = "PhotoWidgetCell"
    
    //MARK: For empty type
    let titleLabel = UILabel()
    let cameraIconImageView = UIImageView()
    
    //MARK: For withPhotos type
    let scrollView = UIScrollView()
    let pageControll = UIPageControl()
    let fadeView = UIView()
    
    private var type: PhotoWidgetCellState?
    private var photos: [UIImage]?
    private let bag = DisposeBag()
    
    var didTap: (() -> Void)?
    var photosPages = [UIImageView]()
    var pageScrollingTimer = Timer()
    var pageAutoScrollCounter = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAction))
        
        titleLabel.text = "Attach Photo"
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = Fonts.mediumSeventeen
        titleLabel.textColor = Colors.whiteColor
        addSubview(titleLabel)
        
        cameraIconImageView.image = Icons.cameraIcon
        cameraIconImageView.contentMode = .scaleAspectFit
        addSubview(cameraIconImageView)
        
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.addGestureRecognizer(gestureRecognizer)
        addSubview(scrollView)
        
        fadeView.isUserInteractionEnabled = true
        fadeView.addGestureRecognizer(gestureRecognizer)
        addSubview(fadeView)
        
        addSubview(pageControll)
    }
    
    func setupDidTapAction(didTap: @escaping() -> Void) {
        self.didTap = didTap
    }
    
    @objc private func didTapAction() {
        self.didTap?()
    }
    
    func setupEmptyPhoto() {
        self.type = PhotoWidgetCellState.empty
        backgroundColor = Colors.pinkColor
        fadeView.backgroundColor = Colors.clearColor
        
        //MARK: Show needed UI elemtns and hide unneeded
        titleLabel.isHidden = false
        cameraIconImageView.isHidden = false
        pageControll.isHidden = true
        scrollView.isHidden = true
        
        layoutSubviews()
    }
    
    func setupWithPhoto(images: [UIImage]) {
        type = PhotoWidgetCellState.withPhotos
        photos = images
        
        backgroundColor = Colors.whiteColor
        fadeView.backgroundColor = Colors.blackColor.withAlphaComponent(0.3)
        
        //MARK: Show needed UI elemtns and hide unneeded
        titleLabel.isHidden = true
        cameraIconImageView.isHidden = true
        scrollView.isHidden = false
        
        setupScrollView()
        
        //MARK: Remove page controll and animation setting up when is only one image in arr
        if images.count > 1 {
            pageControll.isHidden = false
            pageControll.currentPage = 0
            pageControll.numberOfPages = images.count
            
            self.pageScrollingTimer.invalidate()
            self.pageAutoScrollCounter = 0
            
            startPageScrollingTimer()
            scrollView.rx.didEndDecelerating.bind(onNext: scrollViewScrolledByUser).disposed(by: bag)
        } else {
            pageControll.isHidden = true
        }
        
        layoutSubviews()
    }
    
    func scrollViewScrolledByUser() { pageAutoScrollCounter = 0 }
    
    private func setupScrollView() {
        guard let photos = self.photos else {return}
        
        //MARK: Clear arrays of photos and subviews on scroll view 
        photosPages = []
        scrollView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        for photo in photos {
            let imageView = UIImageView(image: photo)
            scrollView.addSubview(imageView)
            photosPages.append(imageView)
        }
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        
        fadeView.pin.all()
        
        switch self.type {
        case .empty:
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
        case .withPhotos:
            scrollView.pin.all()
            
            pageControll.pin
                .bottom(8)
                .sizeToFit()
                .hCenter()
            
            let contentWidth: CGFloat = scrollView.frame.width * CGFloat(photosPages.count)
            scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.frame.height)
            
            for (index, page) in photosPages.enumerated() {
                page.pin
                    .top()
                    .bottom()
                    .left(scrollView.frame.width * CGFloat(index))
                    .width(scrollView.frame.width)
            }
        default: break
        }
    }
}
