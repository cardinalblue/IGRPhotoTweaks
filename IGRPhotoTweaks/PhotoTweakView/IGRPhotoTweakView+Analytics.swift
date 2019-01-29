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
        return atan2(self.scrollView.transform.b, self.scrollView.transform.a) != 0
    }

    public func isStraighten() -> Bool {
        return self.radians != 0
    }

    public func isDragCropArea() -> Bool {
        return self.photoContentView.bounds.size != self.cropView.frame.size
    }

    public func isPinchImage() -> Bool {
        return self.scrollView.zoomScale != 1
    }
}
