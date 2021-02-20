//
//  ContentView.swift
//  MeterLog
//
//  Created by Frederik Hjorth on 19/02/2021.
//

import SwiftUI

struct GarageView: View {
    
    @EnvironmentObject
    var carManager: CarManager
    
    var body: some View {
        NavigationView {
            List(carManager.cars){car in
                ZStack {
                    GarageViewListItemView(carName: car.name)
                    NavigationLink(destination: CarDetailView(car: car)){
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                    .opacity(0)
                }
            }.navigationBarTitle("MeterMan \nTeam TopNachos")
        }
        
    }
}

struct GarageView_Previews: PreviewProvider {
    static var previews: some View {
        GarageView()
            .environmentObject(CarManager.carManagerForTest)
    }
}
