//
//  TypingLabel.swift
//  Adhder
//
//  Created by Phillip Thelen on 07.03.22.
//  Copyright © 2022 AdhderApp Inc. All rights reserved.
//

import UIKit

class TypingLabel: UITextView {
    
    var typingSpeed = 0.03
    var finishedAction: (() -> Void)?
    
    private var mutableText: NSMutableAttributedString?
    private var index = 0
    private var timer: Timer?
    
    override var text: String! {
        get {
            return super.text
        }
        set(value) {
            mutableText = NSMutableAttributedString(string: value, attributes: [
                .foregroundColor: UIColor.clear,
                .font: UIFont.preferredFont(forTextStyle: .subheadline)
            ])
            attributedText = mutableText
            startAnimating()
        }
    }
    
    func startAnimating() {
        index = 0
        mutableText = NSMutableAttributedString(string: text, attributes: [
            .foregroundColor: UIColor.clear,
            .font: UIFont.preferredFont(forTextStyle: .subheadline)
        ])
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) {[weak self] _ in
                self?.updateText()
            }
        }
    }
    
    private func updateText() {
        index += 1
        if index > attributedText.length {
            timer?.invalidate()
            timer = nil
            finishedAction?()
        } else {
            mutableText?.addAttribute(.foregroundColor, value: ThemeService.shared.theme.primaryTextColor, range: NSRange(location: 0, length: index))
            attributedText = mutableText
        }
    }
}
