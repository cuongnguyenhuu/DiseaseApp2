//
//  ReminderRealmService.swift
//  DiseaseDict
//
//  Created by Currie on 1/20/21.
//  Copyright © 2021 Currie. All rights reserved.
//

import Foundation
import RealmSwift

class ReminderRealmService {
    let realm = try! Realm()
    
    private init() {
        
    }
    
    static var shared = ReminderRealmService()
 
    func saveReminder(reminder: ReminderModel, complitionHandler: @escaping (_ finished: Bool)-> Void) {
//        reminders.forEach { reminder in
            try! realm.write{
                realm.add(reminder, update: .modified)
            }
//        }
        complitionHandler(true)
    }
    
    func fetchReminders(notifis: [UNNotificationRequest] ,complition: (_ reminders: [ReminderModel])->Void){
        
//        var results = [ReminderModel]()
//
//
//        notifis.forEach { (request) in
//            let rs = realm.objects(ReminderModel.self).filter { (reminder) -> Bool in
//                request.identifier == reminder.id
//            }
//            if rs.count > 0 {
//                results.append(rs.first!)
//            }
//        }
        let rs = realm.objects(ReminderModel.self).sorted { (r1, r2) -> Bool in
            r1.createdDate > r2.createdDate
        }
//        rs = rs.filter { reminder -> Bool in
//            return reminder.repeats.contains("1")
//        }
        
        complition(rs)
    }
    
    func removeReminder(reminder: ReminderModel, complitionHandler: @escaping (_ finished: Bool)-> Void) {
//        reminders.forEach { reminder in
        try! realm.write{
            realm.delete(reminder)
        }
//        }
        complitionHandler(true)
    }
}
