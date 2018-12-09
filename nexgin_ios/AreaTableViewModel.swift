//
//  AreaTableViewModel.swift
//  nexgin_ios
//
//  Created by Георгий on 08/12/2018.
//  Copyright © 2018 Георгий. All rights reserved.
//

import UIKit

protocol AreaTableViewModelDelegate {
    func didSelect(indexptah:IndexPath?)
}

class AreaTableViewModel: NGDynamicTable {
    
    var delegate: AreaTableViewModelDelegate?

    override func cellIdentifier() -> String {
        return CellIdentifier.area
    }
    
    override var selectedIndexPath: IndexPath? {
        didSet {
            delegate?.didSelect(indexptah: selectedIndexPath)
        }
    }
    
    struct CellIdentifier {
        static let area = "AreaTableViewCell"
    }
}
