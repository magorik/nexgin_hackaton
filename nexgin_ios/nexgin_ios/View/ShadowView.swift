//
//  ShadowView.swift
//  Vikids
//
//  Created by Георгий on 12/11/2018.
//  Copyright © 2018 Георгий. All rights reserved.
//

import UIKit

@IBDesignable
class ShadowView: UIView {
    private var shadowLayer = CAShapeLayer()
    
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            setShadow()
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return shadowLayer.shadowOffset
        }
        set {
            shadowLayer.shadowOffset = newValue
            setShadow()
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return shadowLayer.shadowOpacity
        }
        set {
            shadowLayer.shadowOpacity = newValue
            setShadow()
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return shadowLayer.shadowRadius
        }
        set {
            shadowLayer.shadowRadius = newValue
            setShadow()
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor = .black {
        didSet {
            setShadow()
        }
    }
    
    @IBInspectable
    var backColor: UIColor = .white {
        didSet {
            setShadow()
        }
    }
    
    private func setShadow() {
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shadowLayer.fillColor = backColor.cgColor
        
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
    }
    
    override var frame: CGRect {
        didSet {
            setShadow()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setShadow()
    }
    
    func commonInit() {
        layer.insertSublayer(shadowLayer, at: 0)
        layer.masksToBounds = true
        clipsToBounds = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

}
