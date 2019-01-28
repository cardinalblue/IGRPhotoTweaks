//
//  IGRPhotoTweakView+UIScrollView.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/26/17.
//
//

import Foundation

extension IGRPhotoTweakView {
    
    internal func setupScrollView() {
        self.scrollView.updateDelegate = self
        
        self.photoContentView.image = image
        self.scrollView.photoContentView = self.photoContentView
    }
}

extension IGRPhotoTweakView : UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photoContentView
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.cropView.updateCropLines(animate: true)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.didPinchImage = true
        self.manualZoomed = true
        self.cropView.dismissCropLines()
        self.updatePosition()
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.highlightMask(true, animate: true)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.updateMasks()
        self.highlightMask(false, animate: true)
        if !decelerate {
            self.updatePosition()
        }
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint,
                                          targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let contentOffset = CGPoint(x: max(min(self.scrollView.contentSize.width, self.scrollView.contentOffset.x + velocity.x), 0),
                                    y: max(min(self.scrollView.contentSize.height, self.scrollView.contentOffset.y + velocity.y), 0))
        targetContentOffset.pointee = contentOffset
    }
}

extension IGRPhotoTweakView : IGRPhotoScrollViewDelegate {
    public func scrollViewDidStartUpdateScrollContentOffset(_ scrollView: IGRPhotoScrollView) {
        self.highlightMask(true, animate: true)
    }
    
    public func scrollViewDidStopScrollUpdateContentOffset(_ scrollView: IGRPhotoScrollView) {
        self.updateMasks()
        self.highlightMask(false, animate: true)
        self.updatePosition()
    }
}
