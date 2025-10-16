//
//  G1G1Banner.swift
//  Adhder
//
//  Created by Phillip Thelen on 11.09.24.
//  Copyright © 2024 AdhderApp Inc. All rights reserved.
//

import Foundation
import SwiftUI

struct G1G1Banner: View {
    var endDate: Date
    
    private let formatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    var body: some View {
        ZStack(alignment: .center) {
            HStack {
                Image(Asset.promoGiftsLeft.name)
                Spacer()
                Image(Asset.promoGiftsRight.name)
            }
            .background(LinearGradient(colors: [Color(UIColor("#3BCAD7")), Color(UIColor("#925CF3"))], startPoint: .topLeading, endPoint: .bottomTrailing))
            VStack(spacing: 5) {
                Text(L10n.giftOneGetOneTitle)
                    .font(.system(size: 22, weight: .bold))
                Text(L10n.giftOneGetOneDescriptionDate(formatter.string(from: endDate)))
                    .font(.system(size: 16, weight: .semibold))
                    .lineSpacing(2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 50)
            }
        }
        .onTapGesture {
            RouterHandler.shared.handle(.promoInfo)
        }
    }
}

#Preview {
    G1G1Banner(endDate: Date())
}
