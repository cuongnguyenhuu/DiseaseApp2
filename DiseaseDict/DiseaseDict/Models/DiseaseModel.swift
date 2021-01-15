//
//  DiseaseModel.swift
//  DiseaseDict
//
//  Created by Currie on 11/27/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import Foundation
import RealmSwift

class DiseaseModel: Object, Decodable {
    @objc dynamic var id: String = ""
    var categories: [Dictionary<String, String>]?
//    {
//        didSet{
//            categories?.forEach({ str in
//                self.strCategories += str["id"]! + ","
//            })
//            print("AAA \(self.strCategories)")
//        }
//    }
    @objc dynamic var name: String?
    @objc dynamic var overview: String?
    @objc dynamic var strCategories: String = ""
    @objc dynamic var isBookmarked: Bool = false
    
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    override init() {
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: CodingKeys.id)
        do {
            categories = try container.decode([Dictionary<String, String>].self, forKey: CodingKeys.categories)
            var tempStr: String = ""
            categories?.forEach({ str in
                tempStr += str["id"]! + ","
            })
            strCategories = tempStr
//            print("AAA \(self.strCategories)")
        } catch {
            categories = []
        }
        name = try container.decode(String.self, forKey: CodingKeys.name)
        do{
            overview = try container.decode(String?.self, forKey: CodingKeys.overview)
        } catch {
            overview = ""
        }
        
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case categories = "categories"
        case name = "name"
        case overview = "overview"
    }
    
}

