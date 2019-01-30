//
//  IGRPhotoTweakView+AspectRatio.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/26/17.
//
//

import Foundation

extension IGRPhotoTweakView {
    public func resetAspectRect() {
        self.cropView.frame = CGRect(x: CGFloat.zero,
                                     y: CGFloat.zero,
                                     width: self.maximumCanvasSize.width,
                                     height: self.maximumCanvasSize.height)
        self.cropView.center = self.scrollView.center
        self.cropView.resetAspectRect()
        
        self.cropViewDidStopCrop(self.cropView)
    }
    
    public func setCropAspectRect(aspect: String) {
        self.cropView.setCropAspectRect(aspect: aspect, maxSize:self.maximumCanvasSize)
        self.cropView.center = self.scrollView.center
        
        self.cropViewDidStopCrop(self.cropView)
    }
    
    public func lockAspectRatio(_ lock: Bool) {
        self.cropView.lockAspectRatio(lock)
    }
}
