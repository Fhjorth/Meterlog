//
//  Fillup.swift
//  MeterLog
//
//  Created by Henrik Top Mygind on 21/02/2021.
//

import Foundation
import Firebase

class Fillup: Identifiable {
    init(id: UUID,
         date: Date,
         odometer: Int,
         volume: Float,
         price: Float) {
        self.id = id
        self.date = date
        self.odometer = odometer
        self.volume = volume
        self.literPrice = price
    }
    
    var id: UUID
    var date: Date
    var odometer: Int
    var volume: Float
    var literPrice: Float
    
    var database: Firestore? = nil
    
    static func createFrom(date: Date, odometer: Int, volume: Float, price: Float, id: UUID? = nil) -> Fillup {
        let id = id ?? UUID()
        
        return Fillup(id: id, date: date, odometer: odometer, volume: volume, price: price)
    }
}
