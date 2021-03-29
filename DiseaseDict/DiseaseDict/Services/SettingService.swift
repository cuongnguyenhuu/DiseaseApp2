//
//  SettingService.swift
//  DiseaseDict
//
//  Created by Currie on 1/15/21.
//  Copyright © 2021 Currie. All rights reserved.
//

import Foundation
import Alamofire

class SettingService {
    func getSettings( complition: @escaping (_ settings: SettingModel?,_ error: Bool) -> Void) {
        AF.request(URLRequest(url: URL(string: NetworkConfig.url+"/setting")!)).validate().responseDecodable { (response: DataResponse<BaseModel<SettingModel>, AFError>) in
            if response.error != nil {
                print("Calling API Error: \(response.error)")
                complition(nil, true)
            } else {
                do {
                    try complition(response.result.get().data, false)
                }
                catch{
                    complition(nil, true)
                }
            }
        }
    }
}
