//
//  IGRPhotoTweakView+Analytics.swift
//  HorizontalDial
//
//  Created by RaymondWu on 2019/1/25.
//

import Foundation
import UIKit

extension IGRPhotoTweakView {
    public func isFliped() -> Bool {
        return flipTransform != .identity
    }

    public func isRotated() -> Bool {
        return rotation.remainder(dividingBy: IGRRadianAngle.toRadians(360)) != 0
    }

    public func isStraighten() -> Bool {
        return straighten != 0
    }

    public func isDragCropArea() -> Bool {
        return didDragCropView
    }

    public func isPinchImage() -> Bool {
        return didPinchImage
    }

    public func isCropImage() -> Bool {
        return self.photoContentView.bounds.size != self.cropView.frame.size
    }
}
