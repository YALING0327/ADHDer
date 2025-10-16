//
//  AdhderProgressIndicator.swift
//  Adhder
//
//  Created by Phillip Thelen on 30.06.23.
//  Copyright © 2023 AdhderApp Inc. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftUIX

struct AdhderProgressStyle: ProgressViewStyle {
    @State private var isRotating = false
    var indeterminateScale = 1.0

    var strokeWidth: CGFloat = 8
    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 1

        return ZStack {
            let gradient = AngularGradient(
                gradient: Gradient(colors: [
                                            Color(UIColor.purple400),
                                            Color(UIColor.red100),
                                            Color(UIColor.orange100),
                                            Color(UIColor.yellow100),
                                            Color(UIColor.green100),
                                            Color(UIColor.blue100),
                                            Color(UIColor.purple400)]),
                center: .center,
                startAngle: .degrees(0),
                endAngle: .degrees(360))
            let isIndeterminate = configuration.fractionCompleted == nil
            if isIndeterminate {
                Circle()
                    .stroke(gradient, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                    .rotationEffect(.degrees(isRotating ? 1080 : 0))
                    .animation(.timingCurve(0.3, 0.0, 0.2, 1.0, duration: 4).repeatForever(autoreverses: false), value: isRotating)
                    .rotationEffect(.degrees(-90))
                    .animation(.interpolatingSpring(stiffness: 120, damping: 20).speed(5), value: isRotating)
                    .scaleEffect(isRotating ? indeterminateScale : 1.0)
                    .onAppear {
                        withAnimation {
                            isRotating = true
                        }
                    }.onDisappear {
                        isRotating = false
                    }
            } else {
                Circle()
                    .trim(from: 0, to: fractionCompleted)
                    .stroke(gradient, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))
            }

        }
    }
}

extension ProgressViewStyle where Self == AdhderProgressStyle {
    static var adhder: AdhderProgressStyle { .init() }
}

extension View {
    func adhderProgressStyle(strokeWidth: CGFloat = 8) -> some View {
        return self.progressViewStyle(AdhderProgressStyle(strokeWidth: strokeWidth))
    }
}

struct AdhderProgressView: View {
    var body: some View {
        ProgressView().adhderProgressStyle().frame(width: 44, height: 44, alignment: .center)
    }
}

struct RefreshControlWrapper: View {
    @ObservedObject var refreshState: RefreshState
    
    var body: some View {
        ProgressView(value: refreshState.fraction).progressViewStyle(AdhderProgressStyle(indeterminateScale: 1.1)).padding(6)
    }
}

class RefreshState: ObservableObject {
    @Published var fraction: CGFloat? = 0.01
    var hasRefreshed = false
}

class AdhderRefresControl: UIRefreshControl {
    private let refreshState = RefreshState()
    override func didMoveToWindow() {
        super.didMoveToWindow()
        backgroundColor = .clear
        tintColor = .clear
        if subviews.count == 1 {
            let view = UIHostingView(rootView: RefreshControlWrapper(refreshState: refreshState).frame(width: 44, height: 44, alignment: .top))
            addSubview(view)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        subviews.last?.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 44)
        let estimatedRefreshHeight = (superview?.bounds.height ?? 1) * 0.19
        if isRefreshing || refreshState.hasRefreshed {
            refreshState.fraction = nil
        } else {
            refreshState.fraction = min(1, bounds.height / estimatedRefreshHeight)
        }
        if bounds.height < 40 {
            subviews.last?.alpha = bounds.height / 40
        } else {
            subviews.last?.alpha = 1
        }
        if bounds.height < 2 {
            refreshState.hasRefreshed = false
        }
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        refreshState.hasRefreshed = true
    }
}

class AdhderActivityIndicator: UIHostingView<AdhderProgressView> {
    required init() {
        super.init(rootView: AdhderProgressView())
    }
    
    required init?(coder: NSCoder) {
        super.init(rootView: AdhderProgressView())
    }
    
    required init(rootView: AdhderProgressView) {
        fatalError("init(rootView:) has not been implemented")
    }
}

struct AdhderProgressStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            ProgressView().progressViewStyle(AdhderProgressStyle())
            ProgressView(value: 0.4).progressViewStyle(AdhderProgressStyle())
            ProgressView().progressViewStyle(AdhderProgressStyle()).frame(width: 40, height: 40)
            ProgressView().progressViewStyle(AdhderProgressStyle(strokeWidth: 20))
        }.frame(width: 200)
    }
}
