import UIKit

extension PhotoWidgetCell {
    func startPageScrollingTimer() {
        self.pageScrollingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.pageAutoScrollTimerAction(animationDuration: 2, pageFlipTime: 4, pageReturnTime: 6)
        }
    }
    
    private func pageAutoScrollTimerAction(animationDuration: Double, pageFlipTime: Double, pageReturnTime: Double) {
        self.pageAutoScrollCounter += 1
        
        let currentPage: Int = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        if currentPage < self.photosPages.count - 1 {
            guard pageAutoScrollCounter >= Int(pageFlipTime) else {return}
            
            let currentOffset = scrollView.contentOffset.x
            let pageWidth = scrollView.frame.width
            self.scrollView.setContentOffset(CGPoint(x: currentOffset + pageWidth, y: 0), animated: true)
            self.pageAutoScrollCounter = 0
            self.pageControll.currentPage = currentPage
        } else if currentPage == photosPages.count - 1 {
            guard pageAutoScrollCounter >= Int(pageReturnTime) else {return}
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.pageAutoScrollCounter = 0
             self.pageControll.currentPage = currentPage
        }
    }
}


