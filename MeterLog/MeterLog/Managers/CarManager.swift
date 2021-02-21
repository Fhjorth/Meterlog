//
//  CarManager.swift
//  MeterLog
//
//  Created by Frederik Hjorth on 19/02/2021.
//

import Foundation
import Firebase

class CarManager: ObservableObject {
    
    @Published
    var cars = [Car]()
    
    func initForReal() {
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        
        CarManager.getCars(database: db) { (cars) in
            print(cars)
            
            self.cars = cars
        }
    }
    
    func initForTest() {
        cars = [Car.carForTest]
    }
    
    static var carManagerForReal: CarManager = {
        let carManager = CarManager()
        carManager.initForReal()
        return carManager
    }()
    
    static var carManagerForTest: CarManager = {
        let carManager = CarManager()
        carManager.initForTest()
        return carManager
    }()
}
