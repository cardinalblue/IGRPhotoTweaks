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
        let scaleX = maximumCanvasSize.width / cropView.bounds.size.width
        let scaleY = maximumCanvasSize.height / cropView.bounds.size.height
        let scale = min(scaleX, scaleY)
        let radians = self.radians

        let zoomRect = cropView.superview!.convert(cropView.frame, to: scrollView.photoContentView)

        // calculate the new bounds of crop view
        let newCropBounds = CGRect(
            x: 0, y: 0, width: (scale * cropView.frame.size.width), height: (scale * cropView.frame.size.height)
        )

        UIView.animate(withDuration: kAnimationDuration, animations: {() -> Void in
            // animate crop view
            cropView.bounds = CGRect(x: CGFloat.zero,
                                     y: CGFloat.zero,
                                     width: (newCropBounds.size.width),
                                     height: (newCropBounds.size.height))
            cropView.center = CGPoint(x: self.frame.width.half, y: self.centerY)
            cropView.layoutIfNeeded()

            // update scrollView
            self.scrollView.bounds = { () -> CGRect in
                let size = cropView.frame.size
                let width = abs(cos(radians)) * size.width + abs(sin(radians)) * size.height
                let height = abs(sin(radians)) * size.width + abs(cos(radians)) * size.height
                return CGRect(x: 0, y: 0, width: width, height: height)
            }()

            // zoom the specified area of scroll view
            self.scrollView.zoom(to: zoomRect, animated: false)
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
