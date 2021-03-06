//
//  MeterLogApp.swift
//  MeterLog
//
//  Created by Frederik Hjorth on 19/02/2021.
//

import SwiftUI
import Firebase

@main
struct MeterLogApp: App {
    let appManager = AppManager.managerForReal
    
    var isHtmy = false
    
    var body: some Scene {
        WindowGroup {
            if isHtmy {
                FillupView(car: Car.carForTest)
            }
            else
            {
                GarageView()
                    .environmentObject(appManager)
            }
        }
    }
}
