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
    
    func initForReal() {
        FirebaseApp.configure()
        database = Firestore.firestore()
    
        Auth.auth().signIn { (user) in
            self.user = user
            
            guard let user = user,
                  let database = self.database else { return }
            
            database.carCollection(for: user).addSnapshotListener { (snapshot, err) in
                guard let snapshot = snapshot,
                      err == nil else {
                    print("Failed subscribing: \(err?.localizedDescription ?? "No message")")
                    return
                }
                
                let carIds = snapshot.documents.map { d in d.documentID }
                print(carIds)
            }
            
//            database.getCars(for: user) { cars in
//                self.cars = cars
//            }
            
            
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
