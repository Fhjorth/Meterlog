//
//  GarageViewListItemView.swift
//  MeterLog
//
//  Created by Laurentiu Narcis Zait on 20/02/2021.
//

import SwiftUI

struct GarageViewListItemView: View {
    var carName: String
    
    var body: some View {
        HStack {
            
            Image(systemName: "car.fill")
                .resizable()
                .foregroundColor(.white)
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 100)
                .clipped()
                .cornerRadius(20.0)
                .padding(20)
            
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text(carName)
                    .foregroundColor(.white)
                Text("12345 km")
                    .foregroundColor(.white)
                
            }
            
            Spacer()
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.13, green: 0.58, blue: 0.69), Color(red: 0.43, green: 0.84, blue: 0.93)]), startPoint: .leading, endPoint: .trailing))
        .border(Color.red)
        .cornerRadius(25)
        .padding(.top, 5)
        .padding(.bottom, 5)
        
    }
    
}

struct GarageViewListItemView_Previews: PreviewProvider {
    static var previews: some View {
        GarageViewListItemView(carName: "VW UP!")
    }
}
