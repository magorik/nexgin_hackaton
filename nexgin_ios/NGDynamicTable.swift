//
//  NGDynamicTable.swift
//  nexgin_ios
//
//  Created by Георгий on 09/12/2018.
//  Copyright © 2018 Георгий. All rights reserved.
//

import UIKit

class NGDynamicTable: NSObject {
    @IBOutlet var tableView: UITableView!
    
    var data: [String: LiveUpdateModel]? {
        didSet {
            if oldValue == nil {
                tableView.reloadData()
            }
        }
    }
    
    func cellIdentifier() -> String { return "" }
    
    private var selectedIndexPath: IndexPath?
}

extension NGDynamicTable: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = data else {
            return 0
        }
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier()) as! UserTableViewCell
        
        if let data = data {
            cell.setupWith(user: data[String(indexPath.row)])
        }
        
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let data = data else {
            return
        }
        
        let cell = cell as! UserTableViewCell
        cell.model = data[String(indexPath.row)]
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = cell as! UserTableViewCell
        cell.model?.delegate = nil
        cell.model = nil
    }
}