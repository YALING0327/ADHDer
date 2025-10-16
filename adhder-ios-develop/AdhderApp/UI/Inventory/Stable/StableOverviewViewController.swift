//
//  StableOverviewViewController.swift
//  Adhder
//
//  Created by Phillip Thelen on 16.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import UIKit
import Adhder_Models

class StableOverviewViewController<DS>: BaseCollectionViewController {
    
    var datasource: DS?
    
    var organizeByColor = false
    
    private let headerView = NPCBannerView(frame: CGRect(x: 0, y: -124, width: UIScreen.main.bounds.size.width, height: 124))
    
    override func viewDidLoad() {
        let headerXib = UINib.init(nibName: "StableSectionHeader", bundle: .main)
        collectionView?.register(headerXib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        
        let layout = collectionViewLayout as? UICollectionViewFlowLayout
        layout?.headerReferenceSize = CGSize(width: collectionView?.bounds.size.width ?? 50, height: 60)
        super.viewDidLoad()
        
        headerView.npcNameLabel.text = "Matt the Beast Master"
        headerView.setSprites(identifier: "stable")
        
        collectionView?.addSubview(headerView)
        collectionView?.contentInset = UIEdgeInsets(top: 124, left: 0, bottom: 0, right: 0)
    }
    
    override func applyTheme(theme: Theme) {
        super.applyTheme(theme: theme)
        collectionView.backgroundColor = theme.contentBackgroundColor
        headerView.applyTheme(backgroundColor: theme.contentBackgroundColor)
    }
}
