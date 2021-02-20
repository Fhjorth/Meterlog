//
//  GraphView.swift
//  MeterLog
//
//  Created by Frederik Hjorth on 19/02/2021.
//

import SwiftUI

struct GraphView: View {
    
    //var car: Car
    
    var body: some View {
        VStack {
            GraphContainer()
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 300)
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
