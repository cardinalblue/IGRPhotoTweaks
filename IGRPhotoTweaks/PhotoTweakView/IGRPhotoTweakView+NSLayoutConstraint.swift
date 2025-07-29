//
//  IGRPhotoTweakView+NSLayoutConstraint.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/25/17.
//
//

import UIKit
import Foundation

extension IGRPhotoTweakView {
    func setupMaskLayoutConstraints() {
        guard let topMask, let leftMask, let bottomMask, let rightMask else {
            return
        }

        //MARK: Top
        topMask.translatesAutoresizingMaskIntoConstraints = false

        var top = NSLayoutConstraint(item: topMask,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: self,
                                     attribute: .top,
                                     multiplier: 1.0,
                                     constant: 0.0)
        
        var leading = NSLayoutConstraint(item: topMask,
                                         attribute: .leading,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .leading,
                                         multiplier: 1.0,
                                         constant: 0.0)
        
        var trailing = NSLayoutConstraint(item: topMask,
                                          attribute: .trailing,
                                          relatedBy: .equal,
                                          toItem: self.cropView,
                                          attribute: .trailing,
                                          multiplier: 1.0,
                                          constant: 0.0)
        trailing.priority = .defaultHigh
        
        var bottom = NSLayoutConstraint(item: topMask,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: self.cropView,
                                        attribute: .top,
                                        multiplier: 1.0,
                                        constant: 0.0)
        bottom.priority = .defaultHigh
        
        self.addConstraints([top, leading, trailing, bottom])
        
        //MARK: Left
        leftMask.translatesAutoresizingMaskIntoConstraints = false
        
        top = NSLayoutConstraint(item: leftMask,
                                 attribute: .top,
                                 relatedBy: .equal,
                                 toItem: self.cropView,
                                 attribute: .top,
                                 multiplier: 1.0,
                                 constant: 0.0)
        top.priority = .defaultHigh
        
        leading = NSLayoutConstraint(item: leftMask,
                                     attribute: .leading,
                                     relatedBy: .equal,
                                     toItem: self,
                                     attribute: .leading,
                                     multiplier: 1.0,
                                     constant: 0.0)
        
        trailing = NSLayoutConstraint(item: leftMask,
                                      attribute: .trailing,
                                      relatedBy: .equal,
                                      toItem: self.cropView,
                                      attribute: .leading,
                                      multiplier: 1.0,
                                      constant: 0.0)
        trailing.priority = .defaultHigh
        
        bottom = NSLayoutConstraint(item: leftMask,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: self,
                                    attribute: .bottom,
                                    multiplier: 1.0,
                                    constant: 0.0)
        
        self.addConstraints([top, leading, trailing, bottom])
        
        //MARK: Right
        rightMask.translatesAutoresizingMaskIntoConstraints = false
        
        top = NSLayoutConstraint(item: rightMask,
                                 attribute: .top,
                                 relatedBy: .equal,
                                 toItem: self,
                                 attribute: .top,
                                 multiplier: 1.0,
                                 constant: 0.0)
        
        leading = NSLayoutConstraint(item: rightMask,
                                     attribute: .leading,
                                     relatedBy: .equal,
                                     toItem: self.cropView,
                                     attribute: .trailing,
                                     multiplier: 1.0,
                                     constant: 0.0)
        leading.priority = .defaultHigh
        
        trailing = NSLayoutConstraint(item: rightMask,
                                      attribute: .trailing,
                                      relatedBy: .equal,
                                      toItem: self,
                                      attribute: .trailing,
                                      multiplier: 1.0,
                                      constant: 0.0)
        
        bottom = NSLayoutConstraint(item: rightMask,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: self.cropView,
                                    attribute: .bottom,
                                    multiplier: 1.0,
                                    constant: 0.0)
        bottom.priority = .defaultHigh
        
        self.addConstraints([top, leading, trailing, bottom])
        
        //MARK: Bottom
        bottomMask.translatesAutoresizingMaskIntoConstraints = false
        
        top = NSLayoutConstraint(item: bottomMask,
                                 attribute: .top,
                                 relatedBy: .equal,
                                 toItem: self.cropView,
                                 attribute: .bottom,
                                 multiplier: 1.0,
                                 constant: 0.0)
        top.priority = .defaultHigh
        
        leading = NSLayoutConstraint(item: bottomMask,
                                     attribute: .leading,
                                     relatedBy: .equal,
                                     toItem: self.cropView,
                                     attribute: .leading,
                                     multiplier: 1.0,
                                     constant: 0.0)
        leading.priority = .defaultHigh
        
        trailing = NSLayoutConstraint(item: bottomMask,
                                      attribute: .trailing,
                                      relatedBy: .equal,
                                      toItem: self,
                                      attribute: .trailing,
                                      multiplier: 1.0,
                                      constant: 0.0)
        
        bottom = NSLayoutConstraint(item: bottomMask,
                                    attribute: .bottom,
                                    relatedBy: .equal,
                                    toItem: self,
                                    attribute: .bottom,
                                    multiplier: 1.0,
                                    constant: 0.0)
        
        self.addConstraints([top, leading, trailing, bottom])
    }
}
