//
//  ExpandableView.swift
//

import SwiftUI

struct ExpandableView<Content: View>: View {
    private let value: String
    private let title: String
    private let content: (String) -> Content
    @State private var isExpanded: Bool
    @State private var userHeightInput: CGFloat = 0
    private var showHeightControls: Bool

    @EnvironmentObject private var style: UIStyle
    
    private var totalContentHeight: CGFloat { style.expandedContentHeight + userHeightInput }
    private var shortenedValue: String {
        let cleanedString = value.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
        return String(cleanedString.prefix(90))
    }
    
    init(
        value: String,
        title: String,
        isExpanded: Bool = false,
        showHeightControls: Bool = true,
        content: @escaping (String) -> Content
    ) {
        self.value = value
        self.title = title
        self.content = content
        self.isExpanded = isExpanded
        self.showHeightControls = showHeightControls
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            titleView
                .padding(.horizontal, style.padding)
            content(value)
                .frame(height: isExpanded ? totalContentHeight : 0, alignment: .top)
                .clipped()
        }
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: style.radius).fill(style.backgroundColor))
        .overlay {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    heightControlButtons
                        .opacity(isExpanded ? 1 : 0)
                        .allowsTightening(isExpanded)
                }
            }
        }
    }
    
    private var titleView: some View {
        let title = Text(title + "  ")
            .font(style.titleFont)
            .foregroundColor(style.titleColor)
        let valuePreview = Text(isExpanded ? "" : shortenedValue)
            .font(style.valueFont)
            .foregroundColor(style.valueColor)
        
        return (title + valuePreview)
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
            .lineLimit(1)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
    }
    
    @ViewBuilder
    private var heightControlButtons: some View {
        HStack(spacing: 5) {
            footerButton(icon: "arrow.up") {
                isExpanded.toggle()
            }
            footerButton(icon: "minus") {
                userHeightInput -= style.inputStepHeight
            }
            .disabled(totalContentHeight < style.inputStepHeight)
            footerButton(icon: "plus") {
                userHeightInput += style.inputStepHeight
            }
        }
        .padding(5)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: style.radius))
        .contentShape(RoundedRectangle(cornerRadius: style.radius))
        .padding(7)
    }
    
    private func footerButton(icon: String, action: (() -> Void)?) -> some View {
        Button {
            withAnimation {
                action?()
            }
        } label: {
            Image(systemName: icon)
        }
        .frame(width: 16, height: 16)
    }
}
