//
//  CarDetailView.swift
//  MeterLog
//
//  Created by Frederik Hjorth on 19/02/2021.
//

import SwiftUI

struct CarDetailView: View {
    @State
    private var shownSegment: Int = 2
    @State
    private var editingCar = false
    @State
    private var addingFillup = false
    
    
    var car: Car
    
    
    var body: some View {
        VStack{
            ZStack {
                if (shownSegment == 1){
                    FillupsView(car: car)
                }
                else{
                    GraphView(car: car)
                        
                }
            }
            .frame(maxHeight: .infinity)
            
            Picker(selection: $shownSegment, label: Text("Picker"), content: {
                Text("1").tag(1)
                Text("2").tag(2)
            })
            .pickerStyle(SegmentedPickerStyle())
        }
        .navigationBarTitle(car.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: HStack{
            Button(action: {
                editingCar.toggle()
            }, label: {
                Image(systemName: "gearshape")
                
            })
            .sheet(isPresented: $editingCar, content: {
                AddCarView()
            })
            
            Button(action: {
                addingFillup.toggle()
            }, label: {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $addingFillup, content: {
                FillupView(car: car)
            })
        })
    }
}

struct CarDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            CarDetailView(car: Car.carForTest)
        }
        
    }
}
