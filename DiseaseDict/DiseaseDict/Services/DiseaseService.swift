//
//  DiseaseService.swift
//  DiseaseDict
//
//  Created by Currie on 11/27/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import Foundation
import Alamofire

class DiseaseService {
    func getDiseaseByParameters(keyword: String = "", categoryId: String = "", pageSize: Int = 0, pageIndex: String = "", orderByColumn: Int = 0, orderByDirection: Int = 0, complition: @escaping (_ diseases: [DiseaseModel]) -> Void) {
        let url = URL(string: NetworkConfig.url+"/disease/v2?keyword=\(keyword)&pageSize=\(pageSize)&pageIndex=\(pageIndex)&orderByColumn=\(orderByColumn)&orderByDirection=\(orderByDirection)" + (categoryId.isEmpty ? "" : "&categoryId=\(categoryId)") )!
//        url.queryItems = [
//            URLQueryItem(name: "keyword", value: keyword),
//            URLQueryItem(name: "categoryId", value: categoryId),
////            URLQueryItem(name: "pageSize", value: "\(pageSize)"),
////            URLQueryItem(name: "pageIndex", value: "\(pageIndex)"),
////            URLQueryItem(name: "orderByColumn", value: "\(orderByColumn)"),
////            URLQueryItem(name: "orderByDirection", value: "\(orderByDirection)")
//        ]
        print(url)
        AF.request(URLRequest(url: url)).validate().responseDecodable { (response: DataResponse<BaseModel<BasePagingModel<[DiseaseModel]>>, AFError>) in
            if response.error != nil {
                print("Calling API Error \(String(describing: response.error))")
            } else {
                do {
                    try complition(response.result.get().data.data)
                }
                catch{
                    print("data error")
                }
            }
        }
    }
    
    func getDiseaseById(id: String, complition: @escaping (_ diseases: DiseaseDetailModel) -> Void){
        AF.request(URLRequest(url: URL(string: NetworkConfig.url+"/disease/"+id)!)).validate().responseDecodable { (response: DataResponse<BaseModel<DiseaseDetailModel>, AFError>) in
            if response.error != nil {
                print("Calling API Error \(String(describing: response.error))")
            } else {
                do {
                    try complition(response.result.get().data)
                }
                catch{
                    print("data error")
                }
            }
        }
    }
    
    func getAllDiseases(complition: @escaping (_ diseases: [DiseaseModel], _ error: Bool) -> Void) {
        AF.request(URLRequest(url: URL(string: NetworkConfig.url+"/disease")!)).validate().responseDecodable { (response: DataResponse<BaseModel<BasePagingModel<[DiseaseModel]>>, AFError>) in
            if response.error != nil {
                print("Calling API Error \(response.error)")
                complition([], true)
            } else {
                do {
                    try complition(response.result.get().data.data, false)
                }
                catch{
                    print("data error")
                    complition([], true)
                }
            }
        }
    }
}
