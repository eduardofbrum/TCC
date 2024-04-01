//
//  ClothingViewModel.swift
//  Cabide
//
//  Created by Eduardo Brum on 31/03/24.
//

import CoreImage.CIFilterBuiltins
import Database
import DependencyInjection
import SwiftUI
import Vision

class ClothingViewModel: ObservableObject {
    // This would be on the view model.
    @Injected var repo: any Repository<Clothing>
    
    // This would also be on the view model.
    @Published var clothes: [Clothing] = []
    
    private var processingQueue = DispatchQueue(label: "ProcessingQueue")
    
    @Published var image: UIImage = UIImage()
    @Published var clothingUiimage: UIImage?
    
    func fetchAllClothes() {
        // Fetchs *all* data of type Clothing. If it has any relations, will load those aswell.
        self.repo.fetch { (result: [Clothing]) in
            self.clothes = result
            print("Retrieved \(result.count) clothes.")
            self.image = UIImage(data: result[0].image) ?? UIImage()
        }
    }
    
    func removeBackground(inputClotheImage: UIImage?) {
        guard let image = inputClotheImage else { return }
        guard let inputImage = CIImage(image: image) else {
            print("Failed to create CIImage")
            return
        }
        processingQueue.async {
            guard let maskImage = self.subjectMaskImage(from: inputImage) else {
                print("Failed to create mask image")
                DispatchQueue.main.async {
                    //                    isLoading = false
                }
                return
            }
            let outputImage = self.apply(mask: maskImage, to: inputImage)
            let image = self.render(ciImage: outputImage)
            
            DispatchQueue.main.async {
                self.image = image
                self.clothingUiimage = image
            }
        }
    }
    
    private func subjectMaskImage(from inputImage: CIImage) -> CIImage? {
        let handler = VNImageRequestHandler(ciImage: inputImage)
        let request = VNGenerateForegroundInstanceMaskRequest()
        do {
            try handler.perform([request])
        } catch {
            print(error)
            return nil
        }
        
        guard let result = request.results?.first else {
            print("No observations found")
            return nil
        }
        do {
            let maskPixelBuffer = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: handler)
            return CIImage(cvPixelBuffer: maskPixelBuffer)
        } catch {
            print(error)
            return nil
        }
    }
    
    private func apply(mask: CIImage, to image: CIImage) -> CIImage {
        let filter = CIFilter.blendWithMask()
        filter.inputImage = image
        filter.maskImage = mask
        filter.backgroundImage = CIImage.empty()
        return filter.outputImage!
    }
    
    private func render(ciImage: CIImage) -> UIImage {
        guard let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) else {
            fatalError("Failed to render CGImage")
        }
        return UIImage(cgImage: cgImage)
    }
}
