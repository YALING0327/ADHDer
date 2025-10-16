//
//  SubscriptionDetailView.swift
//  Adhder
//
//  Created by Phillip Thelen on 06.09.24.
//  Copyright © 2024 AdhderApp Inc. All rights reserved.
//

import SwiftUI
import Adhder_Models
import StoreKit

private struct DetailContainer<Content: View>: View {
    var verticalPadding: CGFloat = 19
    @ViewBuilder
    let content: Content
    
    var body: some View {
        content
            .padding(.horizontal, 19)
            .padding(.vertical, verticalPadding)
            .frame(maxWidth: .infinity)
            .background(Color.purple200)
            .cornerRadius(8)
    }
}

private struct StatusPill: View {
    let text: String
    let background: Color
    var textColor = Color.white
    
    var body: some View {
        Text(text)
            .font(.system(size: 13, weight: .semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 3)
            .background(background)
            .cornerRadius(20)
            .foregroundColor(textColor)
    }
}

struct SubscriptionDetailViewUI: View {
    var plan: SubscriptionPlanProtocol
    
    var typeText: String {
        var duration: String?
        switch plan.planId {
        case "basic_earned":
                duration = L10n.durationMonth
        case "basic":
                duration = L10n.durationMonth
        case "basic_3mo":
            duration = L10n.duration3month
        case "basic_6mo":
            duration = L10n.duration6month
        case "google_6mo":
            duration = L10n.duration6month
        case "basic_12mo":
                duration = L10n.duration12month
        default:
            break
        }
        if let terminated = plan.dateTerminated {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return L10n.endingOn(formatter.string(from: terminated))
        } else if let duration = duration {
            return L10n.subscriptionDuration(duration)
        } else if plan.isGroupPlanSub {
            return L10n.memberGroupPlan
        } else {
            return ""
        }
    }
    
    var paymentTypeText: String {
        if plan.isGifted {
            return L10n.Subscription.gifted
        } else if plan.dateTerminated != nil || PurchaseHandler.shared.wasSubscriptionCancelled == true {
            return L10n.cancelled
        } else if plan.paymentMethod == "Apple" {
            if let nextEstimatedPayment = plan.nextEstimatedPayment {
                let format = DateFormatter()
                format.dateFormat = "MMM YYYY"
                return L10n.nextPaymentX(format.string(from: nextEstimatedPayment))
            }
            return "Apple Pay"
        } else if plan.paymentMethod == "Google" {
            return "Google Pay"
        } else if plan.paymentMethod == "PayPal" {
            return "PayPal"
        } else if plan.paymentMethod == "Stripe" {
            return "Stripe"
        } else {
            return ""
        }
    }
    
    @ViewBuilder
    var activityPill: some View {
        if plan.isActive {
            if plan.isGifted {
                StatusPill(text: L10n.Subscription.gifted, background: .yellow10, textColor: .purple100)
            } else if plan.isGroupPlanSub {
                StatusPill(text: L10n.groupPlan, background: .purple400)
            } else if plan.dateTerminated != nil || PurchaseHandler.shared.wasSubscriptionCancelled == true {
                StatusPill(text: L10n.cancelled, background: .maroon100)
            } else {
                StatusPill(text: L10n.active, background: .green10)
            }
        } else {
            StatusPill(text: L10n.inactive, background: .maroon100)

        }
    }
    
    var paymentImage: UIImage? {
        switch plan.paymentMethod {
        case "Amazon Payments":
            return Asset.paymentAmazon.image
        case "Apple":
            return Asset.paymentApple.image
        case "Google":
            return Asset.paymentGoogle.image
        case "PayPal":
            return Asset.paymentPaypal.image
        case "Stripe":
            return Asset.paymentStripe.image
        default:
            if plan.isGifted {
                return Asset.paymentGift.image
            } else {
                return nil
            }
        }
    }
    
    var cancelDescription: String {
        if plan.dateTerminated != nil {
            if plan.isGifted {
                return L10n.renewSubscriptionGiftedDescription
            } else {
                return L10n.renewSubscriptionDescription
            }
        } else if plan.paymentMethod == "Apple" {
            return L10n.unsubscribeItunes
        } else if plan.paymentMethod == "Google" {
            return L10n.unsubscribeGoogle
        } else if plan.paymentMethod != nil {
            return L10n.unsubscribeWebsite
        } else if plan.isGroupPlanSub {
            return L10n.cancelSubscriptionGroupPlan
        } else {
            return L10n.unsubscribeItunes
        }
    }
    
    var cancelButtonText: String? {
        if plan.dateTerminated != nil {
            return L10n.openItunes
        } else if plan.paymentMethod == "Apple" {
            return L10n.openItunes
        } else if plan.paymentMethod == "Google" {
            return L10n.openGooglePlay
        } else if plan.isGroupPlanSub {
            return nil
        } else {
            return L10n.openWebsite
        }
    }
    
    var nextHourglassDate: Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: plan.monthsUntilNextHourglass, to: Date())
    }
    
    var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 8) {
            if plan.extraMonths > 0 {
                Text(LocalizedStringKey(L10n.subscriptionCreditTitle(plan.extraMonths)))
                    .font(.system(size: 15))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.green500)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 11)
                    .padding(.horizontal, 15)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 3)
                            .foregroundColor(.green100)
                    }
            }
            DetailContainer {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(L10n.subscription)
                            .font(.system(size: 15, weight: .semibold))
                        Text(typeText)
                            .font(.system(size: 13))
                    }
                    Spacer()
                    activityPill
                }
            }
            if !plan.isGroupPlanSub {
                DetailContainer {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(L10n.Subscription.paymentMethod)
                                .font(.system(size: 15, weight: .semibold))
                            Text(paymentTypeText)
                                .font(.system(size: 13))
                        }
                        Spacer()
                        if let image = paymentImage {
                            Image(uiImage: image)
                        }
                    }
                }
            }
            HStack(spacing: 8) {
                DetailContainer(verticalPadding: 14) {
                    VStack(spacing: 6) {
                        HStack(spacing: 4) {
                            Image(Asset.calendarLarge.name)
                            Text("\(plan.consecutive?.count ?? 0)")
                                .font(.system(size: 22, weight: .bold))
                        }
                        Text(L10n.Subscription.monthsSubscribed)
                            .font(.system(size: 13, weight: .semibold))
                    }.frame(maxHeight: .infinity)
                }
                DetailContainer(verticalPadding: 14) {
                    VStack(spacing: 6) {
                        HStack(spacing: 4) {
                            Image(Asset.bigGem.name)
                            Text("\(plan.gemCapTotal)")
                                .font(.system(size: 22, weight: .bold))
                        }
                        Text(L10n.Subscription.monthlyGems)
                            .font(.system(size: 13, weight: .semibold))
                    }.frame(maxHeight: .infinity)
                }
            }.multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            DetailContainer(verticalPadding: 14) {
                HStack(spacing: 4) {
                    Image(Asset.hourglassBannerLeft.name)
                    if plan.isActive {
                        VStack {
                            if let date = nextHourglassDate {
                                Text(date, formatter: monthFormatter)
                                    .font(.system(size: 22, weight: .bold))
                            }
                            Text(L10n.Subscription.nextHourglassDelivery)
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        Text(L10n.Subscription.subscribeAgainHourglasses)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 13, weight: .medium))
                    }
                    Image(Asset.hourglassBannerRight.name)
                }
            }
            if !(plan.isGifted && plan.isActive) {
                DetailContainer(verticalPadding: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Group {
                            if plan.isGifted {
                                Text(L10n.continueBenefits)
                            } else if plan.dateTerminated != nil {
                                Text(L10n.resubscribe)
                            } else if plan.paymentMethod == "Apple" {
                                Text(L10n.editCancelSubscription)
                            } else {
                                Text(L10n.cancelSubscription)
                            }
                        }.font(.system(size: 15, weight: .semibold))
                        Text(cancelDescription).font(.system(size: 13))
                        if let text = cancelButtonText {
                            AdhderButtonUI(label: Text(text).foregroundColor(.purple100), color: .yellow100, size: .compact) {
                                cancelSubscription()
                            }.padding(.top, 7)
                        }
                    }
                }
            }
        }
    }
    
    func cancelSubscription() {
        var url: URL?
        if plan.paymentMethod == "Apple" || plan.isGifted || plan.dateTerminated != nil {
            if let window = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                Task {
                    do {
                        try await AppStore.showManageSubscriptions(in: window)
                    } catch {
                        
                    }
                }
                return
            }
            url = URL(string: "https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/manageSubscriptions")
        } else if plan.paymentMethod == "Google" {
            url = URL(string: "http://support.google.com/googleplay?p=cancelsubsawf")
        } else {
            url = URL(string: "https://adhder.com")
        }
        if let applicationUrl = url {
            UIApplication.shared.open(applicationUrl, options: [:], completionHandler: nil)
        }
    }
}
