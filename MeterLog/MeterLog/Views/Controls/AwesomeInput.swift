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
        let tag: Int
        let validator: (String) -> String
        
        init(
            text: Binding<String>,
            selection: Binding<Int?>,
            tag: Int,
            validator: @escaping (String) -> String){
            _text = text
            _selection = selection
            self.tag = tag
            self.validator = validator
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            let newText = validator(textField.text ?? "")
            textField.text = newText
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
    var validator: (String) -> String = { text in text }
    var returnKeyType: UIReturnKeyType = .default
    
    var nextText: String?
    var nextAction: () -> () = { }
    
    func makeUIView(context: UIViewRepresentableContext<AwesomeInput>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.setContentCompressionResistancePriority(.required, for: .vertical)
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.delegate = context.coordinator
        
        textField.keyboardType = .decimalPad
        textField.returnKeyType = returnKeyType
        
        let accessoryCtrl = UIHostingController(rootView: createToolbar())
        accessoryCtrl.view.sizeToFit()
        textField.inputAccessoryView = accessoryCtrl.view
        
        return textField
    }
    
    func makeCoordinator() -> AwesomeInput.Coordinator {
        return Coordinator(text: $text, selection: $selection, tag: tag, validator: validator)
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<AwesomeInput>) {
        uiView.text = text
        
        if selection == tag && uiView.isEditing == false{
            uiView.becomeFirstResponder()
        }
    }
    
    // TODO Move into own view
    private func createToolbar() -> some View {
        guard let text = nextText else {
            return AnyView(EmptyView())
        }
        
        return AnyView(
            VStack(spacing: 0){
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 2)
                    .frame(maxWidth: .infinity)
                HStack {
                    Spacer()
                    Button(action: {
                        nextAction()
                    }){
                        Text(text)
                    }
                    Spacer()
                        .frame(width: 16)
                }
                .frame(maxHeight: .infinity)
            }
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.838, green: 0.845, blue: 0.866, opacity: 1)))
    }
    
    private func doNext() {
        nextAction()
    }
}

struct AwesomeInput_Previews: PreviewProvider {
    
    @State
    static var text = "Testing"
    
    static var previews: some View {
        AwesomeInput(text: $text, selection: .constant(2), tag: 2)
    }
}
