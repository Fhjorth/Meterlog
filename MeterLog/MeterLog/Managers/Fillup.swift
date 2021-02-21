//
//  Fillup.swift
//  MeterLog
//
//  Created by Henrik Top Mygind on 21/02/2021.
//

import Foundation
import Firebase

class Fillup: Identifiable, ObservableObject {
    private var subscription: ListenerRegistration?
    
    var id: UUID
    @Published var date: Date
    @Published var odometer: Int
    @Published var volume: Float
    @Published var literPrice: Float
    
    var database: Firestore? {
        didSet { subscribe() }
    }
    
    init(id: UUID, date: Date, odometer: Int, volume: Float, price: Float) {
        self.id  = id
        self.date = date
        self.odometer = odometer
        self.volume = volume
        self.literPrice = price
    }
    
    func subscribe() {
        guard let database = self.database else { return }
        
        subscription = database.carDocRef(for: id.uuidString).addSnapshotListener { (snapshot, err) in
            guard let snapshot = snapshot,
                  err == nil else {
                print("Failed subscribing: \(err?.localizedDescription ?? "No message")")
                return
            }
            
            guard let updatedFillup = Fillup.from(snapshot) else { return }
            
            self.date = updatedFillup.date
            self.odometer = updatedFillup.odometer
            self.volume = updatedFillup.volume
            self.literPrice = updatedFillup.literPrice
        }
    }
    
    func unsubscribe() {
        subscription?.remove()
        subscription = nil
    }
    
    static func createFrom(date: Date, odometer: Int, volume: Float, price: Float, id: UUID? = nil) -> Fillup {
        let id = id ?? UUID()
        
        return Fillup(id: id, date: date, odometer: odometer, volume: volume, price: price)
    }
}
