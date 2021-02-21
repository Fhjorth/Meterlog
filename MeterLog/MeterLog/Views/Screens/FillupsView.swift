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
            ZStack {
                FillupViewListItem(fillup: fillup)
                
                NavigationLink(destination: FillupView(car: car, fillupId: fillup.id)){
                    
                }
                .buttonStyle(PlainButtonStyle())
                .opacity(0)
            }
        }
    }
}

struct FillupsView_Previews: PreviewProvider {
    static var previews: some View {
        FillupsView(car: Car.carForTest)
    }
}
