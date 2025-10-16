//
//  SocialRepository.swift
//  Adhder
//
//  Created by Phillip Thelen on 18.01.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import Foundation

@objc
class SocialRepository: BaseRepository {
    
    @objc
    func getGroup(_ id: String) -> Group? {
        return makeFetchRequest(entityName: "Group", predicate: NSPredicate(format: "id == %@", id))
    }
}
