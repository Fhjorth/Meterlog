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
}

extension Firestore {
    
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
    func removeCar(car: Car, for user: User) {
        carCollection(for: user).document(car.id.uuidString).delete()
    }    
}

extension Car {
    static func from(_ snapshot: DocumentSnapshot) -> Car? {
        guard let data = snapshot.data(),
              let id = UUID(uuidString: snapshot.documentID),
              let name = data["name"] as? String else { return nil }
        
        return Car(id: id, name: name)
    }
    
    var databaseData: [String : Any] {
        return [
            "name" : name
        ]
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
