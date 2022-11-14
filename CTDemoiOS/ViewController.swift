//
//  ViewController.swift
//  CTDemoiOS
//
//  Created by Aayush Thakur on 09/11/22.
//

import UIKit
import CleverTapSDK


class ViewController: UIViewController, CleverTapInAppNotificationDelegate, CleverTapInboxViewControllerDelegate, CleverTapDisplayUnitDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            CleverTap.sharedInstance()?.enableDeviceNetworkInfoReporting(true)
            
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
                
                    locationManager.startUpdatingLocation()
            
            inAppNAppInbox()
            
           // CleverTap.sharedInstance()?.setDisplayUnitDelegate(self)
        
        }
    
    func inAppNAppInbox() {
        
        CleverTap.sharedInstance()?.initializeInbox(callback: ({ (success) in
                let messageCount = CleverTap.sharedInstance()?.getInboxMessageCount()
                let unreadCount = CleverTap.sharedInstance()?.getInboxMessageUnreadCount()
                print("Inbox Message:\(String(describing: messageCount))/\(String(describing: unreadCount)) unread")
         }))
        
        // config the style of App Inbox Controller
            let style = CleverTapInboxStyleConfig.init()
            style.title = "App Inbox"
            style.backgroundColor = UIColor.blue
            style.messageTags = ["tag1", "tag2"]
            style.navigationBarTintColor = UIColor.blue
            style.navigationTintColor = UIColor.blue
            style.tabUnSelectedTextColor = UIColor.blue
            style.tabSelectedTextColor = UIColor.blue
            style.tabSelectedBgColor = UIColor.blue
            style.firstTabTitle = "My First Tab"
            
            if let inboxController = CleverTap.sharedInstance()?.newInboxViewController(with: style, andDelegate: self) {
                let navigationController = UINavigationController.init(rootViewController: inboxController)
                self.present(navigationController, animated: true, completion: nil)
          }
    }
    
    
    
    @IBAction func updateProfile(_sender : UIButton) {
        let updateProfile: Dictionary<String, Any> = ["Plan type": "Gold",
                                                "Gender": "M"
                                             ]
        CleverTap.sharedInstance()?.profilePush(updateProfile)

    }
    
    
    @IBAction func onClickofLoginButton(_sender : UIButton) {
        
        let calendar = Calendar.current
        let dateComponents = DateComponents(calendar: calendar,
                                            year: 2021,
                                            month: 11,
                                            day: 25)
        let date = calendar.date(from: dateComponents)!
        
        let profile: Dictionary<String, Any> = ["Name": "iOS Test"
                                                ,"Email": "iosTest@yopmail.com",
                                                "Plan type": "Normal",
                                                "Phone": "+919999999999",
                                                "Photo": "https://media.istockphoto.com/id/1136413215/photo/young-man-at-street-market.jpg?s=612x612&w=is&k=20&c=N_Qgu0qUfjcmIQa0xuReT2W_fY7teWtMLrKU-IEe0ok=",
                                                "DOB": date,
                                                "MSG-email": true as AnyObject,
                                                "MSG-whatsapp": true as AnyObject,
                                                "MSG-push": true as AnyObject,
                                                "MSG-sms": true as AnyObject,
                                                "MSG-dndPhone": false as AnyObject,
                                                "MSG-dndEmail": false as AnyObject,
                                                "Identity": "iostestimpression"]
        
        CleverTap.sharedInstance()?.onUserLogin(profile)
        
        
    }
    
    //
    
    @IBAction func updateLocationWithUserConsent() {
        
        
        CleverTap.getLocationWithSuccess({(location: CLLocationCoordinate2D) -> Void in
            // do something with location here, optionally set on CleverTap for use in segmentation etc
            CleverTap.setLocation(location)
            CleverTap.sharedInstance()?.recordEvent("Location Updated Successfully")
        }, andError: {(error: String?) -> Void in
            if let e = error {
                print(e)
            }
        })
    }
    
    
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation] ) {
            if let location = locations.last {
//                let latitude = location.coordinate.latitude
//                let longitude = location.coordinate.longitude
                // Handle location update
                CleverTap.setLocation(location.coordinate)
            }
            
        }
        
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            // Handle failure to get a user’s location
        }
    
    //
    
    @IBAction func productViewedEvent(_sender : UIButton) {

        let props = [
            "Product name": "Casio Chronograph Watch",
            "Category": "Mens Accessories",
            "Price": 59.99,
            "Date": NSDate()
        ] as [String : Any]

        CleverTap.sharedInstance()?.recordEvent("Product viewed", withProps: props)

        
    }
    
    func inAppNotificationButtonTapped(withCustomExtras customExtras: [AnyHashable : Any]!) {
          print("In-App Button Tapped with custom extras:", customExtras ?? "");
      }
    
    func messageButtonTapped(withCustomExtras customExtras: [AnyHashable : Any]?) {
            print("App Inbox Button Tapped with custom extras: ", customExtras ?? "");
        }

}

