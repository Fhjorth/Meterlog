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
    
    func initForReal() {
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        
        Auth.auth().signIn { (user) in
            self.user = user
            
            guard let user = user else { return }
            
            db.getCars(for: user) { (cars) in
                print(cars)
                
                self.cars = cars
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
