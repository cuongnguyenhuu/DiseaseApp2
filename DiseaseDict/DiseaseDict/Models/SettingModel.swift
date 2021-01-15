//
//  SettingModel.swift
//  DiseaseDict
//
//  Created by Currie on 1/15/21.
//  Copyright © 2021 Currie. All rights reserved.
//

import Foundation

class SettingModel: Decodable {
    var isShowAds: Bool
    var isShowCategories: Bool
    var hasNewData: String
    var lastUpdated: String
    var lastInformed: String
}
