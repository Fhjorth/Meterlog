//
//  Database.swift
//  MeterLog
//
//  Created by Henrik Top Mygind on 21/02/2021.
//

import Foundation
import Firebase

extension Auth {
    func signIn(completion: @escaping (User?) -> ()) {
        self.signInAnonymously { (result, err) in
            if let err = err {
                print("Error signing in: \(err.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let result = result else {
                print("Error signing in!")
                completion(nil)
                return
            }
            
            completion(result.user)
        }
    }
}

extension AppManager {
    func subscribe(database: Firestore) -> ListenerRegistration?  {
        guard let user = self.user else { return nil }
        
        return database.carCollection(for: user).addSnapshotListener { (snapshot, err) in
            guard let snapshot = snapshot,
                  err == nil else {
                print("Error subscribing cars. " + "\(err?.localizedDescription ?? "")")
                return
            }
            
            
            let carDocs = snapshot.documentChanges.compactMap { c -> DocumentReference? in
                if c.type == .removed { return nil }
                return database.document(for: c.document.documentID)
            }
            
            var cars = [Car]()
            
            func finish() {
                self.cars.forEach { c in c.unsubscribe() }
                self.cars = cars
                self.cars.forEach { c in c.database = database }
            }
            
            var finished = 0
            for carDoc in carDocs {
                carDoc.getDocument { (carSnapshot, carErr) in
                    guard let carSnapshot = carSnapshot,
                          carErr == nil,
                          let car = Car.fromDatabase(carSnapshot) else {
                        print("Failed getting car info. \(carErr?.localizedDescription ?? "")")
                        
                        finished += 1
                        if finished == carDocs.count { finish() }
                        return
                    }
                    
                    cars.append(car)
                    
                    finished += 1
                    if finished == carDocs.count { finish() }
                }
            }
        }
    }
}

extension Car {
    func subscribe(database: Firestore) -> [ListenerRegistration] {
        let carSub = database.document(for: self).addSnapshotListener { (snapshot, err) in
            guard let snapshot = snapshot,
                  err == nil else {
                print("Car susbscription failed. \(err?.localizedDescription ?? "")")
                return
            }
            
            guard let updatedCar = Car.fromDatabase(snapshot) else { return }
            self.name = updatedCar.name
        }
        
        let fillupSub = database.fillupCollection(for: self).addSnapshotListener { (snapshot, err) in
            guard let snapshot = snapshot,
                  err == nil else {
                print("Fillup subscritpion failed. \(err?.localizedDescription ?? "")")
                return
            }
            
            let fillups = snapshot.documentChanges.compactMap { c -> Fillup? in
                if c.type == .removed { return nil }
                return Fillup.fromDatabase(c.document)
            }
            
            self.fillups.forEach { f in f.unsubscribe() }
            self.fillups = fillups
            self.fillups.forEach { f in f.database = database }
        }
        
        return [carSub, fillupSub]
    }
    
    func unsubscribe() {
        // TODO
    }
}

extension Fillup {
    func subscribe() {
        
    }
    
    func unsubscribe() {
        
    }
}

extension Firestore {
    func document(for car: Car) -> DocumentReference {
        return document(for: car.id.uuidString)
    }
    
    func document(for carId: String) -> DocumentReference {
        return self.collection("cars/").document("\(carId)")
    }
    
    func fillupCollection(for car: Car) -> CollectionReference {
        let id = car.id.uuidString
        return self.collection("cars/\(id)/Fillups")
    }
    
    func carCollection(for user: User) -> CollectionReference {
        return self.collection("users/\(user.uid)/cars")
    }
    
    func getCars(for user: User, completion: @escaping ([Car]) -> ()) {
        carCollection(for: user).getDocuments(completion: { (snapshot, err) in
            guard let snapshot = snapshot,
                  err == nil else {
                print("Error getting cars. \(err?.localizedDescription ?? "")")
                completion([])
                return
            }
            
            let cars = snapshot.documents.compactMap { d in
                Car.fromDatabase(d)
            }
            
            completion(cars)
        })
    }
    
//    func getCars(for user: User, completion: @escaping ([Car]) -> ()) {
//
//        carCollection(for: user).getDocuments { (carIdSnap, carIdErr) in
//            if let carIdErr = carIdErr {
//                print("Error getting cars for user: \(carIdErr.localizedDescription)")
//                completion([])
//                return
//            }
//
//            guard let carIdSnap = carIdSnap else {
//                print("Error getting cars for user!")
//                completion([])
//                return
//            }
//
//            let availableCars = carIdSnap.documents.map { d in d.documentID }
//
//            self.collection("cars").getDocuments { (carsSnap, carsErr) in
//                if let carsErr = carsErr {
//                    print("Firestore-error: \(carsErr.localizedDescription)")
//                    completion([])
//                    return
//                }
//
//                guard let carsSnap = carsSnap else {
//                    print("Firestore-error!")
//                    completion([])
//                    return
//                }
//
//                var finished = 0
//                var cars = [Car]()
//
//                for carDoc in carsSnap.documents {
//
//                    let data = carDoc.data()
//
//                    guard availableCars.contains(carDoc.documentID),
//                          let id = UUID(uuidString: carDoc.documentID),
//                          let name = data["name"] as? String
//                          else {
//
//                        finished += 1
//                        if finished == carsSnap.count {
//                            completion(cars)
//                        }
//
//                        return
//                    }
//
//                    let car = Car(id: id, name: name)
//
//                    self.getFillups(for: car){ fillups in
//                        car.fillups = fillups
//                        car.database = self
//                        cars.append(car)
//
//                        finished += 1
//                        if finished == carsSnap.count {
//                            completion(cars)
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    func getFillups(for car: Car, completion: @escaping ([Fillup]) -> ()) {
//
//        fillupCollection(for: car).getDocuments { (fillupSnap, fillupErr) in
//            if let fillupErr = fillupErr {
//                print("Firestore-error: \(fillupErr.localizedDescription)")
//                completion([])
//                return
//            }
//
//            guard let fillupSnap = fillupSnap else {
//                print("Firestore-error!")
//                completion([])
//                return
//            }
//
//            let fillups = fillupSnap.documents.compactMap { doc -> Fillup? in
//                let data = doc.data()
//
//                guard let id = UUID(uuidString: doc.documentID),
//                      let date = (data["date"] as? Timestamp)?.dateValue(),
//                      let odometer = data["odometer"] as? Int,
//                      let dvolume = data["volume"] as? Double,
//                      let dprice = data["volume"] as? Double
//                    else {
//                        return nil
//                    }
//
//                return Fillup(id: id, date: date, odometer: odometer, volume: Float(dvolume), price: Float(dprice))
//            }
//
//            completion(fillups)
//        }
//    }
    
    func addFillup(_ fillup: Fillup, for car: Car) {
        fillupCollection(for: car)
            .document(fillup.id.uuidString)
            .setData(fillup.databaseData)
    }
}

extension Car {
    static func fromDatabase(_ document: DocumentSnapshot) -> Car? {
        guard let data = document.data(),
              let id = UUID(uuidString: document.documentID),
              let name = data["name"] as? String else { return nil }
        
        return Car(id: id, name: name)
    }
}

extension Fillup {
    static func fromDatabase(_ document: DocumentSnapshot) -> Fillup? {
        guard let data = document.data(),
              let id = UUID(uuidString: document.documentID),
              let date = (data["date"] as? Timestamp)?.dateValue(),
              let odometer = data["odometer"] as? Int,
              let volume = data["volume"] as? Double,
              let price = data["volume"] as? Double else { return nil }
        
        return Fillup(id: id, date: date, odometer: odometer, volume: Float(volume), price: Float(price))
    }
    
    var databaseData: [String : Any] {
        return [
            "date" : Timestamp(date: date),
            "odometer" : odometer,
            "price" : literPrice,
            "volume" : volume
        ]
    }
}
