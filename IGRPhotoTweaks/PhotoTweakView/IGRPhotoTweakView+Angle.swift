//
//  IGRPhotoTweakView+Angle.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/26/17.
//
//

import Foundation

extension IGRPhotoTweakView {
    public func changeAngle(radians: CGFloat) {
        straighten = radians

        // update masks
        highlightMask(true, animate: false)

        // update grids
        cropView.updateGridLines(animate: false)

        updateScrollView()
    }

    public func stopChangeAngle() {
        cropView.dismissGridLines()
        highlightMask(false, animate: false)
    }

    public func rotateClockwise() {
        rotation += IGRRadianAngle.toRadians(90)
        updateScrollView()
    }

    public func rotateConterclockwise() {
        rotation -= IGRRadianAngle.toRadians(90)
        updateScrollView()
    }

    public func flipVertical() {
        flipTransform = flipTransform.scaledBy(x: 1, y: -1)
        scrollView.transform = scrollView.transform.scaledBy(x: 1, y: -1)
    }

    public func flipHorizontal() {
        flipTransform = flipTransform.scaledBy(x: -1, y: 1)
        scrollView.transform = scrollView.transform.scaledBy(x: -1, y: 1)
    }

    func updateScrollView() {
        // rotate scroll view
        scrollView.transform = CGAffineTransform(rotationAngle: radians)
        updatePosition()
    }
}
