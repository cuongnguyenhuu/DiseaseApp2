//
//  CategoryService.swift
//  DiseaseDict
//
//  Created by Currie on 11/27/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import Foundation
import Alamofire

class CategoryService {
    func getCategories( complition: @escaping (_ categories: [CategoryModel],_ error: Bool) -> Void) {
        AF.request(URLRequest(url: URL(string: NetworkConfig.url+"/category")!)).validate().responseDecodable { (response: DataResponse<BaseModel<[CategoryModel]>, AFError>) in
            if response.error != nil {
                print("Calling API Error: \(response.error)")
                complition([], true)
            } else {
                do {
                    try complition(response.result.get().data, false)
                }
                catch{
                    print("data error")
                    complition([], true)
                }
            }
        }
    }
}
