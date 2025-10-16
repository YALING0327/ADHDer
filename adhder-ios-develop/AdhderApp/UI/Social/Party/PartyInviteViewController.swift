//
//  PartyInviteViewController.swift
//  Adhder
//
//  Created by Phillip Thelen on 16.06.23.
//  Copyright © 2023 AdhderApp Inc. All rights reserved.
//

import Foundation

class PartyInviteViewController: AdhderSplitViewController {
    override func viewDidLoad() {
        canShowAsSplitView = false
        super.viewDidLoad()
    }
    
    override func populateText() {
        navigationItem.title = L10n.Groups.findMembers
        segmentedControl.setTitle(L10n.Groups.list, forSegmentAt: 0)
        segmentedControl.setTitle(L10n.Groups.byInvite, forSegmentAt: 1)
    }
}
