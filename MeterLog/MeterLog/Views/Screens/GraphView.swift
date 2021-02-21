//
//  GraphView.swift
//  MeterLog
//
//  Created by Frederik Hjorth on 19/02/2021.
//

import SwiftUI
import SwiftUICharts

struct GraphView: View {
    
    var car: Car
   
    
    var body: some View {
        VStack {

            GraphContainer(car: car)
                .frame(height: 400)
            
            Spacer()
            
            VStack{
                List{
                    Text("Car model: \(car.name)")
                    Text("Total Fuel price: \(car.totalPrices)")
                    Text("Best ride: ")
                }
            }
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack{
                ZStack{
                    GraphView(car: Car.carForTest)
                }
            }
        }
    }
}
