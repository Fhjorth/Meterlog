//
//  FillupView.swift
//  MeterLog
//
//  Created by Frederik Hjorth on 19/02/2021.
//

import SwiftUI

struct MyInput : View {
    
    var title: String
    @Binding var value: String
    var placeholder: String?
    var unit: String? = nil
    
    @Binding var selection: Int?
    var tag: Int
    
    var validator: (String) -> String = { text in text }
    
    var nextText: String?
    var nextAction: () -> () = { }
    
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
                        AwesomeInput(
                            text: $value,
                            placeholder: placeholder,
                            selection: $selection,
                            tag: tag,
                            validator: validator,
                            nextText: nextText,
                            nextAction: nextAction)
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
    @ObservedObject var fillup = TempFillup()
    
    @State private var selection: Int? = 2
    
    let intValidator: (String) -> String = { text in text.filter { c in c.isNumber } }
    let floatValidator: (String) -> String = { text in text.filter { c in c.isNumber || c == "." } }
    
    private func next() { selection = (selection ?? 0) + 1 }
    private func save() {
        selection = nil
        print("Saving the things!")
    }
    
    var body: some View {
        ScrollView{
            VStack {
                
                Text(selection == 1 ? fillup.date
                        : selection == 2 ? fillup.odometer
                        : selection == 3 ? fillup.volume
                        : selection == 4 ? fillup.price
                        : "Nothing selected")
                
                Spacer()
                
                MyInput(
                    title: "Date",
                    value: $fillup.date,
                    placeholder: "1/12-2021",
                    unit: "",
                    selection: $selection,
                    tag: 1,
                    nextText: "Next",
                    nextAction: next,
                    isDate: true)
                
                MyInput(
                    title: "Odometer",
                    value: $fillup.odometer,
                    placeholder: "42500",
                    unit: "km",
                    selection: $selection,
                    tag: 2,
                    validator: intValidator,
                    nextText: "Next",
                    nextAction: next)
                
                MyInput(
                    title: "Volume",
                    value: $fillup.volume,
                    placeholder: "32.76",
                    unit: "l",
                    selection: $selection,
                    tag: 3,
                    validator: floatValidator,
                    nextText: "Next",
                    nextAction: next)
                
                MyInput(
                    title: "Price",
                    value: $fillup.price,
                    placeholder: "10.59",
                    unit: "$/l",
                    selection: $selection,
                    tag: 4,
                    validator: floatValidator,
                    nextText: "Save",
                    nextAction: save)
                
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
}

struct FillupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FillupView()
        }
    }
}
