//
//  ContentView.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 16/03/24.
//

import SwiftUI
import DependencyInjection
import Database

struct ContentView: View {
    @Injected private var repo: any Repository<Clothing>
    
    @State private var clothes: [Clothing] = []
    
    var body: some View {
        VStack {
            Button("Create") {
                if let img = UIImage(systemName: "pencil")?.pngData() {
                    repo.save(Clothing(image: img)) { model in
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
                repo.fetch { (result: [Clothing]) in
                    clothes = result
                    print("Retrieved \(clothes.count) clothes.")
                }
            }
            
            Button("Delete all") {
                for clothing in clothes {
                    self.repo.delete(clothing)
                }
                
                clothes = []
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
