//
//  UIStyle.swift
//

import SwiftUI

final class UIStyle: ObservableObject {
    let titleFont: Font
    let titleColor: Color
    let smallTitleFont: Font
    let valueFont: Font
    let smallValueFont: Font
    let valueColor: Color
    let codeFontSize: CGFloat
    let backgroundColor: Color
    let outlineColor: Color
    let dividerColor: Color
    let radius: CGFloat
    let padding: CGFloat
    let smallPadding: CGFloat
    let defaultValue: String
    let expandedContentHeight: CGFloat
    let inputStepHeight: CGFloat
    
    init(
        titleFont: Font,
        titleColor: Color,
        smallTitleFont: Font,
        valueFont: Font,
        smallValueFont: Font,
        valueColor: Color,
        codeFontSize: CGFloat,
        backgroundColor: Color,
        outlineColor: Color,
        dividerColor: Color,
        radius: CGFloat,
        padding: CGFloat,
        smallPadding: CGFloat,
        defaultValue: String,
        expandedContentHeight: CGFloat,
        inputStepHeight: CGFloat
    ) {
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.smallTitleFont = smallTitleFont
        self.valueFont = valueFont
        self.smallValueFont = smallValueFont
        self.valueColor = valueColor
        self.codeFontSize = codeFontSize
        self.backgroundColor = backgroundColor
        self.outlineColor = outlineColor
        self.dividerColor = dividerColor
        self.radius = radius
        self.padding = padding
        self.smallPadding = smallPadding
        self.defaultValue = defaultValue
        self.expandedContentHeight = expandedContentHeight
        self.inputStepHeight = inputStepHeight
    }
}

extension UIStyle {
    static let defaultStyle = UIStyle(
        titleFont: .system(size: 14, weight: .semibold, design: .default),
        titleColor: .black,
        smallTitleFont: .system(size: 14, weight: .semibold, design: .default),
        valueFont: .system(size: 14),
        smallValueFont: .system(size: 14),
        valueColor: .init(red: 0.2, green: 0.2, blue: 0.2),
        codeFontSize: 16,
        backgroundColor: .init(red: 0.94, green: 0.94, blue: 0.94),
        outlineColor: .init(red: 0.84, green: 0.84, blue: 0.84),
        dividerColor: .gray,
        radius: 16,
        padding: 13,
        smallPadding: 10,
        defaultValue: "N/A",
        expandedContentHeight: 300,
        inputStepHeight: 100
    )
}
