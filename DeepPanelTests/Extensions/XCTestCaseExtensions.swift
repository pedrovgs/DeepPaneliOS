//
//  XCTestCaseExtensions.swift
//  DeepPanelTests
//
//  Created by Daniel Garcia on 03/12/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//

import XCTest

extension XCTestCase {
    func imageNamed(_ filename: String) -> UIImage? {
        let bundle = Bundle(for: DeepPanelTests.self)
        return UIImage(named: filename, in: bundle, with: nil)
    }
}
