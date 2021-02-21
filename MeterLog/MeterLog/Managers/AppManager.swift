//
//  CarManager.swift
//  MeterLog
//
//  Created by Frederik Hjorth on 19/02/2021.
//

import Foundation
import Firebase

class AppManager: ObservableObject {
    
    @Published
    var cars = [Car]()
    
    @Published
    var user: User?
    
    private var database: Firestore?
    
    private var subscription: ListenerRegistration?
    
    func initForReal() {
        FirebaseApp.configure()
        database = Firestore.firestore()
    
        Auth.auth().signIn { (user) in
            self.user = user
            
            guard let user = user,
                  let database = self.database else { return }
            
            self.subscription = database.carCollection(for: user).addSnapshotListener { (snapshot, err) in
                guard let snapshot = snapshot,
                      err == nil else {
                    print("Failed subscribing: \(err?.localizedDescription ?? "No message")")
                    return
                }
                
                let carIds = snapshot.documents.map { d in d.documentID }
                createCars(database: database, carIds: carIds) { (cars) in
                    self.cars = cars
                }
            }
        }
        
        func createCars(database: Firestore, carIds: [String], completion: @escaping ([Car]) -> ()) {
            var cars = [Car]()
            
            var remaining = carIds.count
            
            func done() {
                remaining -= 1
                if remaining <= 0 {
                    completion(cars)
                }
            }
            
            for carId in carIds {
                database.carDocRef(for: carId).getDocument { (snapshot, err) in
                    guard let snapshot = snapshot,
                          err == nil else {
                        print("Failed getting car: \(err?.localizedDescription ?? "No message")")
                        done()
                        return
                    }
                    
                    if let car = Car.from(snapshot) {
                        cars.append(car)
                    }
                    
                    done()
                }
            }
        }
    }
    
    func initForTest() {
        cars = [Car.carForTest]
    }
    
    static var managerForReal: AppManager = {
        let carManager = AppManager()
        carManager.initForReal()
        return carManager
    }()
    
    static var managerForTest: AppManager = {
        let carManager = AppManager()
        carManager.initForTest()
        return carManager
    }()
    
    static func updateOrMakeNewCar(car: Car) {
        let db = Firestore.firestore()
        db.addCar(car: car, for: managerForReal.user!)
       
//        var carToBeUpdates = managerForTest.cars.filter { $0.id == car.id}.first
//        if carToBeUpdates == nil {
//            managerForTest.cars.append(car)
//        } else {
//            carToBeUpdates = car
//        }
    }
}
