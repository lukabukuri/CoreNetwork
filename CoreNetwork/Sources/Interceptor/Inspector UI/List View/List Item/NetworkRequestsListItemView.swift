//
//  NetworkRequestsListItemView.swift
//

import SwiftUI

struct NetworkRequestsListItemView: View {
    let model: NetworkRequestsListItemModel
    
    var body: some View {
        HStack(spacing: 10) {
            statusView
            infoView
            editButton
        }
        .contentShape(Rectangle())
    }
    
    private var statusView: some View {
        VStack(spacing: 0) {
            Text(model.statusCode)
                .font(.system(size: 12, weight: .bold))
                .monospacedDigit()
            Text(model.timeStamp)
                .font(.system(size: 8, weight: .light))
                .monospacedDigit()
        }
        .padding(10)
        .background(model.statusCodeColor)
        .cornerRadius(10)
    }
    
    private var infoView: some View {
        VStack(spacing: 5) {
            Text(model.title)
                .font(.system(size: 13))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                        
            HStack(alignment: .bottom, spacing: 0) {
                Text(model.method)
                    .font(.system(size: 12, weight: .bold))
                Spacer(minLength: 0)
            }
        }
    }
    
    private var editButton: some View {
        EditButton {
            VStack(spacing: 0) {
                Image(systemName: "square.and.pencil")
                Text("Override")
                    .font(.system(size: 10))
            }
            .padding(10)
        } action: {
            
        }
    }
}
