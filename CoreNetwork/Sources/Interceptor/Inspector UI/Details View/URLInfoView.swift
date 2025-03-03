//
//  URLInfoView.swift
//

import SwiftUI

struct URLInfoView: View {
    private let url: URL?
    
    @State private var isQuertyExpanded = false
    @EnvironmentObject private var style: UIStyle
    
    private var base: String { (components?.scheme ?? "") + "://" + (components?.host ?? "") }
    private var path: String { components?.path ?? style.defaultValue }
    private var query: String { components?.query ?? "No query parameters" }
    private var expandedQuery: String { query.replacingOccurrences(of: "&", with: "\n") }
    private var components: URLComponents? {
        guard let url else { return nil }
        return URLComponents(url: url, resolvingAgainstBaseURL: false)
    }
    
    init(url: URL?) {
        self.url = url
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            baseItem
            dividerView
            pathItem
            dividerView
            queryItem
        }
        .padding(style.padding)
        .background(RoundedRectangle(cornerRadius: style.radius).fill(style.backgroundColor))
        .contentShape(RoundedRectangle(cornerRadius: style.radius))
        .contextMenu { copyActions }
    }
    
    @ViewBuilder
    private var copyActions: some View {
        CopyButton(valueDescription: "full URL", copyValue: url?.absoluteString)
        CopyButton(valueDescription: "base", copyValue: base)
        CopyButton(valueDescription: "path", copyValue: path)
        CopyButton(valueDescription: "query", copyValue: query)
    }
    
    private var baseItem: some View {
        item(title: "Base", value: base)
    }
    
    private var pathItem: some View {
        item(title: "Path", value: path)
    }
    
    private var queryItem: some View {
        let value = isQuertyExpanded ? expandedQuery : query

        return item(title: "Query", value: value)
            .onTapGesture { isQuertyExpanded.toggle() }
    }
    
    @ViewBuilder
    private func item(title: String, value: String) -> some View {
        Text(title)
            .font(style.titleFont)
            .foregroundColor(style.titleColor)
        Text(value)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(style.valueFont)
            .foregroundColor(style.valueColor)
            .contentShape(Rectangle())
    }
    
    private var dividerView: some View {
        Divider().background(style.dividerColor)
    }
}
