//
//  CabideApp.swift
//  Cabide
//
//  Created by Gabriel Medeiros Martins on 16/03/24.
//

import SwiftUI

@main
struct CabideApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ClothingView()
        }
    }
}
