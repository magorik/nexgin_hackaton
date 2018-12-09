//
//  UserTableViewModel.swift
//  nexgin_ios
//
//  Created by Георгий on 08/12/2018.
//  Copyright © 2018 Георгий. All rights reserved.
//

import UIKit

protocol UserTableViewModelDelegate {
    func didSelected(indexptah:IndexPath?)
}

class UserTableViewModel: NGDynamicTable {

    var delegate: UserTableViewModelDelegate?
    
    override func cellIdentifier() -> String {
        return CellIdentifier.user
    }
    
    override var selectedIndexPath: IndexPath? {
        didSet {
            delegate?.didSelected(indexptah: selectedIndexPath)
        }
    }
    
    // MARK: Private Properties
    
    private struct CellIdentifier {
        static let user = "UserTableViewCell"
    }
}
