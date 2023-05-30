//
//  IGRPhotoContentView.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

public class IGRPhotoMaskView: UIView {

    // The @objc dynamic is for UIAppearance
    @objc dynamic
    public var maskColor: UIColor? = .mask()

    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = maskColor
    }
}

public class IGRPhotoContentView: UIView {

    fileprivate var photoMaskView = IGRPhotoMaskView()

    // The visible rectangle representing the normalized area for the content view.
    public var croppedRect: CGRect = CGRect(origin: .zero, size: CGSize(width: 1, height: 1)) {
        didSet {
            updateMaskView()
        }
    }
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: bounds)
        addSubview(imageView)
        imageView.addSubview(photoMaskView)
        return imageView
    }()
    
    public var image: UIImage? {
        didSet {
            imageView.frame = bounds
            imageView.image = image
            imageView.isUserInteractionEnabled = true
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()

        imageView.frame = bounds
        photoMaskView.frame = imageView.bounds
        updateMaskView()
    }

    private func updateMaskView() {
        let clearRect = croppedRect
            .applying(CGAffineTransform(scaleX: bounds.width, y: bounds.height))
        photoMaskView.makeClear(rect: clearRect)
    }
}

private extension UIView {

    func makeClear(rect: CGRect) {
        let maskLayer = CAShapeLayer()
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.fillColor = UIColor.black.cgColor

        let pathToOverlay = UIBezierPath(rect: bounds)
        pathToOverlay.append(UIBezierPath(rect: rect))
        pathToOverlay.usesEvenOddFillRule = true
        maskLayer.path = pathToOverlay.cgPath

        layer.mask = maskLayer
    }

}
