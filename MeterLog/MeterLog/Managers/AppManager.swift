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
    
        Auth.auth().signIn { (user) in
            self.user = user
            self.database = Firestore.firestore()
            subscribe()
        }
        
        func subscribe() {
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
                    self.cars.forEach{ c in c.unsubscribe() }
                    self.cars = cars
                    self.cars.forEach{ c in c.database = database }
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
    
    func updateOrMakeNewCar(car: Car) {
        guard let db = self.database, let user = user else { return }
        
        db.addCar(car: car, for: user)
    }
    
    func removeCar(at index: IndexSet) {
        guard let db = self.database, let user = user else { return }
        
        for i in index {
            let car = cars.remove(at: i)
            db.removeCar(car: car, for: user)
        }
    }
}
