//
//  NetworkRequestsListItemModel.swift
//

import SwiftUI

struct NetworkRequestsListItemModel: Identifiable {
    var id: UUID
    let data: NetworkTransaction
    
    let statusCode: String
    let statusCodeColor: Color
    let timeStamp: String
    
    let title: String
    let method: String
}

extension NetworkRequestsListItemModel: Equatable, Hashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension NetworkRequestsListItemModel {
    static func from(_ data: NetworkTransaction) -> Self {
        
        let statusCode = (data.combinedResponse?.response as? HTTPURLResponse)?.statusCode ?? -1
        let statusCodeColor: Color = switch statusCode {
        case 200..<300: .green  // Success
        case 400..<500: .red // Client errors
        case 100..<200,
             300..<400,
             500..<600: Color(red: 0.8, green: 0.3, blue: 0.3) // Server errors
        default: .gray // Unknown
        }
        
        let urlPath: String? = data.combinedResponse?.response?.url?.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        
        return Self.init(
            id: data.id,
            data: data,
            statusCode: "\(statusCode)",
            statusCodeColor: statusCodeColor,
            timeStamp: "15:20",
            title: urlPath ?? "Invalid URL",
            method: data.request?.httpMethod ?? "Invalid method"
        )
    }
}
