//
//  EditButton.swift
//

import SwiftUI

struct EditButton<Label> : View where Label : View {

    @ViewBuilder let label: () -> Label
    let action: (() -> Void)?
    
    var body: some View {
        Button(action: action ?? {}, label: label)
            .buttonStyle(EditButtonStyle())
    }
}
