//
//  Fillup.swift
//  MeterLog
//
//  Created by Henrik Top Mygind on 21/02/2021.
//

import Foundation

struct Fillup: Identifiable {
    var id: UUID
    var date: Date
    var odometer: Int
    var volume: Float
    var literPrice: Float
    
    static func createFrom(date: Date, odometer: Int, volume: Float, price: Float, id: UUID? = nil) -> Fillup {
        let id = id ?? UUID()
        
        return Fillup(id: id, date: date, odometer: odometer, volume: volume, literPrice: price)
    }
}
