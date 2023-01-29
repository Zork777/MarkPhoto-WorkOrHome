//
//  CalculatingNumberRowSizeItem.swift
//  MarkPhoto-WorkOrHome
//
//  Created by Евгений Захаров on 29.01.2023.
//

import Foundation
import SwiftUI

class CalculatingNumberRowsSizeItem: ObservableObject {
    @Published var sizeItem = UIScreen.screenWidth * 0.8
    @Published var countRows: Int = 1
    private var lastState: Double = 0
    private let minCountRows: Int = 1
    private let maxCountRows: Int = 4
    private let maxSizeItem = UIScreen.screenWidth * 0.8
    private let minSizeItem = (UIScreen.screenWidth) / 4
    
    
    func adjustCountRows (from state: MagnificationGesture.Value) {
        let delta = state - (lastState == 0 ? state : lastState)
        lastState = state
        
        sizeItem += delta * 100
        if sizeItem < UIScreen.screenWidth / CGFloat(countRows) * 0.3 && countRows > 0 {
            countRows += 1
            sizeItem = UIScreen.screenWidth / CGFloat(countRows)
        }
        
        if sizeItem > maxSizeItem * 0.9 && countRows > 1 {
            countRows -= 1
            sizeItem = UIScreen.screenWidth / CGFloat(countRows)
        }
        
        validateSizeItemLimits()
        validateCountRowsLimits()
    }
    
    func lastStateZero() {
        lastState = 0
    }
    
    private func getMinimumCountRowsAllowed() -> Int {
        return max (countRows, minCountRows)
    }
    
    private func getMaximumCountRowsAllowed() -> Int {
        return min (countRows, maxCountRows)
    }
    
    private func getMinimumSizeItemAllowed() -> CGFloat {
        return max (sizeItem, minSizeItem)
    }
    
    private func getMaximumSizeItemAllowed() -> CGFloat {
        return min (sizeItem, maxSizeItem)
    }
    
    private func validateCountRowsLimits() {
        countRows = getMinimumCountRowsAllowed()
        countRows = getMaximumCountRowsAllowed()
    }
    
    private func validateSizeItemLimits() {
        sizeItem = getMinimumSizeItemAllowed()
        sizeItem = getMaximumSizeItemAllowed()
    }
    
}
