//
//  AreaObject.swift
//  nexgin_ios
//
//  Created by Георгий on 09/12/2018.
//  Copyright © 2018 Георгий. All rights reserved.
//

import UIKit
import ObjectMapper
import NotificationBannerSwift

class AreaObject: LiveUpdateModel {
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
    var view: UIView?
    var personCount: Int = 0 {
        didSet {
            if personCount > 5, canShowAlert {
                let banner = NotificationBanner(title: "Внимание!", subtitle: "Опасное скопление людей в зоне " + "#" + String(identifier! + 1), style: .danger)
                canShowAlert = false
                banner.show(bannerPosition: .top)
            }
        }
    }
    
    private var canShowAlert = true
    
    // MARK: Init Methods & Superclass Overriders
    
    required init?(map: Map) {
        super.init(map: map)
        
        identifier <- map[Keys.identifier]
        status <- map[Keys.status]
        if let status = status, status == 3 {
            
        }
        path <- map[Keys.path]
        history <- map[Keys.history]
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        identifier <- map[Keys.identifier]
        status <- map[Keys.status]
        path <- map[Keys.path]
        history <- map[Keys.history]
        
        if let status = status, status == 3 {
            
        }
    }
}
