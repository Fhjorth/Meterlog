//
//  GarageViewListItemView.swift
//  MeterLog
//
//  Created by Laurentiu Narcis Zait on 20/02/2021.
//

import SwiftUI

struct GarageViewListItemView: View {
    @ObservedObject var car: Car
    
    var gradient = LinearGradient(gradient: Gradient(colors: [Color(red: 0.13, green: 0.58, blue: 0.69), Color(red: 0.43, green: 0.84, blue: 0.93)]), startPoint: .leading, endPoint: .trailing)
    
    var body: some View {
        HStack {
            
            Image(systemName: "car.fill")
                .resizable()
                .foregroundColor(.white)
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 100)
                .frame(maxWidth: 120, maxHeight: 100)
                .clipped()
                .cornerRadius(20.0)
                .padding(20)

            VStack(alignment: .leading) {
                Text(car.name)
                    .font(.custom("HelveticaNeue-Medium", size: 30))
                    .foregroundColor(.white)
                Text("\(String(format: "%.2f", car.odometers.last ?? 0)) km")
                    .font(.custom("HelveticaNeue-Medium", size: 30))
                    .foregroundColor(.white)
                
            }.padding(20)
        }
        .background(gradient)
        .cornerRadius(25)
        .padding(.top, 5)
        .padding(.bottom, 5)
        
    }
    
}

struct GarageViewListItemView_Previews: PreviewProvider {
    static var previews: some View {
        GarageViewListItemView(car: Car.carForTest)
    }
}
