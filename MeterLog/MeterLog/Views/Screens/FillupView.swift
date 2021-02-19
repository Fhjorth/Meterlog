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
    
    var isDate = false
    
    @State
    var value = "0" {
        didSet {
            if isDate {
                
            }
            else {
                let filtered = value.filter{ c in c.isNumber || c == "." }
                if value != filtered {
                    value = filtered
                }
            }
        }
    }
    
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
                        TextField(title, text: $value)
                            .multilineTextAlignment(.trailing)
                            .textFieldStyle(PlainTextFieldStyle())
                            .keyboardType(.numbersAndPunctuation)
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
    @State
    private var date = Date()
    
    @State
    private var odometer: Int = 0
    
    @State
    private var volume: Float = 0
    
    @State
    private var price: String = ""
    
    var body: some View {
        VStack {
            MyInput(title: "Date", unit: "", isDate: true)
            
            MyInput(title: "Odometer", unit: "km")
            MyInput(title: "Volume", unit: "l")
            MyInput(title: "Price", unit: "$/l")
            
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
