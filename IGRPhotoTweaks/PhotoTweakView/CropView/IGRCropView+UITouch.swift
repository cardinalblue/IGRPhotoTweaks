//
//  IGRCropView+UITouch.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/26/17.
//
//

import Foundation

extension IGRCropView {
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            self.updateCropLines(animate: false)

            // Setup current control state and target frame
            let location: CGPoint = (touches.first?.location(in: self))!
            self.currentControlState = ControlState.locate(with: location, on: self.frame)
            self.currentTargetFrame = self.frame
        }

        self.delegate?.cropViewDidStartCrop(self)
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currentControlState = currentControlState else { return }

        if touches.count == 1 {
            let location: CGPoint = (touches.first?.location(in: self))!

            var frame = self.frame
            let aspectRatio = aspectRatioHeight / aspectRatioWidth
            let maximumX: CGFloat = currentTargetFrame.size.width * 0.8
            let maximumY: CGFloat = currentTargetFrame.size.height * 0.8
            let minimumFrameSize: CGSize = CGSize(width: currentTargetFrame.size.width * 0.2,
                                                  height: currentTargetFrame.size.height * 0.2)

            switch currentControlState {
            case .topLeft:
                frame.origin.x = min(frame.origin.x + location.x, currentTargetFrame.origin.x + maximumX)
                frame.size.width = max(frame.size.width - location.x, minimumFrameSize.width)
                frame.origin.y = min(frame.origin.y + location.y, currentTargetFrame.origin.y + maximumY)
                frame.size.height = max(frame.size.height - location.y, minimumFrameSize.height)
            case .topRight:
                frame.size.width = max(location.x, minimumFrameSize.width)
                frame.origin.y = min(frame.origin.y + location.y, currentTargetFrame.origin.y + maximumY)
                frame.size.height = max(frame.size.height - location.y, minimumFrameSize.height)
            case .bottomLeft:
                frame.origin.x = min(frame.origin.x + location.x, currentTargetFrame.origin.x + maximumX)
                frame.size.width = max(frame.size.width - location.x, minimumFrameSize.width)
                frame.size.height = max(location.y, minimumFrameSize.height)
            case .bottomRight:
                frame.size.width = max(location.x, minimumFrameSize.width)
                frame.size.height = max(location.y, minimumFrameSize.height)
            case .top:
                frame.origin.y = min(frame.origin.y + location.y, currentTargetFrame.origin.y + maximumY)
                frame.size.height = max(frame.size.height - location.y, minimumFrameSize.height)
            case .bottom:
                frame.size.height = max(location.y, minimumFrameSize.height)
            case .left:
                frame.origin.x = min(frame.origin.x + location.x, currentTargetFrame.origin.x + maximumX)
                frame.size.width = max(frame.size.width - location.x, minimumFrameSize.width)
            case .right:
                frame.size.width = max(location.x, minimumFrameSize.width)
            }

            // If Aspect ratio is Freezed reset frame as per the aspect ratio
            if self.isAspectRatioLocked {

                let size: CGSize = {
                    switch currentControlState {
                    case .top, .bottom:
                        let newWidth = frame.size.height / aspectRatio
                        return CGSize(width: newWidth, height: frame.size.height)
                    default:
                        let newHeight = aspectRatio * frame.size.width
                        return CGSize(width: frame.size.width, height: newHeight)
                    }
                }()

                let offsetY: CGFloat = {
                    switch currentControlState {
                    case .topLeft, .topRight, .top, .left, .right:
                        return frame.size.height - size.height
                    default:
                        return 0
                    }
                }()
                let origin = CGPoint(x: frame.origin.x, y: frame.origin.y + offsetY)

                frame = CGRect(origin: origin, size: size)
            }

            //TODO: Added test cropViewInsideValidFrame

            if (frame.size.width > self.cornerBorderLength
                && frame.size.height > self.cornerBorderLength) {
                self.frame = frame
                // update crop lines
                self.updateCropLines(animate: false)

                self.delegate?.cropViewDidMove(self)
            }
        }
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentControlState = nil
        self.delegate?.cropViewDidStopCrop(self)
    }

    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentControlState = nil
        self.delegate?.cropViewDidStopCrop(self	)
    }
}
