import UIKit

extension PhotoWidgetCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControll.currentPage = Int(pageNumber)
    }
}
