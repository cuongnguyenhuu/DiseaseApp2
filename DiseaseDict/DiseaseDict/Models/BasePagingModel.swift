//
//  BasePagingModel.swift
//  DiseaseDict
//
//  Created by Currie on 11/27/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import Foundation

class BasePagingModel<T>: Decodable where T: Decodable {
    var pageIndex: Int
    var pageSize: Int
    var count: Int
    var data: T
}
