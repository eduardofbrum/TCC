//
//  ClotheView.swift
//  Cabide
//
//  Created by Eduardo Brum on 31/03/24.
//

import PhotosUI
import SwiftUI

struct ClothingView: View {
    @ObservedObject var viewModel: ClothingViewModel = ClothingViewModel()
    
    var body: some View {
        VStack {
            PhotoPickerView(viewModel: viewModel)
            
//            Button("Retrieve") {
//                viewModel.fetchAllClothes()
//            }
//            if viewModel.clothes.count > 0 {
//                Image(uiImage: viewModel.image)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 700, height: 700)
//            }
        }
    }
}
