//
//  AreaObject.swift
//  nexgin_ios
//
//  Created by Георгий on 09/12/2018.
//  Copyright © 2018 Георгий. All rights reserved.
//

import UIKit
import ObjectMapper

class AreaObject: Mappable {
    struct Keys {
        static let identifier = "identifier"
        static let status = "status"
        static let history = "history"
        static let path = "path"
    }
    
    // MARK: Private Properties
    
    var identifier: Int?
    var status: Int? 
    var hidden: Bool = true
    var history: [Bool]?
    var path: String?
    var view: UIImageView?

    // MARK: Init Methods & Superclass Overriders
    
    required init?(map: Map) {        
        identifier <- map[Keys.identifier]
        status <- map[Keys.status]
        if let status = status, status == 3 {
            
        }
        path <- map[Keys.path]
        history <- map[Keys.history]
    }
    
    func mapping(map: Map) {
        identifier <- map[Keys.identifier]
        status <- map[Keys.status]
        path <- map[Keys.path]
        history <- map[Keys.history]
        
        if let status = status, status == 3 {
            
        }
    }
}
