//
//  UIImage+TensorFlow.swift
//  DeepPanel
//
// The original implementation can be found here: https://github.com/tensorflow/examples/blob/master/lite/examples/image_segmentation/ios/ImageSegmentation/TFLiteExtension.swift
//
//  Created by Pedro Gómez on 10/10/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//


import CoreGraphics
import Foundation
import UIKit

extension UIImage {
  func scaledImage(with scalingSize: CGSize) -> UIImage? {
    let isHorizontal = size.width > size.height
    let newSize: CGSize = {
        let maxSize = isHorizontal ? scalingSize.width : scalingSize.height
        if isHorizontal {
            let resizeFactor = maxSize / size.width
            return CGSize(width: maxSize, height: ceil(size.height * resizeFactor))
        } else {
            let resizeFactor = maxSize / size.height
            return CGSize(width: ceil(size.width * resizeFactor), height: maxSize)
        }
    }()
    guard size != newSize else { return self }

    UIGraphicsBeginImageContextWithOptions(scalingSize, true, scale)
    let newImageRect: CGRect = {
        if isHorizontal {
            return CGRect(x: 0, y: (scalingSize.height - newSize.height) / 2, width: newSize.width, height: newSize.height)
        } else {
            return CGRect(x: (scalingSize.width - newSize.width) / 2, y: 0, width: newSize.width, height: newSize.height)
        }
    }()
    draw(in: newImageRect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }

  func extractPixelsData() -> Data? {
    let size = self.size
    let dataSize = size.width * size.height * 4
    var pixelDataWithAlpha = [UInt8](repeating: 0, count: Int(dataSize))
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let context = CGContext(data: &pixelDataWithAlpha,
                            width: Int(size.width),
                            height: Int(size.height),
                            bitsPerComponent: 8,
                            bytesPerRow: 4 * Int(size.width),
                            space: colorSpace,
                            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
    guard let cgImage = self.cgImage else { return nil }
    context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let byteCount = size.width * size.height * 3
    var scaledBytes = [UInt8](repeating: 0, count: Int(byteCount))
    var writeIndex = 0
    for readIndex in 0..<pixelDataWithAlpha.count {
        if (readIndex % 4 != 3) { //Not aplha channel info
            let pixelValue = pixelDataWithAlpha[readIndex]
            scaledBytes[writeIndex] = pixelValue
            writeIndex+=1
        }
    }
    let scaledFloats = scaledBytes.map { Float32($0) / Float32(255) }
    return Data(copyingBufferOf: scaledFloats)
  }
}

extension Data {
    init<T>(copyingBufferOf array: [T]) {
        self = array.withUnsafeBufferPointer(Data.init)
    }
     func toArray<T>(type: T.Type) -> [T] where T: ExpressibleByIntegerLiteral {
       var array = [T](repeating: 0, count: self.count/MemoryLayout<T>.stride)
       _ = array.withUnsafeMutableBytes { copyBytes(to: $0) }
       return array
     }
}
