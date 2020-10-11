//
//  DeepPanel.swift
//  DeepPanel
//
//  Created by Pedro Gómez on 09/10/2020.
//  Copyright © 2020 Pedro Gómez. All rights reserved.
//
import Foundation
import TensorFlowLite
import UIKit

class DeepPanel {
    
    private static var interpreter: Interpreter?
    private static var nativeDeepPanel: DeepPaneliOSWrapper?

    private static let modelInputImageSize = 224
    private static let classCount = 3
    
    static func initialize() {
        interpreter = initializeModel()
        nativeDeepPanel = DeepPaneliOSWrapper()
    }
    
    func extractPanelsInfo(from image: UIImage) {
        guard let interpreter = DeepPanel.interpreter else {
            fatalError("DeepPanel interpreter hasn't been initialized")
        }
        guard let nativeDeepPanel = DeepPanel.nativeDeepPanel else {
            fatalError("NativeDeepPanel hasn't been initialized")
        }
        let imageRawData = scaleAndExtractImageRgbData(image)
        evaluateModel(with: interpreter, andNativeDeepPanel: nativeDeepPanel, andInput: imageRawData)
    }
    
    func extractDetailedPanelsInfo(from image: UIImage) -> DetailedPredictionResult {
        guard let interpreter = DeepPanel.interpreter else {
            fatalError("DeepPanel interpreter hasn't been initialized")
        }
        guard let nativeDeepPanel = DeepPanel.nativeDeepPanel else {
            fatalError("NativeDeepPanel hasn't been initialized")
        }
        let imageRawData = scaleAndExtractImageRgbData(image)
        let evaluationResult = evaluateModel(with: interpreter, andNativeDeepPanel: nativeDeepPanel, andInput: imageRawData)
        let predictionResult = PredictionResult(
            rawPrediction: extratPredictionFromResult(evaluationResult),
            panels: extractPanelsFromResult(evaluationResult)
        )
        return DetailedPredictionResult(
            imageInput: image,
            labeledAreasBitmap: image,
            panelsBitmap: image,
            predictionResult: predictionResult)
    }

    private static func initializeModel() -> Interpreter? {
        guard let modelPath = Bundle.main.path(
          forResource: "model",
          ofType: "tflite"
        ) else {
          fatalError("Failed to load the model file.")
        }
        var options: Interpreter.Options?
        var delegates: [Delegate]?
        #if targetEnvironment(simulator)
              // Use CPU for inference as MetalDelegate does not support iOS simulator.
              options = Interpreter.Options()
              options?.threadCount = 2
        #else
              // Use GPU on real device for inference as this model is fully supported.
              delegates = [MetalDelegate()]
        #endif
        do {
          let interpreter = try Interpreter(modelPath: modelPath, options: options, delegates: delegates)
          try interpreter.allocateTensors()
          return interpreter
        } catch let error {
          fatalError("Failed to create the interpreter with error: \(error.localizedDescription)")
        }
    }
    
    private func evaluateModel(with interpreter: Interpreter,
                               andNativeDeepPanel nativeDeepPanel: DeepPaneliOSWrapper,
                               andInput input: Data) -> RawPanelsInfo {
        do {
            try interpreter.copy(input, toInputAt: 0)
            try interpreter.invoke()
            let outputTensor = try interpreter.output(at: 0)
            let prediction = mapOutputTensorToPredicition(outputTensor)
            let scale: Float = 2.0
            return nativeDeepPanel.extractPanelsInfo(
                prediction,
                andScale: scale,
                andOriginalImageWidth: 200,
                andOriginalImageHeigth: 200)
        } catch let error {
            fatalError("Failed to evaluate the model with tihe image data: \(error.localizedDescription)")
        }
    }
    
    private func mapOutputTensorToPredicition(_ outputTensor: Tensor) -> UnsafeMutablePointer<Float> {
        let capacity = DeepPanel.modelInputImageSize * DeepPanel.modelInputImageSize * DeepPanel.classCount
        let result = UnsafeMutablePointer<Float>.allocate(capacity: capacity)
        let flattenPrediction = outputTensor.data.toArray(type: Float32.self)
        for x in 0..<DeepPanel.modelInputImageSize {
          for y in 0..<DeepPanel.modelInputImageSize {
            for z in 0..<DeepPanel.classCount {
                let plainIndex = coordinateToIndex(x: x, y: y, z: z)
                let prediction = flattenPrediction[plainIndex]
                result.advanced(by: x+y+z).pointee = prediction
                }
            }
        }
        return result
    }

    private func coordinateToIndex(x: Int, y: Int, z: Int) -> Int {
        return x * DeepPanel.modelInputImageSize * DeepPanel.classCount + y * DeepPanel.classCount + z

    }
    
    private func scaleAndExtractImageRgbData(_ image: UIImage) -> Data {
        guard let interpreter = DeepPanel.interpreter else {
            fatalError("DeepPanel hasn't been initialized")
        }
        do {
            let inputShape = try interpreter.input(at: 0).shape
            let batchSize = inputShape.dimensions[0]
            let inputImageWidth = inputShape.dimensions[1]
            let inputImageHeight = inputShape.dimensions[2]
            let inputPixelSize = inputShape.dimensions[3]
            return image.scaledData(
              with: CGSize(width: inputImageWidth, height: inputImageHeight),
              byteCount: inputImageWidth * inputImageHeight * inputPixelSize * batchSize,
              isQuantized: false
            )!
        } catch let error {
            fatalError("Failed to resize image with error: \(error.localizedDescription)")
        }
    }
    
    private func extratPredictionFromResult(_ info: RawPanelsInfo) -> [[Int]] {
        
        return [[Int]]()
    }
    
    private func extractPanelsFromResult(_ info: RawPanelsInfo) -> Panels {
        var index = 0
        let panels = info.panels as! [Panel]
        let mappedPanels: [Panel] = panels.map { panel in
            index += 1
            return Panel(panelNumberInPage: index, left: panel.left, top: panel.top, right: panel.right, bottom: panel.bottom)
        }
        return Panels(panelsInfo: mappedPanels)
    }


}
