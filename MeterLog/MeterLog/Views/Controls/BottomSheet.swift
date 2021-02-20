//
//  BottomSheet.swift
//  MeterLog
//
//  Created by Henrik Top Mygind on 20/02/2021.
//

import SwiftUI

// Heavily inspired by
// https://stackoverflow.com/a/59652231
struct BottomSheet<SheetContent: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    let sheetContent: () -> SheetContent
    
    func body(content: Content) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
            
            content
            
            if isPresented {
                Rectangle()
                    .fill(Color.black.opacity(0.2))
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            isPresented = false
                        }
                    }
            }
            
            if isPresented {
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        Spacer()
                        
                        VStack(spacing: 0) {
                            Spacer().frame(height: 16)
                            sheetContent()
                        }
                        .background(Color.white)
                        .cornerRadius(16, corners: .topLeft)
                        .cornerRadius(16, corners: .topRight)
                    }
                    .frame(width: geometry.size.width)
                }
                .transition(.move(edge: .bottom))
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

extension View {
    func customBottomSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        sheetContent: @escaping () -> SheetContent
    ) -> some View {
        self.modifier(BottomSheet(isPresented: isPresented, sheetContent: sheetContent))
    }
}

struct BottomSheet_Previews: PreviewProvider {
    
    @State private static var isPresented = true
    
    static var previews: some View {
        NavigationView {
            Rectangle()
                .fill(Color.red)
                .customBottomSheet(isPresented: $isPresented) {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(height: 300)
            }
        }
        
//        BottomSheet()
    }
}

//struct BottomSheet<SheetContent: View>: ViewModifier {
//@Binding var isPresented: Bool
//let sheetContent: () -> SheetContent
//
//func body(content: Content) -> some View {
//    ZStack {
//        content
//
//        if isPresented {
//            VStack {
//                Spacer()
//
//                VStack {
//                    HStack {
//                        Spacer()
//                        Button(action: {
//                            withAnimation(.easeInOut) {
//                                self.isPresented = false
//                            }
//                        }) {
//                            Text("done")
//                                .padding(.top, 5)
//                        }
//                    }
//
//                    sheetContent()
//                }
//                .padding()
//            }
//            .zIndex(.infinity)
//            .transition(.move(edge: .bottom))
//            .edgesIgnoringSafeArea(.bottom)
//        }
//    }
//}
