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
    @State var carName = ""
    @State var carKilometers = ""
    @State var everythingIsEmpty: Bool = false
    @State var editingMode: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.13, green: 0.58, blue: 0.69), Color(red: 0.43, green: 0.84, blue: 0.93)]), startPoint: .leading, endPoint: .trailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if let name = car.name {
                    Text(name)
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                        .padding(.top, 20)
                }
                if !carName.isEmpty {
                    Text(carName)
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                        .padding(.top, 20)
                }
                
                if let km = car.fillups.last?.odometer {
                    Text("\(km)")
                        .foregroundColor(.white)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.bottom, 20)
                        .padding(.top, 20)
                }
                
                if !carKilometers.isEmpty {
                    Text(carKilometers)
                        .foregroundColor(.white)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.bottom, 20)
                        .padding(.top, 20)
                }
                
                Spacer()
                
                MyTextfield(textFieldValue: $carName, editingMode: $editingMode, placeholder: "Car Name")
                
                MyTextfield(textFieldValue: $carKilometers, editingMode: $editingMode, placeholder: "Car Kilometers")
                
                
                Spacer()
                
                Button(action: {
                    let carToAdd = Car(id: UUID(), name: carName)
                    carToAdd.fillups.append(Fillup(id: UUID(), date: Date(), odometer: Int(carKilometers) ?? 0, volume: 0, literPrice: 0))
                    CarManager.carManagerForTest.cars.append(carToAdd)
                    self.haveToPresent.toggle()
                }) {
                    Text("Save")
                        .font(.system(.subheadline, design: .rounded))
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(lineWidth: 1)
                        )
                        .foregroundColor(.white)
                }
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
    @Binding var editingMode: Bool
    @State var extend: CGFloat = 20
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
            .border(Color.black)
            .cornerRadius(20)
            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
            .padding([.trailing, .leading], extend)
            .animation(Animation.easeOut)
        }
    }
}
