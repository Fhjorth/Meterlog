//
//  AwesomeInput.swift
//  MeterLog
//
//  Created by Henrik Top Mygind on 20/02/2021.
//

import SwiftUI

struct AwesomeInput: UIViewRepresentable {
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        @Binding var selection: Int?
        var tag: Int
        
        init(text: Binding<String>, selection: Binding<Int?>, tag: Int){
            _text = text
            _selection = selection
            self.tag = tag
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            let newText = textField.text ?? ""
            if text != newText {
                text = newText
            }
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async { [weak self] in
                guard let sSelf = self else { return }
                if sSelf.selection != sSelf.tag {
                    sSelf.selection = sSelf.tag
                }
            }
        }
    }
    
    @Binding var text: String
    
    @Binding var selection: Int?
    
    var tag: Int
    
    func makeUIView(context: UIViewRepresentableContext<AwesomeInput>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        return textField
    }
    
    func makeCoordinator() -> AwesomeInput.Coordinator {
        return Coordinator(text: $text, selection: $selection, tag: tag)
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<AwesomeInput>) {
        uiView.text = text
        
        if selection == tag && uiView.isEditing == false{
            uiView.becomeFirstResponder()
        }
    }

}

struct AwesomeInput_Previews: PreviewProvider {
    
    @State
    static var text = "Testing"
    
    static var previews: some View {
        AwesomeInput(text: $text, selection: .constant(2), tag: 2)
    }
}
