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

public class DeepPanel {

    static let modelInputImageSize = 224
    
    private static var interpreter: Interpreter?
    private static var nativeDeepPanel: DeepPaneliOSWrapper?
    private static let classCount = 3
    
    public static func initialize() {
        interpreter = initializeModel()
        nativeDeepPanel = DeepPaneliOSWrapper()
    }
    
    public init() {}
    
    public func extractPanelsInfo(from image: UIImage) -> PredictionResult {
        guard let interpreter = DeepPanel.interpreter else {
            fatalError("DeepPanel interpreter hasn't been initialized")
        }
        guard let nativeDeepPanel = DeepPanel.nativeDeepPanel else {
            fatalError("NativeDeepPanel hasn't been initialized")
        }
        let imageRawData = scaleAndExtractImageRgbData(image)
        let evaluationResult = evaluateModel(
            with: interpreter,
            andNativeDeepPanel: nativeDeepPanel,
            andInput: imageRawData,
            andOriginalImageWidth: Int(image.size.width),
            andOriginalImageHeight: Int(image.size.height)
        )
        return mapEvaluationResultToPredictionResult(evaluationResult)
    }
    
    public func extractDetailedPanelsInfo(from image: UIImage) -> DetailedPredictionResult {
        guard let interpreter = DeepPanel.interpreter else {
            fatalError("DeepPanel interpreter hasn't been initialized")
        }
        guard let nativeDeepPanel = DeepPanel.nativeDeepPanel else {
            fatalError("NativeDeepPanel hasn't been initialized")
        }
        let imageRawData = scaleAndExtractImageRgbData(image)
        let evaluationResult = evaluateModel(
            with: interpreter,
            andNativeDeepPanel: nativeDeepPanel,
            andInput: imageRawData,
            andOriginalImageWidth: Int(image.size.width),
            andOriginalImageHeight: Int(image.size.height)
        )
        let predictionResult = mapEvaluationResultToPredictionResult(evaluationResult)
        let labeledAreasImage = createImageFromLabeledData(predictionResult.rawPrediction)
        let panelsImage = createPanelsImageFromResult(image, predictionResult)
        return DetailedPredictionResult(
            inputImage: image,
            labeledAreasImage: labeledAreasImage,
            panelsImage: panelsImage,
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
                               andInput input: Data,
                               andOriginalImageWidth originalImageWidth: Int,
                               andOriginalImageHeight originalImageHeight: Int) -> RawPanelsInfo {
        do {
            try interpreter.copy(input, toInputAt: 0)
            try interpreter.invoke()
            let outputTensor = try interpreter.output(at: 0)
            let prediction = mapOutputTensorToPredicition(outputTensor)
            let scale: Float = computeResizeScale(originalImageWidth, originalImageHeight)
            return nativeDeepPanel.extractPanelsInfo(
                prediction,
                andScale: scale,
                andOriginalImageWidth: Int32(originalImageWidth),
                andOriginalImageHeigth: Int32(originalImageHeight))
        } catch let error {
            fatalError("Failed to evaluate the model with the image data: \(error.localizedDescription)")
        }
    }
    
    private func mapOutputTensorToPredicition(_ outputTensor: Tensor) -> UnsafeMutablePointer<Float> {
        let logits: [Float32] = outputTensor.data.toArray(type: Float32.self)
        return UnsafeMutablePointer(mutating: logits)
    }
    
    private func scaleAndExtractImageRgbData(_ image: UIImage) -> Data {
        guard let interpreter = DeepPanel.interpreter else {
            fatalError("DeepPanel hasn't been initialized")
        }
        do {
            let inputShape = try interpreter.input(at: 0).shape
            let inputImageWidth = inputShape.dimensions[1]
            let inputImageHeight = inputShape.dimensions[2]
            let resizedImage = image.scaledImage(with: CGSize(width: inputImageWidth, height: inputImageHeight))!
            return resizedImage.extractPixelsData()!
        } catch let error {
            fatalError("Failed to resize image with error: \(error.localizedDescription)")
        }
    }
    
    private func mapEvaluationResultToPredictionResult(_ evaluationResult: RawPanelsInfo) -> PredictionResult {
        return PredictionResult(
            rawPrediction: extratPredictionFromResult(evaluationResult),
            panels: extractPanelsFromResult(evaluationResult)
        )
    }
    
    private func extratPredictionFromResult(_ info: RawPanelsInfo) -> [[Int]] {
        let size = DeepPanel.modelInputImageSize
        let areas: UnsafeMutablePointer<UnsafeMutablePointer<Int32>?> = info.connectedAreas
        var result = [[Int]](repeating: [Int](repeating: 0, count: size), count: size)
        for i in 0..<size {
            let row = areas[i]!
            for j in 0..<size {
                let pixelLabel = row[j]
                // j and i indexes order is changed on purpose because the original matrix
                // is rotated when reading the values.
                result[j][i] = Int(pixelLabel)
            }
        }
        return result
    }
    
    private func extractPanelsFromResult(_ info: RawPanelsInfo) -> Panels {
        var index = 0
        let panels = info.panels as! [RawPanel]
        let mappedPanels: [Panel] = panels.map { rawPanel in
            let panel = Panel(panelNumberInPage: index,
                              left: Int(rawPanel.left),
                              top: Int(rawPanel.top),
                              right: Int(rawPanel.right),
                              bottom: Int(rawPanel.bottom)
            )
            index += 1
            return panel
        }
        return Panels(panelsInfo: mappedPanels)
    }


}
