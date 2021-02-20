//
//  AddCarView.swift
//  MeterLog
//
//  Created by Frederik Hjorth on 19/02/2021.
//

import SwiftUI

struct AddCarView: View {
    @Binding var haveToPresent: Bool
    
    var body: some View {
        ZStack {
//            Color(red: 0.09, green: 0.11, blue: 0.15)
//                       .edgesIgnoringSafeArea(.all)
            
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.13, green: 0.58, blue: 0.69), Color(red: 0.43, green: 0.84, blue: 0.93)]), startPoint: .leading, endPoint: .trailing)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("Hello, World!")
                    .foregroundColor(.black)
                    .padding(.top, 20)
                
                Spacer()
                
                Button(action: {
                    self.haveToPresent.toggle()
                }) {
                    Text("Save")
                        .font(.system(.subheadline, design: .rounded))
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(lineWidth: 1)
                        )
                        .foregroundColor(.black)
                }
            }
        }
        
    }
}

struct AddCarView_Previews: PreviewProvider {
    static var previews: some View {
        AddCarView(haveToPresent: .constant(true))
    }
}
