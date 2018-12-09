//
//  UserTableViewCell.swift
//  nexgin_ios
//
//  Created by Георгий on 08/12/2018.
//  Copyright © 2018 Георгий. All rights reserved.
//

import UIKit

extension LiveUpdateCell: LiveUpdateModelDelegate {
    func dataUpdated() {
        setupWith(user: model)
    }
}

class LiveUpdateCell: UITableViewCell {
    var model: LiveUpdateModel?

    func setupWith(user: LiveUpdateModel?) {}
}


class UserTableViewCell: LiveUpdateCell {

    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var gradientView: RoundViewWithGradient!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var clasterIndicatorView: UIView!
    @IBOutlet weak var areaIndicatorView: UIView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clasterIndicatorView.layer.borderWidth = 1
        areaIndicatorView.layer.borderWidth = 1
        
        clasterIndicatorView.layer.cornerRadius = 8
        areaIndicatorView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        setStateFor(selected: selected)
    }
    
    override func setupWith(user: LiveUpdateModel?) {
        guard let user = user as? UserModel else {
            return
        }
        model = user
        model?.delegate = self
        userNameLabel.text = user.identifier
        
        clasterIndicatorView.backgroundColor = user.color
        xLabel.text = "x: " + user.x!
        yLabel.text = "y: " + user.y!
        
        areaIndicatorView.isHidden = user.hidden
    }
    
    private func setStateFor(selected: Bool) {
        gradientView.isHidden = !selected
                        
        if selected {
            clasterIndicatorView.layer.borderColor = UIColor.white.cgColor
            areaIndicatorView.layer.borderColor = UIColor.white.cgColor
        } else {
            clasterIndicatorView.layer.borderColor = UIColor.clear.cgColor
            areaIndicatorView.layer.borderColor = UIColor.clear.cgColor
        }
        
        let color = selected ? .white : UIColor.hexStringToUIColor(hex: "1F2124")
        
        userNameLabel.textColor = color
        infoButton.tintColor = color
        xLabel.textColor = color
        yLabel.textColor = color
        
        shadowView.shadowColor = selected ? UIColor.hexStringToUIColor(hex: "8463C8") : UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
    }
}
