//
//  ReminderModel.swift
//  DiseaseDict
//
//  Created by Currie on 1/20/21.
//  Copyright © 2021 Currie. All rights reserved.
//

import Foundation
import RealmSwift

class ReminderModel: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var time: String = ""
    @objc dynamic var repeats: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var createdDate: Int = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: String, date: String, time: String, repeats: String, title: String, content: String) {
        self.init()
        self.id = id
        self.date = date
        self.time = time
        self.repeats = repeats
        self.title = title
        self.content = content
        self.createdDate = Int((Date().timeIntervalSince1970))
    }
    
}

class Util {
    private init() {
        
    }
    static var share = Util()
    
    func convertArrayToString(ar: [Int]) -> String {
        var str = ""
        ar.forEach { i in
            str += "\(i) "
        }
        return str
    }
    
    func convertStringToArray(str: String) -> [Int]{
        var ar: [Int] = [Int]()
        Array(str).forEach { i in
            if i != " " {
                ar.append(Int("\(i)") ?? 0)
            }
        }
        return ar
    }
}
