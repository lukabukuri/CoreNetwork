//
//  TransactionDetailsView.swift
//

import SwiftUI

// MARK: - TransactionDetails View
struct TransactionDetailsView: View {
    // MARK: Private Properties
    private let transaction: NetworkRequestsListItemModel
    
    private var urlRequest: URLRequest? { transaction.data.request }
    private var urlResponse: URLResponse? { transaction.data.combinedResponse?.response }
    
    @EnvironmentObject private var style: UIStyle
    
    // MARK: Initializer
    init(transaction: NetworkRequestsListItemModel) {
        self.transaction = transaction
    }
    
    // MARK: Body
    var body: some View {
        ZStack {
            backgroundView
            contentView
        }
        .navigationTitle("Transaction")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                overrideButton
            }
        }
    }
    
    // MARK: Views
    private var backgroundView: some View {
        Color.white.ignoresSafeArea()
    }
    
    private var contentView: some View {
        ScrollView {
            headerChipItemViews
            URLInfoView(url: urlRequest?.url)
            requestSection
            responseSection
        }
        .scrollViewPadding(.horizontal, length: 20)
    }
    
    private var headerChipItemViews: some View {
        GeneralHeaderInfoView(
            method: urlRequest?.httpMethod,
            status: transaction.statusCode,
            timeout: urlRequest?.timeoutInterval.debugDescription ,
            startTime: "15:22:11",
            endTime: "15:23:01"
        )
    }
    
    private var requestSection: some View {
        let headerJSON = json(from: urlRequest?.allHTTPHeaderFields) ?? style.defaultValue
        let bodyJSON = json(from: urlRequest?.httpBody) ?? style.defaultValue
        
        return SectionView(title: "Request") {
            CodeView(title: "Headers:", json: headerJSON)
            CodeView(title: "Body:", json: bodyJSON)
        }
        .contextMenu {
            CopyButton(valueDescription: "headers", copyValue: headerJSON)
            CopyButton(valueDescription: "body", copyValue: bodyJSON)
        }
    }
    
    private var responseSection: some View {
        let headerDict = (urlResponse as? HTTPURLResponse)?.allHeaderFields as? [String: String]
        let headerJSON = json(from: headerDict) ?? style.defaultValue
        let bodyJSON = json(from: transaction.data.combinedResponse?.data) ?? style.defaultValue
        
        return SectionView(title: "Response") {
            CodeView(title: "Headers:", json: headerJSON)
            CodeView(title: "Body:", json: bodyJSON)
        }
        .contextMenu {
            CopyButton(valueDescription: "headers", copyValue: headerJSON)
            CopyButton(valueDescription: "body", copyValue: bodyJSON)
        }
    }
    
    private var overrideButton: some View {
        VStack(spacing: 0) {
            Image(systemName: "square.and.pencil")
            Text("Override")
                .font(.system(size: 10))
        }
    }
    
    // MARK: - Helper methods
    private func json(from dictionary: [String: String]?) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let dictionary,
              let jsonData = try? encoder.encode(dictionary),
              let jsonString = String(data: jsonData, encoding: .utf8)
        else { return nil }
        return jsonString
    }
    
    private func json(from jsonData: Data?) -> String? {
        guard let jsonData, let jsonString = String(data: jsonData, encoding: .utf8)
        else { return nil }
        return jsonString
    }
}

fileprivate extension ScrollView {
    @ViewBuilder
    func scrollViewPadding(_ edges: Edge.Set, length: CGFloat) -> some View {
        if #available(iOS 17.0, *) {
            self.safeAreaPadding(edges, length)
        } else {
            self.padding(edges, length)
        }
    }
}
