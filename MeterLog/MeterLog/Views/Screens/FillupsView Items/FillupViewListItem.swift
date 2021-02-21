//
//  FillupViewListItem.swift
//  MeterLog
//
//  Created by Laurentiu Narcis Zait on 21/02/2021.
//

import SwiftUI

struct FillupViewListItem: View {
    var fillup: Fillup
    
    var gradient = LinearGradient(gradient: Gradient(colors: [Color(red: 0.13, green: 0.58, blue: 0.69), Color(red: 0.43, green: 0.84, blue: 0.93)]), startPoint: .leading, endPoint: .trailing)
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(fillup.odometer) km")
                .foregroundColor(.white)
                .padding(.leading, 20)

            HStack {
                Text("\(String(format: "%.2f", fillup.volume)) litres")
                    .foregroundColor(.white)
                    .padding(.leading, 20)
                Spacer()
                Text("\(String(format: "%.2f", fillup.literPrice)) kr/l")
                    .foregroundColor(.white)
                    .padding(.trailing, 20)
            }
        }.frame(maxWidth: .infinity)
        .background(gradient)
        .cornerRadius(25)
        
    }
}

struct FillupViewListItem_Previews: PreviewProvider {
    static var previews: some View {
        FillupViewListItem(fillup: Car.carForTest.fillups.last!)
    }
}
