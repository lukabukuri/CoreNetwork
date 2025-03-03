//
//  CopyButton.swift
//

import SwiftUI

struct CopyButton: View {
    private let valueDescription: String
    private let copyValue: String?
    
    init(valueDescription: String, copyValue: String?) {
        self.valueDescription = valueDescription
        self.copyValue = copyValue
    }
    
    var body: some View {
        Button("Copy " + valueDescription) {
            UIPasteboard.general.string = copyValue ?? (valueDescription + "missing")
        }
    }
}
