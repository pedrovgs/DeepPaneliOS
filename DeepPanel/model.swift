//
//  model.swift
//  DeepPanel
//
//  Created by Pedro Gómez on 11/10/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//

import Foundation
import UIKit

typealias Prediction = [[Int]]

struct Panels {
    let panelsInfo: [Panel]
}

struct PredictionResult {
    let rawPrediction: Prediction
    let panels: Panels
}

struct DetailedPredictionResult {
    let inputImage: UIImage
    let labeledAreasImage: UIImage
    let panelsImage: UIImage
    let predictionResult: PredictionResult
}

struct Panel {
    let panelNumberInPage: Int
    let left: Int
    let top: Int
    let right: Int
    let bottom: Int
    
    var width: Int {
        return right - left
    }
    
    var height: Int {
        return bottom - top
    }
}
