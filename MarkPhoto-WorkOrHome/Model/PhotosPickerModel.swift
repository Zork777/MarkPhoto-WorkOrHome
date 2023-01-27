//
//  PhotosPickerModel.swift
//  MarkPhoto#WorkOrHome
//
//  Created by Евгений Захаров on 12.01.2023.
//

import SwiftUI
import PhotosUI

class PhotosPickerModel: ObservableObject {
    @Published var image: Image?
    @Published var images: [PhotoPredict] = []
    @Published var selectedPhoto: PhotosPickerItem? {
        didSet {
            if let selectedPhoto {
                processPhoto(from: selectedPhoto)
            }
        }
    }
    
    @Published var selectedPhotos: [PhotosPickerItem] = [] {
        didSet {
            if !selectedPhotos.isEmpty {
                images.removeAll()
                processPhoto(from: selectedPhotos)
                selectedPhotos.removeAll()
            }
        }
    }
    
    func removeAllImages() {
        images.removeAll()
    }
    
    func processPhoto (from selectedPhotos: [PhotosPickerItem]) {
        for selectedPhoto in selectedPhotos {
            selectedPhoto.loadTransferable(type: Data.self) { result in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    switch result {
                    case .success(let data):
                        if let data, let uiImage = UIImage(data: data){
                            let predict = AnalysisImage(imagePredictor: ImagePredictorClassifier(), image: uiImage)
                            let labelPredict = predict.predict()
                            self.images.append(.init(image: Image(uiImage: uiImage), label: labelPredict))
                        }
                    case .failure(let error):
                        print (error.localizedDescription)
                        self.images.append(.init(image:Image(systemName: "photo")))
                    }
                }

            }
        }
    }
    
    
    func processPhoto (from selectedPhoto: PhotosPickerItem) {
        selectedPhoto.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data, let uiImage = UIImage(data: data){
                    self.image = Image(uiImage: uiImage)
                }
            case.failure(let error):
                print (error.localizedDescription)
                self.image = Image(systemName: "photo")
            }
        }
    }
}
