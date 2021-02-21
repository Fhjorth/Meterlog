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
    
    private var subscription: ListenerRegistration?
    
    func initForReal() {
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        
        Auth.auth().signIn { (user) in
            self.user = user
            
//            guard let user = user else { return }
//            db.getCars(for: user) { cars in
//                self.cars = cars
//            }
            
            self.subscription = self.subscribe(database: db)
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
