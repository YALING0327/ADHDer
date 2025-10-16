//
//  Binding-Extensions.swift
//  Adhder
//
//  Created by Phillip Thelen on 25.10.21.
//  Copyright © 2021 AdhderApp Inc. All rights reserved.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}
