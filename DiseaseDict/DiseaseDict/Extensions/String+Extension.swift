//
//  String+Extension.swift
//  DiseaseDict
//
//  Created by Currie on 12/8/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import Foundation

extension String {
    var htmlToAttributedString: NSAttributedString? {
        let str = "<!DOCTYPE html> <html> <head> <title>Page Title</title> <style> body {font-size:20px;}</style> </head> <body> \(self) </body> </html>"
        guard let data = str.data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        let str = "<!DOCTYPE html> <html> <head> <title>Page Title</title> <style> p {font-size:100px;color: red;}</style> </head> <body> \(self) </body> </html>"
        return str.htmlToAttributedString?.string ?? ""
    }
}
