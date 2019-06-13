//
//  IGRPhotoTweakView+Analytics.swift
//  HorizontalDial
//
//  Created by RaymondWu on 2019/1/25.
//

import Foundation
import UIKit

extension IGRPhotoTweakView {

    public var didChange: Bool {
        return isFliped
                || isCropped
                || isRotated
                || isStraightened
                || didDragCropArea
                || didPinchImage
    }

    public var isCropped: Bool {
        return self.photoContentView.bounds.size != self.cropView.frame.size
    }

    public var isFliped: Bool {
        return flipTransform != .identity
    }

    public var isRotated: Bool {
        return rotation.remainder(dividingBy: IGRRadianAngle.toRadians(360)) != 0
    }

    public var isStraightened: Bool {
        return straighten.remainder(dividingBy: IGRRadianAngle.toRadians(360)) != 0
    }

    public var didDragCropArea: Bool {
        return didDragCropView
    }
}
