//
//  UserModel.swift
//  nexgin_ios
//
//  Created by Георгий on 08/12/2018.
//  Copyright © 2018 Георгий. All rights reserved.
//

import UIKit
import ObjectMapper

class UserModel: Mappable {
    
    struct Keys {
        static let identifier = "identifier"
        static let x = "x"
        static let y = "y"
        static let timestamp = "timestamp"
    }
    
    // MARK: Private Properties
    
    private(set) var identifier: String?
    private(set) var x: String?
    private(set) var y: String?
    private(set) var timestamp: String?
    
    // MARK: Init Methods & Superclass Overriders
    
    required init?(map: Map) {
        identifier <- map[Keys.identifier]
        x <- map[Keys.x]
        y <- map[Keys.y]
        timestamp <- map[Keys.timestamp]
    }
    
     func mapping(map: Map) {        
        identifier <- map[Keys.identifier]
        x <- map[Keys.x]
        y <- map[Keys.y]
        timestamp <- map[Keys.timestamp]
    }
}
