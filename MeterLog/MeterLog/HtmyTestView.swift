//
//  HtmyTestView.swift
//  MeterLog
//
//  Created by Henrik Top Mygind on 20/02/2021.
//

import SwiftUI

struct HtmyTestView: View {
    
    @State
    private var text1 = "Test 1"
    
    @State
    private var text2 = "Test 2"
    
    @State
    private var text3 = "Test 3"
    
    @State
    private var selection: Int?
    
    var body: some View {
        VStack{
            AwesomeInput(text: $text1, selection: $selection, tag: 1)
            AwesomeInput(text: $text2, selection: $selection, tag: 2)
            AwesomeInput(text: $text3, selection: $selection, tag: 3)
            
            
            Text("Selected: \(selection ?? 0)")
            Text(selection == 1 ? text1 : selection == 2 ? text2 : selection == 3 ? text3 : "nothing")
            HStack {
                Button(action: {
                    selection = 1
                }, label: {
                    Text("Select 1")
                })
                Button(action: {
                    selection = 2
                }, label: {
                    Text("Select 2")
                })
                Button(action: {
                    selection = 3
                }, label: {
                    Text("Select 3")
                })
            }
        }
    }
}

struct HtmyTestView_Previews: PreviewProvider {
    static var previews: some View {
        HtmyTestView()
    }
}
