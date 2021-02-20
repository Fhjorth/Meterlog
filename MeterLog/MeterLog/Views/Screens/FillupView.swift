//
//  FillupView.swift
//  MeterLog
//
//  Created by Frederik Hjorth on 19/02/2021.
//

import SwiftUI

struct MyInput : View {
    
    var title: String
    var unit: String? = nil
    @Binding var selection: Int?
    var tag: Int
    
    @Binding var value: String
    
    var validator: (String) -> String = { text in text }
    var isDate = false
    
    var body: some View {
        VStack(spacing: 0){
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    
                    if isDate {
                        Button(action: {}) {
                            Spacer()
                            Text(value)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    else
                    {
                        AwesomeInput(text: $value, selection: $selection, tag: tag, validator: validator)
//                        TextField(title, text: $value)
//                            .multilineTextAlignment(.trailing)
//                            .textFieldStyle(PlainTextFieldStyle())
//                            .keyboardType(.numbersAndPunctuation)
                    }
                    
                    Rectangle()
                        .fill(Color.black)
                        .frame(height: 2)
                }
            }

            HStack(spacing: 0) {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer(minLength: 4)
                Text(unit ?? "")
            }
        }
    }
}

struct FillupView: View {
//    @State private var date = Date()
//    @State private var odometer: Int = 0
//    @State private var volume: Float = 0
//    @State private var price: String = ""
    
    @State private var date = "20/2-2021"
    @State private var odometer = "14753"
    @State private var volume = "32.12"
    @State private var price = "10.59"
    
    @State private var selection: Int? = 0
    
    let intValidator: (String) -> String = { text in text.filter { c in c.isNumber } }
    let floatValidator: (String) -> String = { text in text.filter { c in c.isNumber || c == "." } }
    
    var body: some View {
        VStack {
            
            Text(selection == 1 ? date
                : selection == 2 ? odometer
                : selection == 3 ? volume
                : selection == 4 ? price
                : "Nothing selected")
            
            Spacer()
            
            MyInput(title: "Date", unit: "", selection: $selection, tag: 1, value: $date, isDate: true)
            
            MyInput(title: "Odometer", unit: "km", selection: $selection, tag: 2, value: $odometer, validator: intValidator)
            MyInput(title: "Volume", unit: "l", selection: $selection, tag: 3, value: $volume, validator: floatValidator)
            MyInput(title: "Price", unit: "$/l", selection: $selection, tag: 4, value: $price, validator: floatValidator)
            
            HStack{
                Spacer()
                
                Button(action: {}) {
                    Text("Save")
                }
                .padding(8)
                .frame(minWidth: 100)
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
            }
        }.padding()
    }
}

struct FillupView_Previews: PreviewProvider {
    static var previews: some View {
        FillupView()
    }
}
