//
//  Database.swift
//  MeterLog
//
//  Created by Henrik Top Mygind on 21/02/2021.
//

import Foundation
import Firebase

extension Firestore {
    func getCars(completion: @escaping ([Car]) -> ()) {
        self.collection("cars").getDocuments { (carsSnap, carsErr) in
            if let carsErr = carsErr {
                print("Firestore-error: \(carsErr)")
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
                
                guard let id = UUID(uuidString: carDoc.documentID),
                      let name = data["name"] as? String else {
                    
                    finished += 1
                    if finished == carsSnap.count {
                        completion(cars)
                    }
                    
                    return
                }
                
                print("Id: \(id)")
                print("Name: \(name)")
                
                self.getFillups(id: id.uuidString){ fillups in
                    print("Fillups: \(fillups)")
                    
                    let car = Car(id: id, name: name)
                    car.fillups = fillups
                    cars.append(car)
                    
                    finished += 1
                    if finished == carsSnap.count {
                        completion(cars)
                    }
                }
            }
        }
    }

    func getFillups(id: String, completion: @escaping ([Fillup]) -> ()) {
        self.collection("cars/\(id)/Fillups").getDocuments { (fillupSnap, fillupErr) in
            if let fillupErr = fillupErr {
                print("Firestore-error: \(fillupErr)")
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
}
