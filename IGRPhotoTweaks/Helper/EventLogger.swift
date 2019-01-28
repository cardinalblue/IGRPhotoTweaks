//
//  EventLogger.swift
//  IGRPhotoTweaks
//
//  Created by RaymondWu on 2019/1/25.
//  Copyright © 2019 IGR Software. All rights reserved.
//


/// Extend me to implement your own event logger
public protocol EventLogger {
    func cropDoneLogEvent(isFliped: Bool, isRotated: Bool, isStraighten: Bool, isDragCropArea: Bool, isPinchImage: Bool)
}
