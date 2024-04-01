//
//  PhotoPickerView.swift
//  Cabide
//
//  Created by Eduardo Brum on 31/03/24.
//

import Database
import DependencyInjection
import PhotosUI
import SwiftUI

struct PhotoPickerView: View {
    @ObservedObject var viewModel: ClothingViewModel
    
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @State private var uiImageTeste: UIImage?
    
    init(viewModel: ClothingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            PhotosPicker("Select photo", selection: $avatarItem, matching: .images)
            Button(action: {
                viewModel.removeBackground(inputClotheImage: uiImageTeste)
            }, label: {
                Text("Remove background")
            })
            
            avatarImage?
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            Image(uiImage: viewModel.image)
                .resizable()
                .scaledToFit()
                .frame(width: 700, height: 400)
            
//            Button(action: {
//                if let img = viewModel.clothingUiimage?.pngData() {
//                    let clothing = Clothing(image: img)
//                    // Tries to save a Model (anything that conforms to EntityRepresentable). If it had any trouble, calls completion with nil.
//                    viewModel.repo.save(clothing) { model in
//                        if let model = model {
//                            viewModel.clothes.append(model)
//                            print("Created and saved clothing with id \(model.id).")
//                        } else {
//                            print("Failed to create clothing.")
//                        }
//                    }
//                }
//            }, label: {
//                Text("Salvar")
//            })
            
            
        }
        .onChange(of: avatarItem) {
            Task {
                if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        avatarImage = Image(uiImage: uiImage)
                        uiImageTeste = uiImage
//                        viewModel.clothingUiimage = uiImage
                    }
                } else {
                    print("Failed")
                }
            }
        }
    }
}

#Preview {
    PhotoPickerView(viewModel: ClothingViewModel())
}
