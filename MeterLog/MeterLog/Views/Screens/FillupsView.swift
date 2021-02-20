//
//  FillupsView.swift
//  MeterLog
//
//  Created by Frederik Hjorth on 19/02/2021.
//

import SwiftUI

struct FillupsView: View {
    
    
    @ObservedObject var car: Car
    
    var body: some View {
        List(car.fillups){ fillup in
            NavigationLink(destination: FillupView(car: car, fillupId: fillup.id)){
                Text("\(fillup.odometer)")
            }
        }
    }
}

struct FillupsView_Previews: PreviewProvider {
    static var previews: some View {
        FillupsView(car: Car.carForTest)
    }
}
