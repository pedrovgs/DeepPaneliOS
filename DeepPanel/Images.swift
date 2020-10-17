//
//  Images.swift
//  DeepPanel
//
//  Created by Pedro Gómez on 11/10/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

func computeResizeScale(_ height: Int,_ width: Int) -> Float {
    let originalSize = Float(max(width, height))
    return originalSize / Float(DeepPanel.modelInputImageSize)
}

func createPanelsImageFromResult(_ image: UIImage,_ predictionResult: PredictionResult) -> UIImage {
    let imageSize = image.size
    let scale: CGFloat = 0
    UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
    let context = UIGraphicsGetCurrentContext()!

    image.draw(at: CGPoint.zero)
    
    for panel in predictionResult.panels.panelsInfo {
        let rectangle = CGRect(x: panel.left, y: panel.top, width: panel.width, height: panel.height)
        let pixelData = labelFromColor(panel.panelNumberInPage)
        let comps = [CGFloat(pixelData.r) / 255, CGFloat(pixelData.g) / 255, CGFloat(pixelData.b) / 255, 0.2]
        let color = CGColor(colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, components: comps)!
        context.setFillColor(color)
        context.addRect(rectangle)
        context.drawPath(using: .fill)
    }

    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
}

func createImageFromLabeledData(_ matrix: [[Int]]) -> UIImage {
    let width = matrix.count
    let height = matrix[0].count
    let pixelInfo: [PixelData] = matrix.reduce([Int](), +).map { label in
        labelFromColor(label)
    }
    return imageFromARGB32Bitmap(pixels: pixelInfo, width: width, height: height)!
}

private func labelFromColor(_ label: Int) -> PixelData {
    if (label < 0) {
        return black
    } else if (label == 0) {
        return blue
    } else if (label == 1) {
        return red
    } else if (label == 2) {
        return green
    } else if (label == 3) {
        return cyan
    } else if (label == 4) {
        return yellow
    } else if (label == 5) {
        return magenta
    } else if (label == 6) {
        return random1
    } else if (label == 7) {
        return random2
    } else if (label == 8) {
        return random3
    } else if (label == 9) {
        return random4
    } else {
        return random5
    }
}

private struct PixelData {
    var a: UInt8
    var r: UInt8
    var g: UInt8
    var b: UInt8
}

private let colorRange = 1...255
private let black = PixelData(a: 255, r: 0, g: 0, b: 0)
private let red = PixelData(a: 255, r: 255, g: 0, b: 0)
private let green = PixelData(a: 255, r: 0, g: 255, b: 0)
private let blue = PixelData(a: 255, r: 0, g: 0, b: 255)
private let cyan = PixelData(a: 255, r: 0, g: 255, b: 255)
private let yellow = PixelData(a: 255, r: 255, g: 255, b: 0)
private let magenta = PixelData(a: 255, r: 255, g: 0, b: 255)
private let random1 = PixelData(a: 255, r: UInt8(Int.random(in: colorRange)), g: UInt8(Int.random(in: colorRange)), b: UInt8(Int.random(in: colorRange)))
private let random2 = PixelData(a: 255, r: UInt8(Int.random(in: colorRange)), g: UInt8(Int.random(in: colorRange)), b: UInt8(Int.random(in: colorRange)))
private let random3 = PixelData(a: 255, r: UInt8(Int.random(in: colorRange)), g: UInt8(Int.random(in: colorRange)), b: UInt8(Int.random(in: colorRange)))
private let random4 = PixelData(a: 255, r: UInt8(Int.random(in: colorRange)), g: UInt8(Int.random(in: colorRange)), b: UInt8(Int.random(in: colorRange)))
private let random5 = PixelData(a: 255, r: UInt8(Int.random(in: colorRange)), g: UInt8(Int.random(in: colorRange)), b: UInt8(Int.random(in: colorRange)))


private func imageFromARGB32Bitmap(pixels: [PixelData], width: Int, height: Int) -> UIImage? {
    guard width > 0 && height > 0 else { return nil }
    guard pixels.count == width * height else { return nil }

    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
    let bitsPerComponent = 8
    let bitsPerPixel = 32

    var data = pixels
    guard let providerRef = CGDataProvider(data: NSData(bytes: &data,
                            length: data.count * MemoryLayout<PixelData>.size)
        )
        else { return nil }

    guard let cgim = CGImage(
        width: width,
        height: height,
        bitsPerComponent: bitsPerComponent,
        bitsPerPixel: bitsPerPixel,
        bytesPerRow: width * MemoryLayout<PixelData>.size,
        space: rgbColorSpace,
        bitmapInfo: bitmapInfo,
        provider: providerRef,
        decode: nil,
        shouldInterpolate: true,
        intent: .defaultIntent
        )
        else { return nil }

    return UIImage(cgImage: cgim)
}

