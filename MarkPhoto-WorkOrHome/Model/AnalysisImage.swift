//
//  AnalysisImage.swift
//  MarkPhoto#WorkOrHome
//
//  Created by Евгений Захаров on 13.01.2023.
//

import Foundation
import UIKit
import Vision

protocol ImagePredictionProtocol {
    associatedtype ImagePredictionHandler
    static func createImageClassifier() -> VNCoreMLModel
    func createImageClassificationRequest() -> VNImageBasedRequest
    func makePredictions(for photo: UIImage, completionHandler: ImagePredictionHandler) throws
    func visionRequestHandler(_ request: VNRequest, error: Error?)
}


final class AnalysisImage <U: ImagePredictionProtocol> {
    private let image: UIImage
    private var imagePredictor: U
//    private let imagePredictor2 = ImagePredictorResnet()
    
    private let predictionsToShow = 1
    var result = "error ..."
    
    init(imagePredictor: U, image: UIImage) {
        self.imagePredictor = imagePredictor
        self.image = image
        
    }
    
    func predict() -> String {
        do {
            try imagePredictor.makePredictions(for: image,
                                               completionHandler: imagePredictionHandler as! U.ImagePredictionHandler)
            return result
        } catch {
            print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
        }
        return result
    }
    
    private func imagePredictionHandler(_ predictions: [Prediction]?) {
        guard let predictions = predictions else {
            result = "No predictions. (Check console log.)"
            return
        }
        let formattedPredictions = formatPredictions(predictions)
        result = formattedPredictions.joined(separator: "\n")
    }
    
    private func formatPredictions(_ predictions: [Prediction]) -> [String] {
        // Vision sorts the classifications in descending confidence order.
        let topPredictions: [String] = predictions.prefix(predictionsToShow).map { prediction in
            var name = prediction.classification

            // For classifications with more than one name, keep the one before the first comma.
            if let firstComma = name.firstIndex(of: ",") {
                name = String(name.prefix(upTo: firstComma))
            }

//            return "\(name) - \(prediction.confidencePercentage)%"
            return "\(name)"
        }

        return topPredictions
    }
}

