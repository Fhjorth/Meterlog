//
//  Car.swift
//  MeterLog
//
//  Created by Henrik Top Mygind on 21/02/2021.
//

import Foundation
import Firebase

class Car: ObservableObject, Identifiable {
    var id: UUID
    @Published var name: String = ""
    
    private var subscriptions = [ListenerRegistration]()
    
    var database: Firestore? {
        didSet {
            guard let database = database else { return }
            
            subscriptions.append(contentsOf: subscribe(database: database))
//
//            database.collection("cars").document(id.uuidString).addSnapshotListener { (snapshot, err) in
//                if let err = err {
//                    print("Subscription failed: \(err.localizedDescription)")
//                    return
//                }
//
//                guard let snapshot = snapshot else {
//                    print("Subscription failed!")
//                    return
//                }
//
//                guard let data = snapshot.data(),
//                      let name = data["name"] as? String else { return }
//
//                self.name = name
//            }
//
//            database.fillupCollection(for: self).addSnapshotListener { (snapshot, err) in
//                if let err = err {
//                    print("Fillup subscription failed: \(err.localizedDescription)")
//                    return
//                }
//
//                guard let snapshot = snapshot else {
//                    print("Fillup subscription failed!")
//                    return
//                }
//
//                print("grrr: \(snapshot.documentChanges.map{c in "\(c.document.documentID) \(c.oldIndex)=>\(c.newIndex) \(c.type)"})")
//            }
        }
    }
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
    
    @Published var fillups = [Fillup]() {
        didSet {
            odometers = fillups.map { f in
                Double(f.odometer)
            }
        }
    }
    
    @Published var odometers = [Double]()
    
    func addNewFillup(_ fillup: Fillup){
        fillups.append(fillup)

        guard let database = database else { return }
        database.addFillup(fillup, for: self)
    }
    
    func updateFillup(_ fillup: Fillup){
        guard let index = fillups.firstIndex(where: { f in f.id == fillup.id }) else {
            return
        }
        
        fillups.remove(at: index)
        fillups.insert(fillup, at: index)
        
        guard let database = database else { return }
        database.addFillup(fillup, for: self)
    }
    
    static var carForTest: Car = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM-yyyy"
        
        let testCar = Car(id: UUID(), name: "VW Up!")
        testCar.fillups.append(contentsOf: [
            Fillup(id: UUID(), date: formatter.date(from: "17/01-2021")!, odometer: 12500, volume: 32.1, price: 10.59),
            Fillup(id: UUID(), date: formatter.date(from: "24/01-2021")!, odometer: 12760, volume: 14.6, price: 10.14),
            Fillup(id: UUID(), date: formatter.date(from: "17/01-2021")!, odometer: 13005, volume: 12.2, price: 10.32),
            Fillup(id: UUID(), date: formatter.date(from: "17/01-2021")!, odometer: 13666, volume: 22.1, price: 11.02),
            Fillup(id: UUID(), date: formatter.date(from: "17/01-2021")!, odometer: 13989, volume: 54.6, price: 9.59),
            Fillup(id: UUID(), date: formatter.date(from: "17/01-2021")!, odometer: 14444, volume: 7.6, price: 10.08),
        ])
        return testCar
    }()
}
