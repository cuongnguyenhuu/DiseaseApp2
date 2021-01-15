//
//  CategoryRealmService.swift
//  DiseaseDict
//
//  Created by Currie on 12/24/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryRealmService {
    let realm = try! Realm()
    
    private init() {
        
    }
    
    static var shared = CategoryRealmService()
 
    func saveCategories(categories: [CategoryModel], complitionHandler: @escaping (_ finished: Bool)-> Void) {
        categories.forEach { category in
            try! realm.write{
                realm.add(category, update: .modified)
            }
        }
        complitionHandler(true)
    }
    
    func fetchCategories(complition: (_ categories: [CategoryModel])->Void){
        let results = realm.objects(CategoryModel.self)
        
        complition(Array(results))
    }
}
