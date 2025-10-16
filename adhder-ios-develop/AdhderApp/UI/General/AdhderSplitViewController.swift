//
//  AdhderSplitViewController.swift
//  Adhder
//
//  Created by Phillip Thelen on 16.04.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import UIKit

class AdhderSplitViewController: BaseUIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftViewWidthConstraint: NSLayoutConstraint?
    @IBOutlet weak var rightViewWidthConstraint: NSLayoutConstraint?
    @IBOutlet weak var separatorView: UIView!
    
    private let segmentedWrapper = PaddedView()
    internal let segmentedControl = UISegmentedControl(items: ["", ""])
    private var isInitialSetup = true
    var showAsSplitView = false
    var canShowAsSplitView = true
    
    internal var viewID: String?
    
    private var borderView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAsSplitView = traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(AdhderSplitViewController.switchView(_:)), for: .valueChanged)
        segmentedControl.isHidden = false
        segmentedWrapper.insets = UIEdgeInsets(top: 4, left: 8, bottom: 10, right: 8)
        segmentedWrapper.containedView = segmentedControl
        borderView.frame = CGRect(x: 0, y: segmentedWrapper.intrinsicContentSize.height+1, width: self.view.bounds.size.width, height: 1)
        segmentedWrapper.addSubview(borderView)
        topHeaderCoordinator?.alternativeHeader = segmentedWrapper
        topHeaderCoordinator?.hideHeader = canShowAsSplitView && showAsSplitView
        
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        
        ThemeService.shared.addThemeable(themable: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let topHeaderNavigationController = navigationController as? TopHeaderViewController {
            scrollViewTopConstraint.constant = topHeaderNavigationController.contentInset
        }
    }
    
    override func applyTheme(theme: Theme) {
        super.applyTheme(theme: theme)
        borderView.backgroundColor = ThemeService.shared.theme.separatorColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isBeingDismissed {
            return
        }

        if isViewLoaded && isInitialSetup && viewID != nil {
            isInitialSetup = false
            
            if canShowAsSplitView {
                setupSplitView(traitCollection)
            } else {
                topHeaderCoordinator?.hideHeader = false
            }
            if !showAsSplitView {
                let userDefaults = UserDefaults()
                let lastPage = userDefaults.integer(forKey: (viewID ?? "") + "lastOpenedSegment")
                segmentedControl.selectedSegmentIndex = lastPage
                scrollTo(page: lastPage, animated: false)
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        let userDefaults = UserDefaults()
        userDefaults.set(segmentedControl.selectedSegmentIndex, forKey: (viewID ?? "") + "lastOpenedSegment")
        userDefaults.synchronize()
        super.viewWillDisappear(animated)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        coordinator.animate(alongsideTransition: {[weak self] (_) in
            self?.setupSplitView(newCollection)
            self?.scrollTo(page: self?.segmentedControl.selectedSegmentIndex ?? 0)
            }, completion: nil)
    }
    
    private func setupSplitView(_ collection: UITraitCollection) {
        if !canShowAsSplitView {
            return
        }
        showAsSplitView = canShowAsSplitView && (collection.horizontalSizeClass == .regular && collection.verticalSizeClass == .regular)
        separatorView.isHidden = !showAsSplitView
        scrollView.isScrollEnabled = !showAsSplitView
        topHeaderCoordinator?.hideHeader = showAsSplitView
        if showAsSplitView {
            let leftMultiplier = max(0.333, 375 / scrollView.frame.width)
            if leftViewWidthConstraint?.multiplier != leftMultiplier {
                leftViewWidthConstraint = leftViewWidthConstraint?.setMultiplier(multiplier: leftMultiplier)
                rightViewWidthConstraint = rightViewWidthConstraint?.setMultiplier(multiplier: 1-leftMultiplier)
            }
        } else if leftViewWidthConstraint?.multiplier != 1 {
            leftViewWidthConstraint = leftViewWidthConstraint?.setMultiplier(multiplier: 1)
            rightViewWidthConstraint = rightViewWidthConstraint?.setMultiplier(multiplier: 1)
        }
        view.layoutIfNeeded()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = getCurrentPage()
        segmentedControl.selectedSegmentIndex = currentPage
        view.endEditing(true)
    }
    
    @objc
    func switchView(_ segmentedControl: UISegmentedControl) {
        scrollTo(page: segmentedControl.selectedSegmentIndex)
        view.endEditing(true)
    }
    
    func getCurrentPage() -> Int {
        return Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
    
    func scrollTo(page: Int, animated: Bool = true) {
        let point = CGPoint(x: scrollView.frame.size.width * CGFloat(page), y: 0)
        scrollView.setContentOffset(point, animated: animated)
    }
}
