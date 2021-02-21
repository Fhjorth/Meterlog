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

extension Firestore {
    func carDocRef(for id: String) -> DocumentReference {
        self.collection("cars").document(id)
    }
    
    func fillupCollection(for car: Car) -> CollectionReference {
        let id = car.id.uuidString
        return self.collection("cars/\(id)/Fillups")
    }
    
    func carCollection(for user: User) -> CollectionReference {
        return self.collection("users/\(user.uid)/cars")
    }
    
    func getCars(for user: User, completion: @escaping ([Car]) -> ()) {
        
        carCollection(for: user).getDocuments { (carIdSnap, carIdErr) in
            if let carIdErr = carIdErr {
                print("Error getting cars for user: \(carIdErr.localizedDescription)")
                completion([])
                return
            }
            
            guard let carIdSnap = carIdSnap else {
                print("Error getting cars for user!")
                completion([])
                return
            }
            
            let availableCars = carIdSnap.documents.map { d in d.documentID }
        
            self.collection("cars").getDocuments { (carsSnap, carsErr) in
                if let carsErr = carsErr {
                    print("Firestore-error: \(carsErr.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let carsSnap = carsSnap else {
                    print("Firestore-error!")
                    completion([])
                    return
                }
                
                var finished = 0
                var cars = [Car]()
                
                for carDoc in carsSnap.documents {
                    
                    let data = carDoc.data()
                    
                    guard availableCars.contains(carDoc.documentID),
                          let id = UUID(uuidString: carDoc.documentID),
                          let name = data["name"] as? String
                          else {
                        
                        finished += 1
                        if finished == carsSnap.count {
                            completion(cars)
                        }
                        
                        return
                    }
                    
                    let car = Car(id: id, name: name)
                    
                    self.getFillups(for: car){ fillups in
                        car.fillups = fillups
                        car.database = self
                        cars.append(car)
                        
                        finished += 1
                        if finished == carsSnap.count {
                            completion(cars)
                        }
                    }
                }
            }
        }
    }

    func getFillups(for car: Car, completion: @escaping ([Fillup]) -> ()) {
        
        fillupCollection(for: car).getDocuments { (fillupSnap, fillupErr) in
            if let fillupErr = fillupErr {
                print("Firestore-error: \(fillupErr.localizedDescription)")
                completion([])
                return
            }
            
            guard let fillupSnap = fillupSnap else {
                print("Firestore-error!")
                completion([])
                return
            }

            let fillups = fillupSnap.documents.compactMap { doc -> Fillup? in
                let data = doc.data()

                guard let id = UUID(uuidString: doc.documentID),
                      let date = (data["date"] as? Timestamp)?.dateValue(),
                      let odometer = data["odometer"] as? Int,
                      let dvolume = data["volume"] as? Double,
                      let dprice = data["volume"] as? Double
                    else {
                        return nil
                    }

                return Fillup(id: id, date: date, odometer: odometer, volume: Float(dvolume), literPrice: Float(dprice))
            }
            
            completion(fillups)
        }
    }
    
    func addFillup(_ fillup: Fillup, for car: Car) {
        fillupCollection(for: car)
            .document(fillup.id.uuidString)
            .setData(fillup.databaseData)
    }
    
    func addCar(car: Car, for user: User) {
        self.collection("cars")
            .document(car.id.uuidString)
            .setData(car.databaseData)
        
        carCollection(for: user)
            .document(car.id.uuidString).setData([:])
    }
    
//    func updateCar(car: Car, for user: User){
//
//    }
    
    
}

extension Car {
    static func from(_ snapshot: DocumentSnapshot) -> Car? {
        guard let data = snapshot.data(),
              let id = UUID(uuidString: snapshot.documentID),
              let name = data["name"] as? String else { return nil }
        
        return Car(id: id, name: name)
    }
}

extension Fillup {
    static func from(_ snapshot: DocumentSnapshot) -> Fillup? {
        guard let data = snapshot.data(),
              let id = UUID(uuidString: snapshot.documentID),
              let date = (data["date"] as? Timestamp)?.dateValue(),
              let odometer = data["odometer"] as? Int,
              let volume = data["volume"] as? Double,
              let price = data["volume"] as? Double
            else {
                return nil
            }

        return Fillup(id: id, date: date, odometer: odometer, volume: Float(volume), literPrice: Float(price))
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

extension Car {
    var databaseData: [String : Any] {
        return [
            "name" : name
        ]
    }
}
