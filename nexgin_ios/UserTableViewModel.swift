//
//  UserTableViewModel.swift
//  nexgin_ios
//
//  Created by Георгий on 08/12/2018.
//  Copyright © 2018 Георгий. All rights reserved.
//

import UIKit

class UserTableViewModel: NGDynamicTable {

    override func cellIdentifier() -> String {
        return CellIdentifier.user
    }
    
    // MARK: Private Properties
    
    private struct CellIdentifier {
        static let user = "UserTableViewCell"
    }
}
