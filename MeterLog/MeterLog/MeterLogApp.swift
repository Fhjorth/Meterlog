//
//  MeterLogApp.swift
//  MeterLog
//
//  Created by Frederik Hjorth on 19/02/2021.
//

import SwiftUI

@main
struct MeterLogApp: App {
    let carManager = CarManager.carManagerForTest
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(carManager)
        }
    }
}
