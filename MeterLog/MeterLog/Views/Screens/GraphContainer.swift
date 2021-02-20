//
//  GraphContainer.swift
//  MeterLog
//
//  Created by Frederik Hjorth on 20/02/2021.
//

import SwiftUI
import SwiftUICharts

struct GraphContainer: View {
    
    //var car: Car
    
    
    var body: some View {
        VStack{
            LineView(data: [8,23,54,32,12,37,7,23,43] , title: "test", legend: "Full screen", style: Styles.barChartStyleNeonBlueLight).padding()
                // legend is optional, use optional .padding()
        }
    }
}

struct GraphContainer_Previews: PreviewProvider {
    static var previews: some View {
        GraphContainer()
    }
}
