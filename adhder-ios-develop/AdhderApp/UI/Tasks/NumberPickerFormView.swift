//
//  NumberPickerFormView.swift
//  Adhder
//
//  Created by Phillip Thelen on 02.11.21.
//  Copyright © 2021 AdhderApp Inc. All rights reserved.
//

import SwiftUI

struct NumberPickerFormView<TitleView: View>: View {
    let title: TitleView
    @Binding var value: Int
    var minValue: Int
    var maxValue: Int
    var formatter: ((Int) -> String)?

    @State private var isOpen = false

    private var valueText: String {
        if let formatter = formatter {
            return formatter(value)
        }
        return String(value)
    }
    
    var body: some View {
        VStack {
            FormRow(title: title, valueLabel: Text(valueText)) {
                withAnimation {
                    isOpen.toggle()
                }
            }
            if isOpen {
                Picker(selection: $value) {
                    ForEach((minValue...maxValue), id: \.self) { current in
                        Text(String(current))
                    }
                } label: {
                    
                }.pickerStyle(.wheel)
            }
        }
    }
}
