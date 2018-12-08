//
//  UserModel.swift
//  nexgin_ios
//
//  Created by Георгий on 08/12/2018.
//  Copyright © 2018 Георгий. All rights reserved.
//

import UIKit
import ObjectMapper

class LiveUpdateModel: Mappable {
    var delegate: LiveUpdateModelDelegate?
    
    required init?(map: Map) {}
    func mapping(map: Map) {}
}

protocol LiveUpdateModelDelegate {
    func dataUpdated()
}

class UserModel: LiveUpdateModel {
    struct Keys {
        static let identifier = "identifier"
        static let x = "x"
        static let y = "y"
        static let timestamp = "timestamp"
    }
    
    // MARK: Private Properties
    
    var identifier: String?
    var x: String?
    var y: String?
    var timestamp: String?
    var color: UIColor! = .white
    
    // MARK: Init Methods & Superclass Overriders
    
    required init?(map: Map) {
        super.init(map: map)
        
        identifier <- map[Keys.identifier]
        x <- map[Keys.x]
        y <- map[Keys.y]
        timestamp <- map[Keys.timestamp]
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        identifier <- map[Keys.identifier]
        x <- map[Keys.x]
        y <- map[Keys.y]
        timestamp <- map[Keys.timestamp]
    }
}
