//
//  IGRPhotoTweakView+IGRCropView.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/26/17.
//
//

import UIKit

extension IGRPhotoTweakView {
    
    internal func setupCropView() {
        
        self.cropView.delegate = self
    }
}

extension IGRPhotoTweakView : IGRCropViewDelegate {
    
    public func cropViewDidStartCrop(_ cropView: IGRCropView) {
        self.highlightMask(true, animate: true)
        self.manualMove = true
    }
    
    public func cropViewDidMove(_ cropView: IGRCropView) {
        self.didDragCropView = true
        self.updateMasks()
    }
    
    public func cropViewDidStopCrop(_ cropView: IGRCropView) {
        let scaleX: CGFloat = self.maximumCanvasSize.width / cropView.bounds.size.width
        let scaleY: CGFloat = self.maximumCanvasSize.height / cropView.bounds.size.height
        let scale: CGFloat = min(scaleX, scaleY)

        // calculate the new bounds of crop view
        let newCropBounds = CGRect(x: CGFloat.zero,
                                   y: CGFloat.zero,
                                   width: (scale * cropView.frame.size.width),
                                   height: (scale * cropView.frame.size.height))

        // calculate the zoom area of scroll view
        var scaleFrame: CGRect = cropView.frame
        if scaleFrame.size.width >= self.scrollView.contentSize.width {
            scaleFrame.size.width = self.scrollView.contentSize.width - 1
        }
        if scaleFrame.size.height >= self.scrollView.contentSize.height {
            scaleFrame.size.height = self.scrollView.contentSize.height - 1
        }

        UIView.animate(withDuration: kAnimationDuration, animations: {() -> Void in
            // animate crop view
            cropView.bounds = CGRect(x: CGFloat.zero,
                                     y: CGFloat.zero,
                                     width: (newCropBounds.size.width),
                                     height: (newCropBounds.size.height))
            cropView.center = CGPoint(x: self.frame.width.half, y: self.centerY)

            // update scrollView
            self.updatePosition()

            // zoom the specified area of scroll view
            let zoomRect: CGRect = self.convert(scaleFrame,
                                                to: self.scrollView.photoContentView)
            self.scrollView.zoom(to: zoomRect, animated: false)

            self.cropView.layoutIfNeeded()
        })

        // update masks
        self.cropView.dismissCropLines()
        self.cropView.dismissGridLines()
        self.highlightMask(false, animate: true)
    }
    
    public func cropViewInsideValidFrame(for point: CGPoint, from cropView: IGRCropView) -> Bool {
        let updatedPoint = self.convert(point, to: self.scrollView.photoContentView)
        let frame =  self.scrollView.photoContentView.frame
        return frame.contains(updatedPoint)
    }
}
