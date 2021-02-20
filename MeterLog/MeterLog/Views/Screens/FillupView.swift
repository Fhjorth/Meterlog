//
//  FillupView.swift
//  MeterLog
//
//  Created by Frederik Hjorth on 19/02/2021.
//

import SwiftUI

struct InputView<Content: View> : View {
    var title: String
    var unit: String? = nil
    
    var content: () -> Content
    
    var body: some View {
        VStack(spacing: 0){
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    
                    content()
                    
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

struct TextInputView : View {
    var title: String
    @Binding var value: String
    var placeholder: String?
    var unit: String? = nil
    
    @Binding var selection: Int?
    var tag: Int
    
    var validator: (String) -> String = { text in text }
    
    var nextText: String?
    var nextAction: () -> () = { }
    @Binding var nextActionEnabled: Bool
    
    var body: some View {
        InputView(title: title, unit: unit) {
            AwesomeInput(
                text: $value,
                placeholder: placeholder,
                selection: $selection,
                tag: tag,
                validator: validator,
                nextText: nextText,
                nextAction: nextAction,
                nextActionEnabled: $nextActionEnabled)
        }
    }
}

struct DateInputView : View {
    var title: String
    @Binding var value: Date
    
    var touchAction: () -> () = { }
    
    // TODO Next
    var nextText: String?
    var nextAction: () -> () = { }
    @Binding var nextActionEnabled: Bool
    
    private let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd/MM-yyyy HH:mm"
        return f
    }()
    
    var body: some View {
        InputView(title: title) {
            Button(action: touchAction) {
                Spacer()
                Text(formatter.string(from: value))
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct FillupView: View {
    @Environment(\.presentationMode) var presentationMode
    
    init(car: Car) {
        self.car = car
        fillup = TempFillup(car: car)
    }
    
    init(car: Car, fillupId: UUID) {
        self.car = car
        fillup = TempFillup(car: car, fillupId: fillupId)
    }
    
    var car: Car
    @ObservedObject var fillup: TempFillup
    
    @State private var showingDatePicker = false
    
    @State private var selection: Int? = 2
    
    let intValidator: (String) -> String = { text in text.filter { c in c.isNumber } }
    let floatValidator: (String) -> String = { text in text.filter { c in c.isNumber || c == "." } }
    
    private func next() { selection = (selection ?? 0) + 1 }
    
    private func save() {
        selection = nil
        fillup.save()
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        ScrollView{
            VStack {
                
//                Text(selection == 1 ? "fillup.date"
//                        : selection == 2 ? fillup.odometer
//                        : selection == 3 ? fillup.volume
//                        : selection == 4 ? fillup.price
//                        : "Nothing selected")
//
//                Spacer()
                
                DateInputView(
                    title: "Date",
                    value: $fillup.date,
                    touchAction: {
                        selection = nil
                        withAnimation {
                            showingDatePicker = true
                        }
                    },
                    nextText: "Next",
                    nextAction: next,
                    nextActionEnabled: .constant(true))
                
                TextInputView(
                    title: "Odometer",
                    value: $fillup.odometer,
                    placeholder: "42500",
                    unit: "km",
                    selection: $selection,
                    tag: 2,
                    validator: intValidator,
                    nextText: "Next",
                    nextAction: next,
                    nextActionEnabled: .constant(true))
                
                TextInputView(
                    title: "Volume",
                    value: $fillup.volume,
                    placeholder: "32.76",
                    unit: "l",
                    selection: $selection,
                    tag: 3,
                    validator: floatValidator,
                    nextText: "Next",
                    nextAction: next,
                    nextActionEnabled: .constant(true))
                
                TextInputView(
                    title: "Price",
                    value: $fillup.price,
                    placeholder: "10.59",
                    unit: "$/l",
                    selection: $selection,
                    tag: 4,
                    validator: floatValidator,
                    nextText: "Save",
                    nextAction: save,
                    nextActionEnabled: $fillup.isValid)
                
                HStack{
                    Spacer()
                    
                    Button(action: save) {
                        Text("Save")
                    }
                    .disabled(fillup.isValid == false)
                    .padding(8)
                    .frame(minWidth: 100)
                    .foregroundColor(.white)
                    .background(fillup.isValid ? Color.blue : Color.blue.opacity(0.5))
                    .cornerRadius(8)
                }
            }.padding()
        }
        .customBottomSheet(isPresented: $showingDatePicker) {
            VStack {
                DatePicker("Date", selection: $fillup.date)
                    .datePickerStyle(WheelDatePickerStyle())
                HStack {
                    Spacer()
                
                    Button(action: {
                        withAnimation {
                            showingDatePicker = false
                        }
                        selection = 2
                    }){
                        Text("Next")
                    }
                    .padding(8)
                    .frame(minWidth: 100)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                }
                .padding()
            }
            .background(Color.white)
                
        }
    }
}

struct FillupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FillupView(car: Car.carForTest)
        }
    }
}
