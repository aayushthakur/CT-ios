//
//  NotificationService.swift
//  NotificationService
//
//  Created by Aayush Thakur on 14/11/22.
//

import UserNotifications
import CTNotificationService
import CleverTapSDK


class NotificationService: CTNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        CleverTap.setDebugLevel(CleverTapLogLevel.debug.rawValue)
        CleverTap.sharedInstance()?.recordEvent("NotificationServiceEvent")
        let profile: Dictionary<String, Any> = [
                    "Identity": "iostestimpression",
                    "Email": "iosTest@yopmail.com",]
        CleverTap.sharedInstance()?.onUserLogin(profile)
                // call to record the Notification viewed
        CleverTap.sharedInstance()?.recordNotificationViewedEvent(withData:request.content.userInfo)
        super.didReceive(request, withContentHandler: contentHandler)
    }
    
}
