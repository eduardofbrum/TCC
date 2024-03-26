//
//  ContentView.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 16/03/24.
//

import SwiftUI
import DependencyInjection
import Database

struct DatabaseExampleView: View {
    // This would be on the view model.
    @Injected private var repo: any Repository<Clothing>
    
    // This would also be on the view model.
    @State private var clothes: [Clothing] = []
    
    var body: some View {
        VStack {
            Button("Create") {
                if let img = UIImage(systemName: "pencil")?.pngData() {
                    let clothing = Clothing(image: img)
                    // Tries to save a Model (anything that conforms to EntityRepresentable). If it had any trouble, calls completion with nil.
                    repo.save(clothing) { model in
                        if let model = model {
                            clothes.append(model)
                            print("Created and saved clothing with id \(model.id).")
                        } else {
                            print("Failed to create clothing.")
                        }
                    }
                }
            }
            
            Button("Retrieve") {
                // Fetchs *all* data of type Clothing. If it has any relations, will load those aswell.
                repo.fetch { (result: [Clothing]) in
                    clothes = result
                    print("Retrieved \(clothes.count) clothes.")
                }
            }
            
            Button("Delete all") {
                for clothing in clothes {
                    // Asks for a model to delete. If it has any relations, will follow the deletion rules (I think it doesn't cascade automatically, only 2023 Gabriel knows wtf this actually does).
                    self.repo.delete(clothing)
                }
                
                clothes = []
            }
        }
        .padding()
    }
}

#Preview {
    DatabaseExampleView()
}
