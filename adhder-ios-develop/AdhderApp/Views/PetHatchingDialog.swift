//
//  PetHatchingDialog.swift
//  Adhder
//
//  Created by Phillip Thelen on 29.09.20.
//  Copyright © 2020 AdhderApp Inc. All rights reserved.
//

import UIKit
import Adhder_Models
import ReactiveSwift

class PetHatchingAlertController: AdhderAlertController {
    private let inventoryRepository = InventoryRepository()
    private let userRepository = UserRepository()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        return view
    }()
    
    private let imageStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 20
        view.addHeightConstraint(height: 68)
        view.alignment = .center
        view.distribution = .equalCentering
        return view
    }()
    
    private let eggView: NetworkImageView = {
        let view = NetworkImageView()
        view.cornerRadius = 4
        view.contentMode = .center
        view.addSizeConstraint(size: 50)
        view.clipsToBounds = false
        return view
    }()
    private let eggCountView: PillView = {
        let view = PillView(frame: CGRect(x: 34, y: -8, width: 24, height: 24))
        view.isCircular = true
        return view
    }()
    private let potionView: NetworkImageView = {
        let view = NetworkImageView()
        view.addSizeConstraint(size: 50)
        view.cornerRadius = 4
        view.contentMode = .center
        view.clipsToBounds = false
        return view
    }()
    private let potionCountView: PillView = {
        let view = PillView(frame: CGRect(x: 34, y: -8, width: 24, height: 24))
        view.isCircular = true
        return view
    }()
    private let petView: NetworkImageView = {
        let view = NetworkImageView()
        view.addSizeConstraint(size: 68)
        view.cornerRadius = 4
        view.contentMode = .center
        return view
    }()
    
    private let petTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.addHeightConstraint(height: 21)
        return label
    }()
    private let descriptionlabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledSystemFont(ofSize: 14)
        label.numberOfLines = 3
        label.addHeightConstraint(height: 60)
        label.textAlignment = .center
        return label
    }()
    
    private var gemCount = 0
    private var eggCount = 0
    private var potionCount = 0
    
    // swiftlint:disable:next function_body_length
    convenience init(item: PetStableItem, ownedEggs: OwnedItemProtocol?, ownedPotions: OwnedItemProtocol?) {
        self.init()
        eggCount = ownedEggs?.numberOwned ?? 0
        potionCount = ownedPotions?.numberOwned ?? 0
        eggCountView.text = String(eggCount)
        eggCountView.isHidden = eggCount == 0
        potionCountView.text = String(potionCount)
        potionCountView.isHidden = potionCount == 0
        eggView.setImagewith(name: "Pet_Egg_\(item.pet?.egg ?? "")")
        potionView.setImagewith(name: "Pet_HatchingPotion_\(item.pet?.potion ?? "")")
        petTitleLabel.text = item.pet?.text
        userRepository.getUser().take(first: 1).on(value: { user in
            self.gemCount = user.gemCount
        }).start()
        inventoryRepository.getItems(keys: [.eggs: [item.pet?.egg ?? ""], .hatchingPotions: [item.pet?.potion ?? ""]]).take(first: 1).on(value: { items in
            let egg = items.eggs.value.first
            let potion = items.hatchingPotions.value.first
            self.setText(item: item, eggText: egg?.text ?? item.pet?.egg ?? "", potionText: potion?.text ?? item.pet?.potion ?? "")
        }).start()
        setText(item: item, eggText: item.pet?.egg ?? "", potionText: item.pet?.potion ?? "")
        
        if eggCount > 0 && potionCount > 0 {
            addAction(title: L10n.hatch, isMainAction: true) { _ in
                self.inventoryRepository.getItems(keys: [ItemType.eggs: [item.pet?.egg ?? ""], ItemType.hatchingPotions: [item.pet?.potion ?? ""]]).take(first: 1).on(value: { items in
                self.inventoryRepository.hatchPet(egg: ownedEggs?.key, potion: ownedPotions?.key).observeCompleted {
                }
                }).start()
            }
            addCloseAction()
        } else {
            addAction(title: L10n.close, isMainAction: true)
            
            inventoryRepository.getItems(keys: [ItemType.eggs: [item.pet?.egg ?? ""], ItemType.hatchingPotions: [item.pet?.potion ?? ""]]).take(first: 1).on(value: { items in
                let egg = items.eggs.value.first
                let potion = items.hatchingPotions.value.first
                var hatchValue = self.eggCount > 0 ? 0 : Int(egg?.value ?? 0.0)
                hatchValue += self.potionCount > 0 ? 0 : Int(potion?.value ?? 0.0)
                
                if hatchValue > 0 && (item.pet?.type == "drop" || (item.pet?.type == "quest" && ownedEggs != nil)) {
                    let attributedText = NSMutableAttributedString(string: L10n.hatch + "   \(hatchValue) :gems:")
                    let text = attributedText.mutableString
                    let range = text.range(of: ":gems:")
                    if range.length > 0 {
                        let attachment = NSTextAttachment()
                        attachment.image = Asset.gem.image
                        attachment.bounds = CGRect(x: 0, y: 0, width: 16, height: 16)
                        let addedString = NSAttributedString(attachment: attachment)
                        attributedText.replaceCharacters(in: range, with: addedString)
                    }
                    let button = self.addAction(title: L10n.hatch, isMainAction: false) { _ in
                        if hatchValue > self.gemCount {
                            HRPGBuyItemModalViewController.displayInsufficientGemsModal(reason: "hatching", delayDisplay: false)
                            self.dismiss()
                            return
                        }
                        var signal = SignalProducer<UserProtocol?, Never> { (observable, _) in
                            observable.send(Signal.Event.value(nil))
                            observable.sendCompleted()
                        }
                        if self.eggCount == 0 {
                            signal = signal.flatMap(.latest, { _ -> Signal<UserProtocol?, Never> in
                                return self.inventoryRepository.purchaseItem(purchaseType: "eggs", key: item.pet?.egg ?? "", value: 4, quantity: 1, text: (egg?.text ?? "") + " " + L10n.egg)
                            })
                        }
                        if self.potionCount == 0 {
                            signal = signal.flatMap(.latest, { _ -> Signal<UserProtocol?, Never> in
                                return self.inventoryRepository.purchaseItem(purchaseType: "hatchingPotions", key: item.pet?.potion ?? "",
                                                                             value: 4,
                                                                             quantity: 1,
                                                                             text: (potion?.text ?? "") + " " + L10n.hatchingPotion)
                            })
                        }
                        
                        signal.flatMap(.latest, { _ in
                            return self.inventoryRepository.hatchPet(egg: item.pet?.egg, potion: item.pet?.potion)
                        }).start()
                    }
                    button.setAttributedTitle(attributedText, for: .normal)
                }
            }).start()
        }
        
        setupView()
    }
    
    private func setText(item: PetStableItem, eggText: String, potionText: String) {
        if item.canRaise || item.pet?.type == "special" || item.pet?.type == "wacky" {
            title = L10n.hatchPet
            petView.setImagewith(name: "stable_Pet-\(item.pet?.key ?? "")-outline")
            if eggCount == 0 && potionCount == 0 {
                descriptionlabel.text = L10n.suggestPetHatchMissingBoth(eggText, potionText)
            } else if eggCount == 0 {
                descriptionlabel.text = L10n.suggestPetHatchMissingEgg(eggText)
            } else if potionCount == 0 {
                descriptionlabel.text = L10n.suggestPetHatchMissingPotion(potionText)
            } else {
                descriptionlabel.text = L10n.canHatchPet(eggText, potionText)
            }
        } else {
            title = L10n.hatchPetAgain
            petView.setImagewith(name: "stable_Pet-\(item.pet?.key ?? "")")
            petView.alpha = 0.5
            if eggCount == 0 && potionCount == 0 {
                descriptionlabel.text = L10n.suggestPetHatchAgainMissingBoth(eggText, potionText)
            } else if eggCount == 0 {
                descriptionlabel.text = L10n.suggestPetHatchAgainMissingEgg(eggText)
            } else if potionCount == 0 {
                descriptionlabel.text = L10n.suggestPetHatchAgainMissingPotion(potionText)
            } else {
                descriptionlabel.text = L10n.canHatchPet(eggText, potionText)
            }
        }
    }

    private func setupView() {
        contentView = stackView
        stackView.addArrangedSubview(imageStackView)
        imageStackView.addArrangedSubview(eggView)
        eggView.addSubview(eggCountView)
        imageStackView.addArrangedSubview(petView)
        potionView.addSubview(potionCountView)
        imageStackView.addArrangedSubview(potionView)
        let spacer = UIView()
        spacer.addHeightConstraint(height: 17)
        stackView.addArrangedSubview(spacer)
        stackView.addArrangedSubview(petTitleLabel)
        stackView.addArrangedSubview(descriptionlabel)
        
        stackView.setNeedsUpdateConstraints()
        stackView.setNeedsLayout()
        view.setNeedsLayout()
    }
    
    override func show() {
        super.show()
        AdhderAnalytics.shared.logNavigationEvent("navigated pet suggestion modal")
    }
    
    override func applyTheme(theme: Theme) {
        super.applyTheme(theme: theme)
        petView.tintColor = theme.dimmedColor

        eggView.backgroundColor = theme.windowBackgroundColor
        eggCountView.pillColor = theme.offsetBackgroundColor
        eggCountView.textColor = theme.primaryTextColor
        petView.backgroundColor = theme.windowBackgroundColor
        potionCountView.pillColor = theme.offsetBackgroundColor
        potionCountView.textColor = theme.primaryTextColor
        potionView.backgroundColor = theme.windowBackgroundColor
        
        petTitleLabel.textColor = theme.primaryTextColor
        descriptionlabel.textColor = theme.secondaryTextColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        stackView.setNeedsUpdateConstraints()
        stackView.setNeedsLayout()
    }
}
