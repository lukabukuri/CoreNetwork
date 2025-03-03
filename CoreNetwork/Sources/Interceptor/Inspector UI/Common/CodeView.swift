//
//  CodeView.swift
//

import SwiftUI
import CodeViewer
import CodeEditor

struct CodeView: View {
    private let title: String
    private let json: String

    @EnvironmentObject private var style: UIStyle
    
    init(title: String, json: String) {
        self.title = title
        self.json = json
    }
    
    var body: some View {
        ExpandableView(value: json, title: title) { json in
            CodeViewer(
                content: .constant(json),
                mode: .json,
                darkTheme: .cobalt,
                isReadOnly: true,
                fontSize: 24,
                textDidChanged: nil
            )
//            CodeEditor(
//                source: json,
//                language: .json,
//                theme: .atelierSavannaDark,
//                fontSize: .constant(style.codeFontSize),
//                flags: .defaultViewerFlags
//            )
            .clipShape(RoundedRectangle(cornerRadius: style.radius))
        }
    }
}
