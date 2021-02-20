//
//  CarManager.swift
//  MeterLog
//
//  Created by Frederik Hjorth on 19/02/2021.
//

import Foundation
import Firebase

// TODO MOve to model/separate files?!
struct Fillup: Identifiable {
    var id: UUID
    var date: Date
    var odometer: Int
    var volume: Float
    var literPrice: Float
    
    static func createFrom(date: Date, odometer: Int, volume: Float, price: Float, id: UUID? = nil) -> Fillup {
        let id = id ?? UUID()
        
        return Fillup(id: id, date: date, odometer: odometer, volume: volume, literPrice: price)
    }
}

class Car: ObservableObject, Identifiable {
    var id: UUID
    var name: String = ""
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
        
    }
    
    @Published
    var fillups = [Fillup]() {
        didSet {
            odometers = fillups.map { f in
                Double(f.odometer)
            }
        }
    }
    @Published
    var odometers = [Double]()
    
    func addNewFillup(_ fillup: Fillup){
        fillups.append(fillup)

        // TODO store in cloud
    }
    
    func updateFillup(_ fillup: Fillup){
        guard let index = fillups.firstIndex(where: { f in f.id == fillup.id }) else {
            
            print(fillup.id)
            print("======")
            print(fillups.map { f in "\(f.id)"}.joined(separator: "\n"))
            
            return
        }
        
        objectWillChange.send()
        
        fillups.remove(at: index)
        fillups.insert(fillup, at: index)
        
        objectWillChange.send()
        
        // TODO update in cloud
    }
    
    static var carForTest: Car = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM-yyyy"
        
        let testCar = Car(id: UUID(), name: "VW Up!")
        testCar.fillups.append(contentsOf: [
            Fillup(id: UUID(), date: formatter.date(from: "17/01-2021")!, odometer: 12500, volume: 32.1, literPrice: 10.59),
            Fillup(id: UUID(), date: formatter.date(from: "24/01-2021")!, odometer: 12760, volume: 14.6, literPrice: 10.14),
            Fillup(id: UUID(), date: formatter.date(from: "17/01-2021")!, odometer: 13005, volume: 12.2, literPrice: 10.32),
            Fillup(id: UUID(), date: formatter.date(from: "17/01-2021")!, odometer: 13666, volume: 22.1, literPrice: 11.02),
            Fillup(id: UUID(), date: formatter.date(from: "17/01-2021")!, odometer: 13989, volume: 54.6, literPrice: 9.59),
            Fillup(id: UUID(), date: formatter.date(from: "17/01-2021")!, odometer: 14444, volume: 7.6, literPrice: 10.08),
        ])
        return testCar
    }()
}

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
    
    private static func getCars(database: Firestore, completion: @escaping ([Car]) -> ()) {
        database.collection("cars").getDocuments { (carsSnap, carsErr) in
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
                
                CarManager.getFillups(database: database, id: id.uuidString){ fillups in
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
    
    private static func getFillups(database: Firestore, id: String, completion: @escaping ([Fillup]) -> ()) {
        database.collection("cars/\(id)/Fillups").getDocuments { (fillupSnap, fillupErr) in
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
