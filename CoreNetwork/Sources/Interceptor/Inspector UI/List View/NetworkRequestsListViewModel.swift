//
//  NetworkRequestsListViewModel.swift
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class NetworkRequestsListViewModel: ObservableObject {
    
    // MARK: - Public Properties
    @Published var items: [NetworkRequestsListItemModel] = []
            
    @Published var searchText = ""
    
    var filteredItems: [NetworkRequestsListItemModel] {
        guard !searchText.isEmpty else { return items }
        return items.filter {
            $0.title.lowercased().contains(searchText.lowercased())
        }
    }
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init() {
        subscribeToTransactionHandler()
    }
    
    // MARK: - Public Methods
    func clearTransactions() {
        items = []
        NetworkTransactionHandler.shared.clearTransactions()
    }
    
    // MARK: - Private Methods
    private func subscribeToTransactionHandler() {
        NetworkTransactionHandler.shared.$transactions
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] transactions in
                guard let self else { return }
                let oldItemCount = items.count
                guard transactions.count > oldItemCount else { return }
                let newItems = transactions[oldItemCount..<transactions.count].reversed().map { NetworkRequestsListItemModel.from($0) }
                
                withAnimation(.spring) {
                    self.items.insert(contentsOf: newItems, at: .zero)
                }
        }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
