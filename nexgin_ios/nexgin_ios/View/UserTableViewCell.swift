//
//  UserTableViewCell.swift
//  nexgin_ios
//
//  Created by Георгий on 08/12/2018.
//  Copyright © 2018 Георгий. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var gradientView: RoundViewWithGradient!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var clasterIndicatorView: UIView!
    @IBOutlet weak var areaIndicatorView: UIView!
    @IBOutlet weak var infoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clasterIndicatorView.layer.borderWidth = 1
        areaIndicatorView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        setStateFor(selected: selected)
    }
    
    func setupWith(user: UserModel?, index: Int) {
        userNameLabel.text = "Пользователь #" + String(index)
    }
    
    private func setStateFor(selected: Bool) {
        gradientView.isHidden = !selected
                        
        if selected {
            clasterIndicatorView.layer.borderColor = UIColor.white.cgColor
            areaIndicatorView.layer.borderColor = UIColor.white.cgColor
        } else {
            clasterIndicatorView.layer.borderColor = UIColor.black.cgColor
            areaIndicatorView.layer.borderColor = UIColor.black.cgColor
        }
        
        let color = selected ? .white : UIColor.hexStringToUIColor(hex: "1F2124")
        
        userNameLabel.textColor = color
        infoButton.tintColor = color
        
        shadowView.shadowColor = selected ? UIColor.hexStringToUIColor(hex: "8463C8") : UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    }
}
