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
    @StateObject var calculatingNumberRowSizeItem = CalculatingNumberRowsSizeItem()

    
    private var rows = [GridItem()]
    
    private var magnification: some Gesture {
        MagnificationGesture()
            .onChanged { state in
                calculatingNumberRowSizeItem.adjustCountRows(from: state)
            }
            .onEnded { state in
                calculatingNumberRowSizeItem.lastStateZero()
            }
    }
    
    
    
    var body: some View {
        VStack{
            if !photosModel.images.isEmpty {
                ScrollView(.horizontal) {
                    LazyHGrid(rows: (1...calculatingNumberRowSizeItem.countRows).indices.map { _ in GridItem() }, spacing: calculatingNumberRowSizeItem.sizeItem/20) {
                        ForEach (photosModel.images) { photo in
                            ItemGridView(photoPredict: photo, width: calculatingNumberRowSizeItem.sizeItem)
                        }
                    }
                    .frame(height: calculatingNumberRowSizeItem.sizeItem)
                }
                .animation(.spring(), value: calculatingNumberRowSizeItem.countRows)
                .padding()
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
    
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


