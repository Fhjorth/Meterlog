//
//  CarDetailView.swift
//  MeterLog
//
//  Created by Frederik Hjorth on 19/02/2021.
//

import SwiftUI

struct CarDetailView: View {
    @State
    private var shownSegment: Int = 1
    
    var car: Car
    
    var body: some View {
        VStack{
            ZStack {
                if (shownSegment == 1){
                    FillupsView(car: car)
                }
                else{
                    GraphView()
                }
            }
            
            Picker(selection: $shownSegment, label: Text("Picker"), content: {
                Text("1").tag(1)
                Text("2").tag(2)
            })
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct CarDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CarDetailView(car: Car.carForTest)
    }
}
