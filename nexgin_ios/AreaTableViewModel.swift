//
//  AreaTableViewModel.swift
//  nexgin_ios
//
//  Created by Георгий on 08/12/2018.
//  Copyright © 2018 Георгий. All rights reserved.
//

import UIKit

class AreaTableViewModel: NGDynamicTable {
    
    override func cellIdentifier() -> String {
        return CellIdentifier.area
    }
    
    struct CellIdentifier {
        static let area = "AreaTableViewCell"
    }
}
