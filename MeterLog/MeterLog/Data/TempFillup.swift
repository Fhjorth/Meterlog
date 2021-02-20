//
//  TempFillup.swift
//  MeterLog
//
//  Created by Henrik Top Mygind on 20/02/2021.
//

import Foundation


class TempFillup: ObservableObject {
    
    private var id: UUID

    let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM-yyyy HH:mm"
        return formatter
    }()
    
    init(){
        id = UUID()
        date = dateFormatter.string(from: Date())
    }
    
    @Published var date: String
    @Published var odometer: String = ""
    @Published var volume: String = ""
    @Published var price: String = ""
}


//
////    @State private var date = "20/2-2021"
////    @State private var odometer: String = "" //14753"
////    @State private var volume: String = "" //32.12"
////    @State private var price: String = ""// "10.59"
//
//private var date: String {
//    let formatter = DateFormatter()
//    formatter.dateFormat = "dd/MM-yyyy HH:mm"
//    return formatter.string(from: fillup.date)
//}
//
//private func getString(_ number: Float?) -> String {
//    guard let number = number else {
//        return ""
//    }
//    
//    return "\(number)"
//}
//
//private func getString(_ number: Int?) -> String {
//    guard let number = number else {
//        return ""
//    }
//    
//    return "\(number)"
//}
//
//private var odometer: String { getString(fillup.odometer) }
//private var volume: String { getString(fillup.volume) }
//private var price: String { getString(fillup.literPrice) }
