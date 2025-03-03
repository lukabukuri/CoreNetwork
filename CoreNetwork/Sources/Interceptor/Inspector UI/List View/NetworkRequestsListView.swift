//
//  NetworkRequestsListView.swift
//

import SwiftUI

public struct NetworkRequestsListView: View {

    // MARK: - Private Properties
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: NetworkRequestsListViewModel
    
    @State private var deleteIconAnimation = true
    @State private var closeIconAnimation = true
    @State private var settingsIconAnimation = true
    
    @State private var selectedItem: NetworkRequestsListItemModel?
    
    private let title = "List"
    
    // MARK: - Public Properties
    var dismissAction: (() -> Void)?
    
    // MARK: - Initializer
    public init(dismissAction: (() -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: .init())
        self.dismissAction = dismissAction
    }
    
    public var body: some View {
        contentView
    }
    
    @ViewBuilder
    private var contentView: some View {
        if #available(iOS 17.0, *) {
            navigationStackView
        } else {
            listView
        }
    }
    
    @available(iOS 17.0, *)
    private var navigationStackView: some View {
        NavigationStack {
            listView
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        toolBarTitleView
                    }
                    ToolbarItem(placement: .destructiveAction) {
                        deleteButton
                    }
//                    ToolbarItem(placement: .primaryAction) {
//                        settingsButton
//                    }
                    ToolbarItem(placement: .navigation) {
                        closeButton
                    }
                }
                .searchable(text: $viewModel.searchText)
                .navigationDestination(item: $selectedItem) { item in
                    TransactionDetailsView(transaction: item)
                        .environmentObject(UIStyle.defaultStyle)
                }
        }
    }
    
    private var listView: some View {
        List {
            ForEach(viewModel.filteredItems) { item in
                NetworkRequestsListItemView(model: item)
                    .onTapGesture {
                        selectedItem = item
                    }
            }
        }
        .listStyle(.plain)
    }
    
    private var toolBarTitleView: some View {
        HStack {
            Image(systemName: "sun.min.fill")
            Text(title).font(.headline)
        }
    }
    
    private var deleteButton: some View {
        Button {
            deleteIconAnimation.toggle()
            
            withAnimation {
                viewModel.clearTransactions()
            }
        } label: {
            Image(systemName: "trash")
                .foregroundStyle(Color.black)
                .symbolBounceEffectIfAvailable(on: deleteIconAnimation)
        }
    }
    
    private var settingsButton: some View {
        Button {
            settingsIconAnimation.toggle()
        } label: {
            Image(systemName: "gear")
                .foregroundStyle(Color.black)
                .symbolBounceEffectIfAvailable(on: settingsIconAnimation)
        }
    }
    
    private var closeButton: some View {
        Button {
            closeIconAnimation.toggle()
            dismiss()
            dismissAction?()
        } label: {
            Image(systemName: "xmark")
                .foregroundStyle(Color.black)
                .symbolBounceEffectIfAvailable(on: closeIconAnimation)
        }
    }
}


        
fileprivate extension View {
    @ViewBuilder
    func symbolBounceEffectIfAvailable<T>(on trigger: T) -> some View where T : Equatable {
        if #available(iOS 17.0, *) {
            self.symbolEffect(.bounce.down, value: trigger)
        } else {
            self
        }
    }
}


#Preview {
    NetworkRequestsListView()
}
