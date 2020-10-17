//
//  model.swift
//  DeepPanel
//
//  Created by Pedro Gómez on 11/10/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//

import Foundation
import UIKit

public typealias Prediction = [[Int]]

public struct Panels {
    public let panelsInfo: [Panel]
}

public struct PredictionResult {
    public let rawPrediction: Prediction
    public let panels: Panels
}

public struct DetailedPredictionResult {
    public let inputImage: UIImage
    public let labeledAreasImage: UIImage
    public let panelsImage: UIImage
    public let predictionResult: PredictionResult
}

public struct Panel {
    public let panelNumberInPage: Int
    public let left: Int
    public let top: Int
    public let right: Int
    public let bottom: Int
    
    public var width: Int {
        return right - left
    }
    
    public var height: Int {
        return bottom - top
    }
}
