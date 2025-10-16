//
//  BaseReactiveDataSource.swift
//  Adhder
//
//  Created by Phillip Thelen on 05.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import ReactiveSwift
import Adhder_Database
import Adhder_Models

@objc
public protocol DataSourceEmptyDelegate {
    func dataSourceHasItems()
    func dataSourceIsEmpty()
}

class ItemSection<MODEL> {
    var key: String?
    var title: String?
    var isHidden = false
    var showIfEmpty = false
    var items = [MODEL]()
    var endDates: Set<Date>? = nil
    
    var isVisible: Bool {
        return !isHidden && (items.isEmpty == false || showIfEmpty)
    }
    
    init(key: String? = nil, title: String? = nil) {
        self.key = key
        self.title = title
    }
}

class BaseReactiveDataSource<MODEL>: NSObject {
    
    let disposable = CompositeDisposable()
    
    deinit {
        dispose()
    }
    
    @objc
    func dispose() {
        if !disposable.isDisposed {
            disposable.dispose()
        }
    }
    
    var sections = [ItemSection<MODEL>]()
    var visibleSections: [ItemSection<MODEL>] {
        return sections.filter({ (section) -> Bool in
            return section.isVisible
        })
    }
    
    @objc var userDrivenDataUpdate = false
    
    func item(at indexPath: IndexPath?) -> MODEL? {
        guard let indexPath = indexPath else {
            return nil
        }
        if indexPath.item < 0 || indexPath.section < 0 {
            return nil
        }
        let sections = visibleSections
        if indexPath.section < sections.count {
            if indexPath.item < sections[indexPath.section].items.count {
                return sections[indexPath.section].items[indexPath.item]
            }
        }
        return nil
    }
    
    @objc
    func retrieveData(completed: (() -> Void)?) {}
    
    func notify(changes: ReactiveChangeset?, section: Int = 0) {}
}

class BaseReactiveTableViewDataSource<MODEL>: BaseReactiveDataSource<MODEL>, UITableViewDataSource {
    @objc weak var emptyDelegate: DataSourceEmptyDelegate?
    @objc var isEmpty: Bool = true
    var emptyDataSource: UITableViewDataSource? {
        didSet {
            checkForEmpty()
        }
    }
    
    @objc weak var tableView: UITableView? {
        didSet {
            didSetTableView()
        }
    }
    
    func didSetTableView() {
        tableView?.dataSource = self
        tableView?.reloadData()
    }
    
    override func notify(changes: ReactiveChangeset?, section: Int = 0) {
        if changes == nil {
            return
        }
        if userDrivenDataUpdate {
            return
        }
        checkForEmpty()
        tableView?.reloadData()
    }
    
    func isDataSourceEmpty() -> Bool {
        return sections.filter({ $0.items.isEmpty == false }).isEmpty
    }
    
    func checkForEmpty() {
        if isDataSourceEmpty() {
            isEmpty = true
            emptyDelegate?.dataSourceIsEmpty()
            if emptyDataSource != nil {
                tableView?.dataSource = emptyDataSource
                tableView?.backgroundColor = ThemeService.shared.theme.contentBackgroundColor
                tableView?.separatorStyle = .none
                tableView?.allowsSelection = false
                tableView?.bounces = false
            }
        } else {
            isEmpty = false
            emptyDelegate?.dataSourceHasItems()
            if emptyDataSource != nil {
                tableView?.dataSource = self
                tableView?.backgroundColor = ThemeService.shared.theme.contentBackgroundColor
                tableView?.separatorStyle = .singleLine
                tableView?.allowsSelection = true
                tableView?.bounces = true
            }
        }
    }
    
    @objc(numberOfSectionsInTableView:)
    func numberOfSections(in tableView: UITableView) -> Int {
        return visibleSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if visibleSections.isEmpty {
            return 0
        }
        return visibleSections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if visibleSections.isEmpty {
            return nil
        }
        return visibleSections[section].title
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
}

class BaseReactiveCollectionViewDataSource<MODEL>: BaseReactiveDataSource<MODEL>, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @objc weak var collectionView: UICollectionView? {
        didSet {
            collectionView?.dataSource = self
            collectionView?.reloadData()
        }
    }
    
    override func notify(changes: ReactiveChangeset?, section: Int = 0) {
        if userDrivenDataUpdate {
            return
        }
        collectionView?.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleSections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reuseIdentifier = (kind == UICollectionView.elementKindSectionFooter) ? "SectionFooter" : "SectionHeader"
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath)

        if kind == UICollectionView.elementKindSectionHeader {
            let label = view.viewWithTag(1) as? UILabel
            label?.text = visibleSections[indexPath.section].title
        }

        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let flowlayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        return flowlayout?.headerReferenceSize ?? CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowlayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        return flowlayout?.itemSize ?? CGSize.zero
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}
