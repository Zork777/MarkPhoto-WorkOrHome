//
//  ItemGrid.swift
//  MarkPhoto#WorkOrHome
//
//  Created by Евгений Захаров on 13.01.2023.
//

import SwiftUI

struct ItemGridView: View {
    var photoPredict: PhotoPredict
    var width: CGFloat = .infinity
    
    var body: some View {
        VStack(alignment: .center, spacing: 1) {
            photoPredict.image
                .resizable()
                .scaledToFit()
                .cornerRadius(width/30)
            
            Text(photoPredict.label)
                .font(.system(size: width/15))
                .padding(width/40)
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(width/30)
    }
}

struct ItemGridView_Previews: PreviewProvider {
    static var previews: some View {
        ItemGridView(photoPredict: PhotoPredict(image: Image(systemName: "photo")))
    }
}
