//
//  SectionView.swift
//

import SwiftUI

struct SectionView<Content: View>: View {
    private let title: String
    private let content: () -> Content
    
    @EnvironmentObject private var style: UIStyle
    
    init(
        title: String,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: 5) {
            headerView
            content()
        }
        .padding(.bottom, style.padding)
        .background(RoundedRectangle(cornerRadius: style.radius).fill(style.backgroundColor))
        .contentShape(RoundedRectangle(cornerRadius: style.radius))
    }
    
    private var headerView: some View {
        ZStack {
            dividerView
            titleView
        }
        .padding(.horizontal, style.padding)
    }
    
    private var titleView: some View {
        Text(title)
            .font(style.titleFont)
            .foregroundColor(style.titleColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(style.backgroundColor)
    }
    
    private var dividerView: some View {
        Divider().background(style.dividerColor)
            .padding(.horizontal, 5)
    }
}
