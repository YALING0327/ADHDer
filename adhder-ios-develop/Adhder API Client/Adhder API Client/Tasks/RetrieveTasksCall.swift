//
//  RetrieveTasksAPICall.swift
//  Adhder API Client
//
//  Created by Phillip Thelen on 05.03.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation
import Adhder_Models
import ReactiveSwift

public class RetrieveTasksCall: ResponseArrayCall<TaskProtocol, APITask> {
    public init(dueOnDay: Date? = nil, type: String? = nil, forceLoading: Bool = false) {
        var url = "tasks/user"
        if let date = dueOnDay {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone.current
            var dateString = formatter.string(from: date)
            let regex = try? NSRegularExpression(pattern: "T([0-9]):", options: .caseInsensitive)
            dateString = regex?.stringByReplacingMatches(in: dateString, options: [], range: NSRange(location: 0, length: dateString.count), withTemplate: "T0$1:") ?? ""
            let encodedDateString = dateString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? dateString
            url = "\(url)?type=dailys&dueDate=\(encodedDateString)"
        }
        if let type = type {
            url = "\(url)?type=\(type)"
        }
        super.init(httpMethod: .GET, endpoint: url, ignoreEtag: forceLoading)
    }
}
