//
//  BaseModel.swift
//  DiseaseDict
//
//  Created by Currie on 12/23/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import Foundation

class BaseModel<T>: Decodable where T: Decodable {
    var httpStatusCode: Int
    var errorMessage: String?
    var errorCode: Int?
    var data: T
}
