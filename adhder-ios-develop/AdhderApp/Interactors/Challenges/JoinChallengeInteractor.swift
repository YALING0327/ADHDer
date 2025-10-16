//
//  JoinChallengeInteractor.swift
//  Adhder
//
//  Created by Phillip Thelen on 06/03/2017.
//  Copyright © 2017 AdhderApp Inc. All rights reserved.
//

import UIKit
import ReactiveSwift
import Adhder_Models

class JoinChallengeInteractor: Interactor<ChallengeProtocol, Bool> {

    private let socialRepository = SocialRepository()
    private let taskRepository = TaskRepository()
    
    override func configure(signal: Signal<ChallengeProtocol, NSError>) -> Signal<Bool, NSError> {
        return signal.flatMap(.concat) {[weak self] (challenge) -> Signal<Bool, NSError> in
            let challengeID = challenge.id ?? ""
            return self?.socialRepository.joinChallenge(challengeID: challengeID)
                .flatMap(.latest, { _ in
                    return (self?.taskRepository.retrieveTasks() ?? Signal.empty)
                })
                .map({ (_) in
                    return true
                })
                .promoteError() ?? Signal.empty
        }
    }
}
