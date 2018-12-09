//
//  AreaTableViewCell.swift
//  nexgin_ios
//
//  Created by Георгий on 08/12/2018.
//  Copyright © 2018 Георгий. All rights reserved.
//

import UIKit

class AreaTableViewCell: LiveUpdateCell {

    @IBOutlet weak var contView: ShadowView!
    @IBOutlet weak var gradientView: RoundViewWithGradient!
    @IBOutlet weak var areaNameLabel: UILabel!
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var distanceStackView: UIStackView!
    @IBOutlet weak var distanceTextField: HoshiTextField!
    
    @IBOutlet weak var areaColorView: RoundViewWithGradient!
    @IBOutlet weak var infoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        setStateFor(selected: selected)
    }
    
    override func setupWith(user: LiveUpdateModel?) {
        guard let user = user as? AreaObject else {
            return
        }
        
        model = user
        model?.delegate = self
        areaNameLabel.text = "Область #" + String(user.identifier!)
        areaColorView.backgroundColor = .green
        countLabel.text = String(user.personCount)
        if user.personCount > 15 {
            contView.backColor = .red
            let color = UIColor.white
            
            areaNameLabel.textColor = color
            infoButton.tintColor = color
            userLabel.textColor = color
            countLabel.textColor = color
        } else if !isSelected {
            contView.backColor = .white
            let color = UIColor.hexStringToUIColor(hex: "1F2124")
            
            areaNameLabel.textColor = color
            infoButton.tintColor = color
            userLabel.textColor = color
            countLabel.textColor = color
        }
    }
    
    private func setStateFor(selected: Bool) {
        gradientView.isHidden = !selected
        
        let color = selected ? .white : UIColor.hexStringToUIColor(hex: "1F2124")
        
        areaNameLabel.textColor = color
        infoButton.tintColor = color
        userLabel.textColor = color
        countLabel.textColor = color
        //distancaLabel.textColor = color
        //distanceTextField.textColor = color
        
//        if !selected {
//            distanceTextField.borderActiveColor = .purple
//            distanceTextField.borderInactiveColor = .darkGray
//        } else {
//            distanceTextField.borderActiveColor = .white
//            distanceTextField.borderInactiveColor = .darkGray
//        }
    }
}
