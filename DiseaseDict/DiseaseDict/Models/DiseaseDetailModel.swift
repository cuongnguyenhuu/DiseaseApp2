//
//  DiseaseDetailModel.swift
//  DiseaseDict
//
//  Created by Currie on 12/8/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import Foundation

class DiseaseDetailModel: Decodable {
//    var categories: [CategoryModel]?
    var name: String
    var overview: String?
    var definition: String?
    var symptoms: String?
    var causes: String?
    var risk: String?
    var complications: String?
    var preparing: String?
    var tests: String?
    var treatment: String?
    var lifestyle: String?
    var alternative: String?
    var coping: String?
    var prevention: String?
    var bookmark: String = "0"
    var note: String?
    var _id: String?
    
    func prepareData() -> Dictionary<String, String> {
        var dic = Dictionary<String, String>()
        if definition != nil {
            dic["Definition"] = definition
        }
        if symptoms != nil {
            dic["Symptoms"] = symptoms
        }
        if causes != nil {
            dic["Causes"] = causes
        }
        if risk != nil {
            dic["Risk"] = risk
        }
        if complications != nil {
            dic["Complications"] = complications
        }
        if preparing != nil {
            dic["Preparing"] = preparing
        }
        if tests != nil {
            dic["Tests"] = tests
        }
        if treatment != nil {
            dic["Treatment"] = treatment
        }
        if lifestyle != nil {
            dic["Lifestyle"] = lifestyle
        }
        if alternative != nil {
            dic["Alternative"] = alternative
        }
        if coping != nil {
            dic["Coping"] = coping
        }
        if prevention != nil {
            dic["Prevention"] = prevention
        }
        return dic
    }
}
