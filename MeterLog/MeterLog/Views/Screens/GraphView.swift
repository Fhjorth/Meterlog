//
//  GraphView.swift
//  MeterLog
//
//  Created by Frederik Hjorth on 19/02/2021.
//

import SwiftUI

struct GraphView: View {
    
    var car: Car
    
    var body: some View {
        VStack {
            GraphContainer(car: Car.carForTest)
                .frame(height: 400)
            
            Spacer()
            
            VStack{
                List{
                    Text(car.name)
                    Text("\(car.fillups.count)")
                    Text("Hej")
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
