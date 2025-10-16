//
//  StableDetailViewController.swift
//  Adhder
//
//  Created by Phillip Thelen on 16.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import UIKit
import Adhder_Models
import ReactiveSwift

class StableDetailViewController<DS>: BaseCollectionViewController {
    
    var searchEggs = true
    var searchKey: String = ""
    var animalType: String = "drop"
    var showMounts = false
    
    var datasource: DS?
    
    var disposable = ScopedDisposable(CompositeDisposable())
    let inventoryRepository = InventoryRepository()

    override func viewDidLoad() {
        let headerXib = UINib.init(nibName: "StableSectionHeader", bundle: .main)
        collectionView?.register(headerXib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        
        let layout = collectionViewLayout as? UICollectionViewFlowLayout
        layout?.headerReferenceSize = CGSize(width: collectionView?.bounds.size.width ?? 50, height: 60)
        super.viewDidLoad()
        disposable.inner.add(inventoryRepository.getItems(keys: [(searchEggs ? ItemType.eggs : ItemType.hatchingPotions): [searchKey]]).take(first: 1).on(value: {[weak self] items in
            if self?.searchEggs == true {
                if self?.showMounts == true {
                    self?.title = items.0.value.first?.mountText
                } else {
                    self?.title = items.0.value.first?.text
                }
            } else {
                self?.title = items.2.value.first?.text
            }
        }).start())
    }
    
    override func applyTheme(theme: Theme) {
        super.applyTheme(theme: theme)
        collectionView.backgroundColor = theme.contentBackgroundColor
    }
}
