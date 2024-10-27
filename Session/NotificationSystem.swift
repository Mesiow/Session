//
//  NotificationSystem.swift
//  Session
//
//  Created by Mesiow on 6/11/23.
//

import Foundation
import UserNotifications

struct NotificationSystem {
    static var authorized : Bool = false;
    
    static func checkForPermission(){
        let nc = UNUserNotificationCenter.current();
        nc.getNotificationSettings { settings in
            switch settings.authorizationStatus {
                case .authorized:
                    self.authorized = true;
                    print("authorized!")
                
                case .denied:
                    self.authorized = false;
                    print("denied!")
                
            case .notDetermined:
                nc.requestAuthorization(options: [.badge, .alert, .sound]) { didAllow, error in
                    if didAllow {
                        self.authorized = true;
                        print("allowed/authorized!")
                    }else{
                        self.authorized = false;
                        print("Error requesting notification auth: \(String(describing: error))");
                    }
                }
                
            default:
                return
            }
        }
    }
    
    //name of session to dispatch notification for and the time in total seconds of the countdown
    static func dispatchNotification(sessionName: String, _ countdown: Int32){
        if self.authorized {
            let nc = UNUserNotificationCenter.current();
            let content = UNMutableNotificationContent();
            content.title = sessionName;
            content.body = "Timer";
            content.sound = .defaultRingtone
            
            //trigger set to countdown seconds from now
            let now = Date();
            let newDate = Calendar.current.date(byAdding: .second, value: Int(countdown), to: now)!
            let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newDate);
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false);
            let request = UNNotificationRequest(identifier: sessionName, content: content, trigger: trigger);
            
            //remove previous notification request if there is one left
            nc.removeAllPendingNotificationRequests();
            nc.add(request) { error in
                guard error == nil else { return }
                print("scheduling notification with id: \(request.identifier)")
                print(" at date: \(self.formattedDate(date: newDate))")
            }
        }
    }
    
    static func formattedDate(date: Date) -> String {
        let formatter = DateFormatter();
        formatter.dateFormat = "d MM y HH:mm";
        return formatter.string(from: date);
    }
}
