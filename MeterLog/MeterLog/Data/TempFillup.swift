//
//  TempFillup.swift
//  MeterLog
//
//  Created by Henrik Top Mygind on 20/02/2021.
//

import Foundation


class TempFillup: ObservableObject {
    
    private let id: UUID
    private let isEditing: Bool

    private let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM-yyyy HH:mm"
        return formatter
    }()
    
    init(car: Car){
        self.car = car
        id = UUID()
        date = Date()
        isEditing = false
    }
    
    init(car: Car, fillupId: UUID) {
        self.car = car
        
        guard let fillup = car.fillups.first(where: { f in f.id == fillupId }) else {
            id = UUID()
            date = Date()
            isEditing = false
            return
        }
        
        id = fillup.id
        date = fillup.date
        odometer = "\(fillup.odometer)"
        volume = "\(fillup.volume)"
        price = "\(fillup.literPrice)"
        
        isEditing = true
    }
    
    let car: Car
    
    @Published var date: Date { didSet { validate() } }
    @Published var odometer: String = "" { didSet { validate() } }
    @Published var volume: String = "" { didSet { validate() } }
    @Published var price: String = "" { didSet { validate() } }
    
    @Published var isValid = false
    
    func save() {
        guard let fillup = fillup else { return }
        
        if isEditing {
            car.updateFillup(fillup)
        }
        else
        {
            car.addNewFillup(fillup)
        }
    }
    
    private func validate(){
        isValid = fillup != nil
    }
    
    private var fillup: Fillup? {
        guard
            let aOdometer = Int(odometer),
            let aVolume = Float(volume),
            let aPrice = Float(price) else {
            return nil
        }
        
        return Fillup.createFrom(date: date, odometer: aOdometer, volume: aVolume, price: aPrice, id: id)
    }
}
