//
//  LoadingButton.swift
//  Adhder
//
//  Created by Phillip Thelen on 25.05.23.
//  Copyright © 2023 AdhderApp Inc. All rights reserved.
//

import SwiftUI

enum LoadingButtonState: Hashable {
    case content
    case disabled
    case loading
    case failed
    case success
}

enum LoadingButtonType {
    case normal
    case destructive
}

struct LoadingButton<Content: View, SuccessContent: View, ErrorContent: View>: View {
    @Binding var state: LoadingButtonState
    var type: LoadingButtonType = .normal
    let onTap: () -> Void
    let content: Content
    var successContent: SuccessContent
    var errorContent: ErrorContent
    var contentPadding: EdgeInsets = .zero
    
    private func getBackgroundColor() -> UIColor {
        let theme = ThemeService.shared.theme
        if type == .destructive {
            return theme.errorColor
        }
        switch state {
        case .content, .loading:
            return theme.fixedTintColor
        case .disabled:
            return theme.dimmedColor
        case .failed:
            return theme.errorColor
        case .success:
            return theme.successColor
        }
    }
    
    @ViewBuilder
    private func getContent() -> some View {
        if state == .loading {
            ProgressView().adhderProgressStyle(strokeWidth: 6).frame(width: 24, height: 24).overlay(ZStack {
                Circle().stroke().foregroundColor(.white).frame(width: 17, height: 17)
                Circle().stroke().foregroundColor(.white).frame(width: 29, height: 29)
            })
        } else if state == .failed {
            if errorContent is EmptyView {
                Text(L10n.failed)
            } else {
                errorContent
            }
        } else if state == .success {
            if successContent is EmptyView {
                content
            } else {
                successContent
            }
        } else {
            content
        }
    }
    
    var body: some View {
        AdhderButtonUI(label: getContent(), color: Color(getBackgroundColor()), size: .compact, type: (state == .failed || state == .success) ? .bordered : .solid, onTap: onTap)
    }
}

extension LoadingButton where SuccessContent == EmptyView {
    init(state: Binding<LoadingButtonState>, onTap: @escaping () -> Void, content: Content, errorContent: ErrorContent) {
        self.init(state: state, onTap: onTap, content: content, successContent: EmptyView(), errorContent: errorContent)
    }
}

extension LoadingButton where SuccessContent == EmptyView, ErrorContent == EmptyView {
    init(state: Binding<LoadingButtonState>, onTap: @escaping () -> Void, content: Content) {
        self.init(state: state, onTap: onTap, content: content, successContent: EmptyView(), errorContent: EmptyView())
    }
}

extension LoadingButton where ErrorContent == EmptyView {
    init(state: Binding<LoadingButtonState>, onTap: @escaping () -> Void, content: Content, successContent: SuccessContent) {
        self.init(state: state, onTap: onTap, content: content, successContent: successContent, errorContent: EmptyView())
    }
}

struct LoadingButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 8) {
            LoadingButton(state: .constant(.content), onTap: {}, content: Text("Content"))
            LoadingButton(state: .constant(.disabled), onTap: {}, content: Text("Disabled"))
            LoadingButton(state: .constant(.loading), onTap: {}, content: Text("Loading"))
            LoadingButton(state: .constant(.failed), onTap: {}, content: Text("Failed"))
            LoadingButton(state: .constant(.success), onTap: {}, content: Text("Success"))
            LoadingButton(state: .constant(.success), onTap: {}, content: Text("User was invited"))
        }
        .padding(8)
        .previewLayout(.sizeThatFits)
    }
}
