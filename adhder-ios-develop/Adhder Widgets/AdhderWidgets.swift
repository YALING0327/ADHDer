//
//  AdhderWidgets.swift
//  Adhder
//
//  Created by Phillip Thelen on 07.10.20.
//  Copyright © 2020 AdhderApp Inc. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct AdhderWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        DailiesCountWidget()
        DailyTaskListWidget()
        TodoTaskListWidget()
        AddTaskWidgetSingle()
        AddTaskWidget()
        StatsWidget()
    }
}

func widgetPadding() -> CGFloat {
    if #available(iOS 17.0, *) {
        return 0
    } else {
        return 12
    }
}
