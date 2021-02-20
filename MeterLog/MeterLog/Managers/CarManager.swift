//
//  CarManager.swift
//  MeterLog
//
//  Created by Frederik Hjorth on 19/02/2021.
//

import Foundation

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
    @Published var name: String = ""
    
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
        // todo load from firebase
    }
    
    func initForTest() {
        cars = [Car.carForTest]
    }
    
    static var carManagerForTest: CarManager = {
        let carManager = CarManager()
        carManager.initForTest()
        return carManager
    }()
}
