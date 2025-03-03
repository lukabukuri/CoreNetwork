//
//  EditButtonStyle.swift
//

import SwiftUI

extension EditButton {
    struct EditButtonStyle: ButtonStyle {
    
        private let bodyShape = RoundedRectangle(cornerRadius: 16)
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .background(
                    bodyShape
                        .fill(bodyColor(configuration.isPressed))
                        .contentShape(bodyShape)
                )
                .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
                .animation(.easeInOut(duration: configuration.isPressed ? 0.1 : 0.2), value: configuration.isPressed)
        }
        
        private func bodyColor(_ isPressed: Bool) -> Color {
            isPressed ? Color(red: 0.9, green: 0.9, blue: 0.9) : Color(red: 0.96, green: 0.96, blue: 0.96)
        }
    }
}
