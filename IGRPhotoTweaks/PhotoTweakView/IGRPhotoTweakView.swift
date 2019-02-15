//
//  IGRPhotoTweakView.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

public class IGRPhotoTweakView: UIView {
    
    //MARK: - Public VARs
    public weak var customizationDelegate: IGRPhotoTweakViewCustomizationDelegate?
    
    private(set) lazy var cropView: IGRCropView! = { [unowned self] by in
        
        let cropView = IGRCropView(frame: self.scrollView.frame,
                                   cornerBorderWidth:self.cornerBorderWidth(),
                                   cornerBorderLength:self.cornerBorderLength(),
                                   cropLinesCount:self.cropLinesCount(),
                                   gridLinesCount:self.gridLinesCount())
        cropView.center = self.scrollView.center
        
        cropView.layer.borderColor = self.borderColor().cgColor
        cropView.layer.borderWidth = self.borderWidth()
        self.addSubview(cropView)
        
        return cropView
        }(())
    
    public private(set) lazy var photoContentView: IGRPhotoContentView! = { [unowned self] by in
        
        let photoContentView = IGRPhotoContentView(frame: self.scrollView.bounds)
        photoContentView.isUserInteractionEnabled = true
        self.scrollView.addSubview(photoContentView)
        
        return photoContentView
        }(())
    
    public var photoTranslation: CGPoint {
        get {
            let rect: CGRect = self.photoContentView.convert(self.photoContentView.bounds,
                                                             to: self)
            let point = CGPoint(x: (rect.origin.x + rect.size.width.half),
                                y: (rect.origin.y + rect.size.height.half))
            let zeroPoint = CGPoint(x: self.frame.width.half, y: self.centerY)
            
            return CGPoint(x: (point.x - zeroPoint.x), y: (point.y - zeroPoint.y))
        }
    }
    
    public var maximumZoomScale: CGFloat {
        set {
            self.scrollView.maximumZoomScale = newValue
        }
        get {
            return self.scrollView.maximumZoomScale
        }
    }
    
    public var minimumZoomScale: CGFloat {
        set {
            self.scrollView.minimumZoomScale = newValue
        }
        get {
            return self.scrollView.minimumZoomScale
        }
    }

    public var rotation: CGFloat = CGFloat.zero
    public var straighten: CGFloat = CGFloat.zero
    public var radians: CGFloat {
        return rotation + straighten
    }

    //MARK: - Private VARs
    fileprivate var photoContentOffset = CGPoint.zero
    
    internal lazy var scrollView: IGRPhotoScrollView! = { [unowned self] by in
        let maxBounds = self.maxBounds()
        
        let scrollView = IGRPhotoScrollView(frame: maxBounds)
        scrollView.center = CGPoint(x: self.frame.width.half, y: self.centerY)
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never;
        }
        scrollView.delegate = self
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(scrollView)
        
        return scrollView
    }(())
    
    internal weak var image: UIImage!

    internal var manualMove   = false

    // Analytics
    internal var didPinchImage = false
    internal var didDragCropView = false

    // masks
    internal var topMask:    IGRCropMaskView!
    internal var leftMask:   IGRCropMaskView!
    internal var bottomMask: IGRCropMaskView!
    internal var rightMask:  IGRCropMaskView!

    // flip transform
    internal var flipTransform =  CGAffineTransform.identity

    // constants
    internal var maximumCanvasSize: CGSize!
    var centerY: CGFloat {
        return self.canvasHeaderHeigth() + (self.frame.size.height - self.canvasHeaderHeigth()) / 2
    }
    fileprivate var originalPoint: CGPoint!

    // MARK: - Life Cicle
    public init(frame: CGRect, image: UIImage, customizationDelegate: IGRPhotoTweakViewCustomizationDelegate!) {
        super.init(frame: frame)
        
        self.image = image
        
        self.customizationDelegate = customizationDelegate
        
        setupScrollView()
        setupCropView()
        setupMasks()
        
        self.originalPoint = self.convert(self.scrollView.center, to: self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if !manualMove {
            self.scrollView.center = CGPoint(x: (self.frame.width * 0.5), y: centerY)
            
            self.cropView.center = self.scrollView.center
            self.scrollView.checkContentOffset()
        }
    }
    
    //MARK: - Public FUNCs
    public func resetView() {
        UIView.animate(withDuration: kAnimationDuration, animations: {() -> Void in
            self.straighten = CGFloat.zero
            self.rotation = CGFloat.zero
            self.scrollView.transform = CGAffineTransform.identity
            self.scrollView.center = CGPoint(x: self.frame.width.half, y: self.centerY)
            self.scrollView.bounds = CGRect(x: CGFloat.zero,
                                            y: CGFloat.zero,
                                            width: self.maximumCanvasSize.width,
                                            height: self.maximumCanvasSize.height)
            self.scrollView.minimumZoomScale = 1.0
            self.scrollView.setZoomScale(1.0, animated: false)
            
            self.cropView.frame = self.scrollView.frame
            self.cropView.center = self.scrollView.center
        })
    }
    
    public func applyDeviceRotation() {
        self.resetView()
        
        self.scrollView.center = CGPoint(x: self.frame.width.half, y: centerY)
        self.scrollView.bounds = self.maxBounds()
        
        self.cropView.frame = self.scrollView.bounds
        self.cropView.center = self.scrollView.center
        
        // Update 'photoContent' frame and set the image.
        self.scrollView.photoContentView.frame = self.cropView.bounds
        self.scrollView.photoContentView.image = self.image
        
        updatePosition()
    }
    
    //MARK: - Private FUNCs
    fileprivate func maxBounds() -> CGRect {
        // scale the image
        self.maximumCanvasSize = CGSize(width: (kMaximumCanvasWidthRatio * self.frame.size.width),
                                        height: (kMaximumCanvasHeightRatio * self.frame.size.height - self.canvasHeaderHeigth()))
        
        let scaleX: CGFloat = self.image.size.width / self.maximumCanvasSize.width
        let scaleY: CGFloat = self.image.size.height / self.maximumCanvasSize.height
        let scale: CGFloat = max(scaleX, scaleY)
        
        let bounds = CGRect(x: CGFloat.zero,
                            y: CGFloat.zero,
                            width: (self.image.size.width / scale),
                            height: (self.image.size.height / scale))
        
        return bounds
    }

    internal func updatePosition() {
        // position scroll view
        let width: CGFloat = abs(cos(self.radians)) * self.cropView.frame.size.width + abs(sin(self.radians)) * self.cropView.frame.size.height
        let height: CGFloat = abs(sin(self.radians)) * self.cropView.frame.size.width + abs(cos(self.radians)) * self.cropView.frame.size.height
        let center: CGPoint = self.scrollView.center
        let contentOffset: CGPoint = self.scrollView.contentOffset
        let contentOffsetCenter = CGPoint(x: (contentOffset.x + self.scrollView.bounds.size.width.half),
                                          y: (contentOffset.y + self.scrollView.bounds.size.height.half))
        self.scrollView.bounds = CGRect(x: CGFloat.zero, y: CGFloat.zero, width: width, height: height)
        let newContentOffset = CGPoint(x: (contentOffsetCenter.x - self.scrollView.bounds.size.width.half),
                                       y: (contentOffsetCenter.y - self.scrollView.bounds.size.height.half))
        self.scrollView.contentOffset = newContentOffset
        self.scrollView.center = center

        // scale scroll view
        let minimumZoomScale = self.scrollView.zoomScaleToBound()
        let shouldUpdateZoomScale = self.scrollView.zoomScale == self.scrollView.minimumZoomScale
                                     || self.scrollView.zoomScale < minimumZoomScale
        if self.scrollView.minimumZoomScale != minimumZoomScale {
            self.scrollView.minimumZoomScale = minimumZoomScale
        }
        if shouldUpdateZoomScale {
            self.scrollView.setZoomScale(minimumZoomScale, animated: false)
        }

        self.scrollView.checkContentOffset()
    }
}

public struct CropParameter {
    public let transform: CGAffineTransform
    public let zoomScale: CGFloat
    public let flipTransform: CGAffineTransform
    public let sourceSize: CGSize
    public let imageViewFrame: CGRect

    public let cropFrame: CGRect
    public let scrollZoomScale: CGFloat
    public let scrollViewTransform: CGAffineTransform
    public let scrollViewBounds: CGRect
    public let scrollViewContentOffset: CGPoint

    public let rotation: CGFloat
    public let straighten: CGFloat
}

extension IGRPhotoTweakView {
    public var cropParameter: CropParameter {
        return CropParameter(transform: imageTransform,
                             zoomScale: scrollView.zoomScale,
                             flipTransform: flipTransform,
                             sourceSize: image.size,
                             imageViewFrame: photoContentView.bounds,
                             cropFrame: cropView.frame,
                             scrollZoomScale: scrollView.zoomScale,
                             scrollViewTransform: scrollView.transform,
                             scrollViewBounds: scrollView.bounds,
                             scrollViewContentOffset: scrollView.contentOffset,
                             rotation: rotation,
                             straighten: straighten)
    }

    public func update(parameter: CropParameter) {
        cropView.frame = parameter.cropFrame
        rotation = parameter.rotation
        straighten = parameter.straighten

        updatePosition()

        scrollView.zoomScale = parameter.scrollZoomScale
        scrollView.bounds = parameter.scrollViewBounds
        scrollView.contentOffset = parameter.scrollViewContentOffset
        scrollView.transform = parameter.scrollViewTransform

        flipTransform = parameter.flipTransform
    }

    var imageTransform: CGAffineTransform {
        var transform = CGAffineTransform.identity
        // translate
        let translation: CGPoint = photoTranslation
        transform = transform.translatedBy(x: translation.x, y: translation.y)
        // rotate
        transform = transform.rotated(by: radians)
        // scale
        let t: CGAffineTransform = photoContentView.transform
        let xScale: CGFloat = sqrt(t.a * t.a + t.c * t.c)
        let yScale: CGFloat = sqrt(t.b * t.b + t.d * t.d)
        transform = transform.scaledBy(x: xScale, y: yScale)

        return transform
    }
}
