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
        let expectedScaldeImage = imageNamed("sample_page_0_scaled.jpg")!
        let targetSize = CGSize(width: 224, height: 224)
        
        let scaledImage = image.scaledImage(with: targetSize)!
        
        XCTAssertEqual(scaledImage.size, targetSize)
        XCTAssertEqual(expectedScaldeImage.size, targetSize)
        XCTAssertEqual(scaledImage.pngData()!, expectedScaldeImage.pngData()!)
    }
    
    func testHorizontalImageCanBeScaledCorrectly() throws {
        let image = imageNamed("sample_page_0_rotated.jpg")!
        let expectedScaldeImage = imageNamed("sample_page_0_rotated_scaled.jpg")!
        let targetSize = CGSize(width: 224, height: 224)
        
        let scaledImage = image.scaledImage(with: targetSize)!
        
        XCTAssertEqual(scaledImage.size, targetSize)
        XCTAssertEqual(expectedScaldeImage.size, targetSize)
        XCTAssertEqual(scaledImage.pngData()!, expectedScaldeImage.pngData()!)
    }
}
