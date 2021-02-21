//
//  AddCarView.swift
//  MeterLog
//
//  Created by Frederik Hjorth on 19/02/2021.
//

import SwiftUI

struct AddCarView: View {
    @Binding var haveToPresent: Bool
    @ObservedObject var car: Car
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.13, green: 0.58, blue: 0.69), Color(red: 0.43, green: 0.84, blue: 0.93)]), startPoint: .leading, endPoint: .trailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(car.name)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                    .padding(.top, 20)
                
                Spacer()
                
                MyTextfield(textFieldValue: $car.name, placeholder: "Car Name")                
                
                Spacer()
                
                Button(action: {
//                    AppManager.managerForTest.cars.append(car)
                    AppManager.updateOrMakeNewCar(car: car)
                    self.haveToPresent.toggle()
                }) {
                    Text("Save")
                        .font(.system(.subheadline, design: .rounded))
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 1)
                        )
                        .foregroundColor(.white)
                }.disabled(car.name.isEmpty)
            }
        }
        
    }
}

struct AddCarView_Previews: PreviewProvider {
    static var previews: some View {
        AddCarView(haveToPresent: .constant(true), car: Car.carForTest)
    }
}

struct MyTextfield: View {
    @Binding var textFieldValue: String
    @State private var editingMode: Bool = false
    @State private var extend: CGFloat = 20
    var placeholder: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if textFieldValue.isEmpty {
                Text(placeholder).foregroundColor(.white)
                    .padding(30)
            }
            TextField("", text: $textFieldValue, onEditingChanged: { edit in
                if edit {
                    self.editingMode = true
                    self.extend = 10
                } else {
                    self.editingMode = false
                    self.extend = 20
                }
            })
            .padding()
            .cornerRadius(20)
            .border(Color.white)
            .autocapitalization(.words)
            .padding([.trailing, .leading], extend)
            .animation(Animation.easeOut)
        }
    }
}
