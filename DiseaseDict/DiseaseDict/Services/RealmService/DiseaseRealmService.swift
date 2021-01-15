//
//  DiseaseRealmService.swift
//  DiseaseDict
//
//  Created by Currie on 12/24/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import Foundation
import RealmSwift

class DiseaseRealmService {
    let realm = try! Realm()
    
    private init() {
        
    }
    
    static var shared = DiseaseRealmService()
 
    func saveAll(diseases: [DiseaseModel], complitionHandler: @escaping (_ finished: Bool)-> Void) {
        diseases.forEach { disease in
//            print(disease.categories?.count)
            let ds = realm.objects(DiseaseModel.self).filter { d -> Bool in
                return d.id == disease.id
            }
            
            if let d = ds.first {
                try! realm.write{
                    d.categories = disease.categories
                    d.name = disease.name
                    d.overview = disease.overview
                    d.strCategories = disease.strCategories
                }
            } else {
                try! realm.write{
                    realm.add(disease, update: .modified)
                }
            }
        }
        complitionHandler(true)
    }
    
    func fetchAll(complition: (_ categories: [DiseaseModel])->Void){
        let results = realm.objects(DiseaseModel.self)
        
        complition(Array(results))
    }
    
    func search(searchText: String, complition: (_ categories: [DiseaseModel])->Void) {
        let results = realm.objects(DiseaseModel.self).filter { disease -> Bool in
            if disease.name != nil && disease.overview != nil {
                return disease.name!.contains(searchText) || disease.overview!.contains(searchText)
            }
            if disease.name != nil {
                return disease.name!.contains(searchText)
            }
            if disease.overview != nil {
                return disease.overview!.contains(searchText)
            }
            
            return false
        }
        
        complition(Array(results))
    }
    
    func getDiseaseByCategory(id: String, complition: (_ categories: [DiseaseModel])->Void) {
        let results = realm.objects(DiseaseModel.self).filter { disease -> Bool in
            if disease.strCategories.isEmpty {
                return false
            }
//            print(disease.strCategories)
            return (disease.strCategories.contains(id))
        }
        
        complition(Array(results))
    }
    
    func saveOrRemoveBookmark(diseaseModel: DiseaseModel, complition: ()->Void) {
        let diseases = realm.objects(DiseaseModel.self).filter { d -> Bool in
            return diseaseModel.id == d.id
        }
        
        if let disease = diseases.first {
            try! realm.write({
                disease.isBookmarked = !disease.isBookmarked
            })
        }
        complition()
    }
    
    func getBookmarkDiseases(complition: (_ categories: [DiseaseModel])->Void) {
            let results = realm.objects(DiseaseModel.self).filter { disease -> Bool in
                return disease.isBookmarked
            }
            
            complition(Array(results))
        }
}
