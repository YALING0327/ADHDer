//
//  NotificationsTableViewController.swift
//  Adhder
//
//  Created by Phillip Thelen on 23.04.19.
//  Copyright © 2019 AdhderApp Inc. All rights reserved.
//

import UIKit
import Adhder_Models

class NotificationsTableViewController: BaseTableViewController {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    private let dataSource = NotificationsDataSource()
    private var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = L10n.Titles.notifications
        doneButton.title = L10n.done
        
        dataSource.tableView = tableView
        dataSource.viewController = self
        tableView.register(UINib(nibName: "EmptyTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "emptyCell")
        dataSource.emptyDataSource = SingleItemTableViewDataSource<EmptyTableViewCell>(cellIdentifier: "emptyCell", styleFunction: EmptyTableViewCell.notificationsStyle)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        
        tableView.register(AchievementNotificationCell.self, forCellReuseIdentifier: "ACHIEVEMENT")
        tableView.register(UnallocatedPointsNotificationCell.self, forCellReuseIdentifier: AdhderNotificationType.unallocatedStatsPoints.rawValue)
        tableView.register(NewsNotificationCell.self, forCellReuseIdentifier: AdhderNotificationType.newStuff.rawValue)
        tableView.register(UnreadGroupNotificationCell.self, forCellReuseIdentifier: AdhderNotificationType.newChatMessage.rawValue)
        tableView.register(NewMysteryItemNotificationCell.self, forCellReuseIdentifier: AdhderNotificationType.newMysteryItem.rawValue)
        tableView.register(QuestInviteNotificationCell.self, forCellReuseIdentifier: AdhderNotificationType.questInvite.rawValue)
        tableView.register(GroupInviteNotificationCell.self, forCellReuseIdentifier: AdhderNotificationType.groupInvite.rawValue)
        tableView.register(ItemReceivedNotificationCell.self, forCellReuseIdentifier: AdhderNotificationType.itemReceived.rawValue)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataSource.didSelectedNotificationAt(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return dataSource.headerView(forSection: section, frame: view.frame)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
}
