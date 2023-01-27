//
//  Struct.swift
//  MarkPhoto#WorkOrHome
//
//  Created by Евгений Захаров on 13.01.2023.
//

import SwiftUI

struct PhotoPredict: Identifiable {
    var id: String = UUID().uuidString
    var image: Image
    var label: String = "----"
}

struct Prediction {
    let classification: String
    let confidencePercentage: String
}
