//
//  StableSplitViewController.swift
//  Adhder
//
//  Created by Phillip Thelen on 16.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import UIKit

class StableSplitViewController: AdhderSplitViewController {
    @IBOutlet weak var organizeByButton: UIBarButtonItem!
    
    private var petViewController: PetOverviewViewController?
    private var mountViewController: MountOverviewViewController?
    
    private var organizeByColor = false {
        didSet {
            petViewController?.organizeByColor = organizeByColor
            mountViewController?.organizeByColor = organizeByColor
            UserDefaults.standard.set(organizeByColor, forKey: "stableOrganize")
        }
    }
    
    override func viewDidLoad() {
        canShowAsSplitView = false
        super.viewDidLoad()
        organizeByColor = UserDefaults.standard.bool(forKey: "stableOrganize")
        
        for childViewController in children {
            if let viewController = childViewController as? PetOverviewViewController {
                petViewController = viewController
                viewController.organizeByColor = organizeByColor
            }
            if let viewController = childViewController as? MountOverviewViewController {
                mountViewController = viewController
                viewController.organizeByColor = organizeByColor
            }
        }
        
        AdhderAnalytics.shared.log("open_stable")
    }
    
    override func populateText() {
        navigationItem.title = L10n.Titles.petsAndMounts
        segmentedControl.setTitle(L10n.pets, forSegmentAt: 0)
        segmentedControl.setTitle(L10n.mounts, forSegmentAt: 1)
        organizeByButton.title = L10n.organizeBy
    }
    
    @IBAction func changeOrganizeBy(_ sender: Any) {
        let sheet = HostingBottomSheetController(rootView: BottomSheetMenu(menuItems: {
            BottomSheetMenuitem(title: L10n.Stable.color, onTap: {[weak self] in
                self?.organizeByColor = true
            })
            BottomSheetMenuitem(title: L10n.Stable.type, onTap: {[weak self] in
                self?.organizeByColor = false
            })
        }))
        present(sheet, animated: true)
    }
}
