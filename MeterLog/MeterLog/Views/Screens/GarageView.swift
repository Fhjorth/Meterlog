//
//  ContentView.swift
//  MeterLog
//
//  Created by Frederik Hjorth on 19/02/2021.
//

import SwiftUI

struct GarageView: View {
    
    @EnvironmentObject
    var appManager: AppManager
    
    @State private var addingNewCar = false
    
    init() {
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(appManager.cars, id: \.id) {car in
                    ZStack {
                        GarageViewListItemView(car: car)
                        
                        NavigationLink(destination: CarDetailView(car: car)){
                            
                        }
                        .buttonStyle(PlainButtonStyle())
                        .opacity(0)
                    }
                }.onDelete { (indexSet) in
                    appManager.removeCar(at: indexSet)
                }
            }
            .navigationBarTitle("MeterMan", displayMode: .inline)
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    addingNewCar.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .font(.title)
                })
                .sheet(isPresented: $addingNewCar, content: {
                    AddCarView(haveToPresent: $addingNewCar, car: Car(id: UUID(), name: ""))
                })
            })
        }
        
    }
}

struct GarageView_Previews: PreviewProvider {
    static var previews: some View {
        GarageView()
            .environmentObject(AppManager.managerForTest)
    }
}
