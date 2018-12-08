//
//  AreaTableViewModel.swift
//  nexgin_ios
//
//  Created by Георгий on 08/12/2018.
//  Copyright © 2018 Георгий. All rights reserved.
//

import UIKit

class AreaTableViewModel: NSObject {
    
    struct CellIdentifier {
        static let area = "AreaTableViewCell"
    }
    
    private var selectedIndexPath: IndexPath?
}

extension AreaTableViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.area) as! AreaTableViewCell
        
        cell.setupWith(user: nil, index: indexPath.row)
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let selectedIndexPath = selectedIndexPath, indexPath.row == selectedIndexPath.row {
            return UITableView.automaticDimension
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        //UIView.animate(withDuration: 0.3) {
            tableView.cellForRow(at: indexPath)!.contentView.layoutIfNeeded()
            tableView.beginUpdates()
            tableView.endUpdates()
        //}
    }
    
}
