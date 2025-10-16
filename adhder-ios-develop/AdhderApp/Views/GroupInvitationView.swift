//
//  GroupInvitationView.swift
//  Adhder
//
//  Created by Phillip Thelen on 22.06.18.
//  Copyright © 2018 AdhderApp Inc. All rights reserved.
//

import UIKit
import Adhder_Models
import PinLayout

class GroupInvitationView: UIView {
    
    private let avatarWrapper: UIView = {
        let view = UIView()
        view.cornerRadius = 20
        return view
    }()
    private let avatarView: AvatarView = {
        let view = AvatarView()
        view.frame = CGRect(x: -7, y: -3, width: 50, height: 50)
        view.size = .compact
        view.showMount = false
        view.showPet = false
        return view
    }()
    private let label: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = UIFontMetrics.default.scaledSystemFont(ofSize: 15, ofWeight: .semibold)
        view.numberOfLines = 3
        return view
    }()
    private let declineButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.cornerRadius = 16
        view.setImage(AdhderIcons.imageOfDeclineIcon, for: .normal)
        view.isPointerInteractionEnabled = true
        return view
    }()
    private let acceptButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.cornerRadius = 16
        view.setImage(AdhderIcons.imageOfAcceptIcon, for: .normal)
        view.isPointerInteractionEnabled = true
        return view
    }()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue50
        view.isHidden = true
        return view
    }()
    
    var showSeparator: Bool = false {
        didSet {
            separatorView.isHidden = !showSeparator
        }
    }
    
    private var inviterName: String?
    private var inviterId: String?
    private var name: String?
    private var isPartyInvitation = false
    
    var responseAction: ((Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        avatarWrapper.addSubview(avatarView)
        addSubview(avatarWrapper)
        addSubview(label)
        addSubview(declineButton)
        addSubview(acceptButton)
        addSubview(separatorView)
        
        let theme = ThemeService.shared.theme
        if theme.isDark {
            backgroundColor = UIColor.blue10
        } else {
            backgroundColor = UIColor.blue100
        }
        acceptButton.backgroundColor = theme.contentBackgroundColor
        declineButton.backgroundColor = theme.contentBackgroundColor
        
        declineButton.addTarget(self, action: #selector(declineInvitation), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptInvitation), for: .touchUpInside)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
    }
    
    func set(invitation: GroupInvitationProtocol) {
        name = invitation.name
        isPartyInvitation = invitation.isPartyInvitation
        setLabel()
    }
    
    func set(inviter: MemberProtocol) {
        inviterName = inviter.username
        inviterId = inviter.id
        setLabel()
        avatarView.avatar = AvatarViewModel(avatar: inviter)
    }
    
    private func setLabel() {
        var text = ""
        if isPartyInvitation {
            if let inviterName = inviterName {
                text = L10n.Party.invitationInvitername(inviterName, name ?? "")
            } else {
                text = L10n.Party.invitationNoInvitername(name ?? "")
            }
        } else {
            if let inviterName = inviterName {
                text = L10n.Groups.guildInvitationInvitername(inviterName, name ?? "")
            } else {
                text = L10n.Groups.guildInvitationNoInvitername(name ?? "")
            }
        }
        label.text = (try? AdhderMarkdownHelper.toAdhderAttributedString(text))?.string
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    private func layout() {
        acceptButton.pin.end(16).vCenter().size(32)
        declineButton.pin.before(of: acceptButton).marginEnd(20).size(32).vCenter()
        if bounds.width > 300 {
            avatarWrapper.isHidden = false
            avatarWrapper.pin.start(16).vCenter().size(40)
            label.pin.after(of: avatarView).before(of: declineButton).marginHorizontal(16).top().bottom()
        } else {
            avatarWrapper.isHidden = true
            label.pin.start(16).before(of: declineButton).marginHorizontal(16).top().bottom()
        }
        separatorView.pin.top().horizontally().height(1)
    }
    
    @objc
    private func declineInvitation() {
        if let action = responseAction {
            action(false)
        }
    }
    
    @objc
    private func acceptInvitation() {
        if let action = responseAction {
            action(true)
        }
    }
    
    @objc
    private func onTap() {
        RouterHandler.shared.handle(urlString: "/profile/\(inviterId ?? "")")
    }
}
