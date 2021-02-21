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
    
    func initForReal() {
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        
        db.getCars() { (cars) in
            print(cars)
            
            self.cars = cars
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
}
