//
//  MainContentView.swift
//  MarkPhoto#WorkOrHome
//
//  Created by Евгений Захаров on 12.01.2023.
//

import SwiftUI
import PhotosUI

struct MainContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var photosModel = PhotosPickerModel()
    @State private var sizeItem = UIScreen.screenWidth - 16*2
    @State private var countRows: Int = 1
    @State private var lastState: Double = 0
    private let minCountRows: Int = 1
    private let maxCountRows: Int = 4
    private let maxSizeItem = UIScreen.screenWidth
    private let minSizeItem = (UIScreen.screenWidth) / 4
    
    private var rows = [GridItem()]
    
    private var magnification: some Gesture {
        MagnificationGesture()
            .onChanged { state in
                adjustCountRows(from: state)
            }
            .onEnded { state in
                lastState = 0
//                validateCountRowsLimits()
//                validateSizeItemLimits()
            }
    }
    
    
    
    var body: some View {
        VStack{
            if !photosModel.images.isEmpty {
                ScrollView(.horizontal) {
                    LazyHGrid(rows: (1...countRows).indices.map { _ in GridItem() }, spacing: sizeItem/20) {
                        ForEach (photosModel.images) { photo in
                            ItemGridView(photoPredict: photo, width: sizeItem)
                        }
                    }
                    .frame(height: sizeItem)
                }
            } else {
                Spacer()
                Text ("Tap button for select a photo")
            }
            Spacer()
            PhotosPicker(selection: $photosModel.selectedPhotos,
                         maxSelectionCount: 10,
                         matching: .images,
                         photoLibrary: .shared()) {
                Text ("Scan Photo")
            }
                         .buttonStyle(.borderedProminent)
                         .font(.largeTitle)
        }
        .contentShape(Rectangle())
        .gesture(magnification)
    }
    
    func adjustCountRows (from state: MagnificationGesture.Value) {
//        print ("last- \(lastState)")
//        print ("state- \(state)")
        let delta = state - (lastState == 0 ? state : lastState)
        lastState = state

        sizeItem += delta * 100
        if sizeItem < UIScreen.screenWidth / CGFloat(countRows) * 0.6 && countRows > 0 {
            countRows += 1
            sizeItem = UIScreen.screenWidth / CGFloat(countRows)
        }
        
        if sizeItem > maxSizeItem * 0.9 && countRows > 1 {
            countRows -= 1
            sizeItem = UIScreen.screenWidth / CGFloat(countRows)
        }
        
        validateSizeItemLimits()
        validateCountRowsLimits()
//        print ("delta- \(delta)")
//        print ("SizeItem- \(sizeItem)")
//        print ("countRow- \(countRows)")
    }
    
    func getMinimumCountRowsAllowed() -> Int {
        return max (countRows, minCountRows)
    }
    
    func getMaximumCountRowsAllowed() -> Int {
        return min (countRows, maxCountRows)
    }
    
    func getMinimumSizeItemAllowed() -> CGFloat {
        return max (sizeItem, minSizeItem)
    }
    
    func getMaximumSizeItemAllowed() -> CGFloat {
        return min (sizeItem, maxSizeItem)
    }
    
    func validateCountRowsLimits() {
        countRows = getMinimumCountRowsAllowed()
        countRows = getMaximumCountRowsAllowed()
    }
    
    func validateSizeItemLimits() {
        sizeItem = getMinimumSizeItemAllowed()
        sizeItem = getMaximumSizeItemAllowed()
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


