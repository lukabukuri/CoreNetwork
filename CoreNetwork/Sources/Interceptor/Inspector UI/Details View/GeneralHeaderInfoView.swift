//
//  GeneralHeaderInfoView.swift
//

import SwiftUI

struct GeneralHeaderInfoView: View {
    private let method: String?
    private let status: String?
    private let timeout: String?
    private let startTime: String?
    private let endTime: String?
    
    @EnvironmentObject private var style: UIStyle
    
    private var timeStamp: String {
        return (startTime ?? style.defaultValue) + "-" + (endTime ?? style.defaultValue)
    }
    
    init(
        method: String?,
        status: String?,
        timeout: String?,
        startTime: String?,
        endTime: String?
    ) {
        self.method = method
        self.status = status
        self.timeout = timeout
        self.startTime = startTime
        self.endTime = endTime
    }
    
    var body: some View {
        HStack {
            itemView(title: "Method", value: method)
            spacer
            itemView(title: "Status", value: status)
            spacer
            itemView(title: "Timeout", value: timeout)
            spacer
            itemView(title: "Time Stamp", value: timeStamp)
        }
    }
    
    @ViewBuilder
    private func itemView(title: String, value: String?) -> some View {
        let titleText = Text(title + "\n")
            .font(style.titleFont)
            .foregroundColor(style.titleColor)

        let valueText = Text(value ?? style.defaultValue)
            .font(style.smallValueFont)
            .foregroundColor(style.valueColor)
        
        (titleText + valueText)
            .frame(alignment: .center)
            .multilineTextAlignment(.center)
            .padding(style.padding)
            .background(RoundedRectangle(cornerRadius: style.radius).fill(style.backgroundColor))
            .contentShape(Rectangle())
            .onLongPressGesture {
                UIPasteboard.general.string = value ?? style.defaultValue
            }
    }
    
    private var spacer: some View {
        Spacer(minLength: .zero)
    }
}
