//
//  TempFillup.swift
//  MeterLog
//
//  Created by Henrik Top Mygind on 20/02/2021.
//

import Foundation


class TempFillup: ObservableObject {
    
    private var id: UUID

    let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM-yyyy HH:mm"
        return formatter
    }()
    
    init(){
        id = UUID()
        date = dateFormatter.string(from: Date())
    }
    
    @Published var date: String { didSet { validate() } }
    @Published var odometer: String = "" { didSet { validate() } }
    @Published var volume: String = "" { didSet { validate() } }
    @Published var price: String = "" { didSet { validate() } }
    
    @Published var isValid = false
    
    func save() {
        selection = nil
        print("Saving the things!")
    }
    
    private func validate(){
        isValid = fillup != nil
    }
    
    private var fillup: Fillup? {
        guard
            let aDate = dateFormatter.date(from: date),
            let aOdometer = Int(odometer),
            let aVolume = Float(volume),
            let aPrice = Float(price) else {
            return nil
        }
        
        return Fillup.createFrom(date: aDate, odometer: aOdometer, volume: aVolume, price: aPrice)
    }
}
