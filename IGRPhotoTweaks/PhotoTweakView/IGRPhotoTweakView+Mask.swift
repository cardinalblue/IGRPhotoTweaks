//
//  IGRPhotoTweakView+Mask.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/26/17.
//
//

import UIKit
import Foundation

extension IGRPhotoTweakView {
    
    internal func setupMasks()
    {
        self.topMask = IGRCropMaskView()
        self.addSubview(self.topMask)
        
        self.leftMask = IGRCropMaskView()
        self.addSubview(self.leftMask)
        
        self.rightMask = IGRCropMaskView()
        self.addSubview(self.rightMask)
        
        self.bottomMask = IGRCropMaskView()
        self.addSubview(self.bottomMask)
        
        self.setupMaskLayoutConstraints()
    }
    
    internal func updateMasks() {
        self.layoutIfNeeded()

        updatePhotoMask()
    }

    func updatePhotoMask() {
        guard let superview = cropView.superview else {
            return
        }
        let size = photoContentView.bounds.size
        let transform = CGAffineTransform(scaleX: 1 / size.width, y: 1 / size.height)
        var croppedRect = superview.convert(cropView.frame, to: photoContentView)
        croppedRect = croppedRect.applying(transform)
        photoContentView.croppedRect = croppedRect
    }
    
    internal func highlightMask(_ highlight:Bool, animate: Bool) {
        if (self.isHighlightMask()) {
            let newAlphaValue: CGFloat = highlight ? self.highlightMaskAlphaValue() : 1.0
            
            let animationBlock: (() -> Void)? = {
                self.topMask.alpha = newAlphaValue
                self.leftMask.alpha = newAlphaValue
                self.bottomMask.alpha = newAlphaValue
                self.rightMask.alpha = newAlphaValue
            }
            
            if animate {
                UIView.animate(withDuration: kAnimationDuration, animations: animationBlock!)
            }
            else {
                animationBlock!()
            }
        }
    }
}
