//
//  ImageManipulationTests.swift
//  DeepPanelTests
//
//  Created by Daniel Garcia on 03/12/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//

import XCTest
@testable import DeepPanel

class ImageManipulationTests: XCTestCase {

    func testVerticalImageCanBeScaledCorrectly() throws {
        let image = imageNamed("sample_page_0.jpg")!
        let expectedScaledImage = imageNamed("sample_page_0_scaled.jpg")!
        let targetSize = CGSize(width: 224, height: 224)
        
        let scaledImage = image.scaledImage(with: targetSize)!
        
        XCTAssertEqual(scaledImage.size, targetSize)
        XCTAssertEqual(expectedScaledImage.size, targetSize)
        XCTAssertEqual(scaledImage.pngData()!, expectedScaledImage.pngData()!)
    }
    
    func testHorizontalImageCanBeScaledCorrectly() throws {
        let image = imageNamed("sample_page_0_rotated.jpg")!
        let expectedScaledImage = imageNamed("sample_page_0_rotated_scaled.jpg")!
        let targetSize = CGSize(width: 224, height: 224)
        
        let scaledImage = image.scaledImage(with: targetSize)!
        
        XCTAssertEqual(scaledImage.size, targetSize)
        XCTAssertEqual(expectedScaledImage.size, targetSize)
        XCTAssertEqual(scaledImage.pngData()!, expectedScaledImage.pngData()!)
    }
}
