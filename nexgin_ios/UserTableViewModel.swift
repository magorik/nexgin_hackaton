//
//  UserTableViewModel.swift
//  nexgin_ios
//
//  Created by Георгий on 08/12/2018.
//  Copyright © 2018 Георгий. All rights reserved.
//

import UIKit

class UserTableViewModel: NSObject {

    // MARK: Private Properties
    
    private struct CellIdentifier {
        static let user = "UserTableViewCell"
    }
    
    private var selectedIndexPath: IndexPath?
}

extension UserTableViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.user) as! UserTableViewCell
        cell.setupWith(user: nil, index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
