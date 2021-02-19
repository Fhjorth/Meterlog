//
//  ContentView.swift
//  MeterLog
//
//  Created by Frederik Hjorth on 19/02/2021.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject
    var carManager: CarManager
    
    var body: some View {
        NavigationView {
            List(carManager.cars){car in
                NavigationLink(destination: CarDetailView(car: car)){
                    Text(car.name)
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CarManager.carManagerForTest)
    }
}
