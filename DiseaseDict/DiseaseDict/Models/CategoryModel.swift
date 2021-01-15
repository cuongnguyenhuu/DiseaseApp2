//
//  CategoryModel.swift
//  DiseaseDict
//
//  Created by Currie on 11/27/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryModel: Object, Decodable {
    @objc dynamic var id: String = ""
    @objc dynamic var image: String?
    @objc dynamic var name: String = ""
    @objc dynamic var des: String?
    @objc dynamic var tag: String?
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    override init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: CodingKeys.id)
        image = try container.decode(String?.self, forKey: CodingKeys.image)
        name = try container.decode(String.self, forKey: CodingKeys.name)
        des = try container.decode(String?.self, forKey: CodingKeys.description)
        do {
          tag = try container.decode(String?.self, forKey: CodingKeys.tag) ?? ""
        } catch {
            tag = ""
        }
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case image = "image"
        case name = "name"
        case description = "description"
        case tag = "tag"
    }
    
}
