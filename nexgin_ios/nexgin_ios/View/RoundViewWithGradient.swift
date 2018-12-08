//
//  View.swift
//  Vikids
//
//  Created by Георгий on 12/11/2018.
//  Copyright © 2018 Георгий. All rights reserved.
//

import UIKit

@IBDesignable
class RoundViewWithGradient: UIView {

    private var shadowLayer = CAShapeLayer()

    // MARK: IBInspectable Properties
    
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            setCorner()
        }
    }
    
    @IBInspectable
    var firstColor: UIColor = .white {
        didSet {
            setGradientBackground()
        }
    }
    
    @IBInspectable
    var secondColor: UIColor = .white {
        didSet {
            setGradientBackground()
        }
    }
    
    @IBInspectable
    var firstPoint: CGPoint = .zero {
        didSet {
            setGradientBackground()
        }
    }
    
    @IBInspectable
    var secondPoint: CGPoint = .zero {
        didSet {
            setGradientBackground()
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
    
    override var frame: CGRect {
        didSet {
            setCorner()
            setGradientBackground()
            setShadow()
        }
    }
    
    override var transform: CGAffineTransform {
        didSet {
            setCorner()
            setGradientBackground()
            setShadow()
        }
    }
    
    fileprivate var gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //if let layers = layer.sublayers, layers.contains(gradientLayer) == false {
        layer.insertSublayer(gradientLayer, at: 0)
        //}
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setCorner()
        setGradientBackground()
        setShadow()
    }
    
    func commonInit() {
        layer.insertSublayer(shadowLayer, at: 0)
        layer.masksToBounds = true
        clipsToBounds = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.insertSublayer(gradientLayer, at: 0)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.insertSublayer(gradientLayer, at: 0)
        commonInit()
    }
}

// MARK: Private Methods

private extension RoundViewWithGradient {
    @objc func setCorner() {
        let rectPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight] , cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        let mask = CAShapeLayer()
        mask.frame = bounds
        mask.path = rectPath.cgPath
        
        layer.mask = mask
    }
    
    @objc func setGradientBackground() {
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.startPoint = firstPoint
        gradientLayer.endPoint = secondPoint
        
        
        //UIView.animate(withDuration: 0.3) {
        CATransaction.begin()
        CATransaction.setDisableActions(false)

            self.gradientLayer.frame = self.bounds
        CATransaction.commit()

        //}
        //resizeLayer(layer: gradientLayer, newSize: bounds.size)
        gradientLayer.locations = [0, 1]
    }
    
    func resizeLayer(layer:CALayer, newSize: CGSize) {
        
        let oldBounds = layer.bounds;
        var newBounds = oldBounds;
        newBounds.size = newSize;
        
        
        //Ensure at the end of animation, you have proper bounds
        layer.frame = newBounds
        
        let boundsAnimation = CABasicAnimation(keyPath: "frame")
        boundsAnimation.fromValue = NSValue(cgRect: oldBounds)
        boundsAnimation.toValue = NSValue(cgRect: newBounds)
        boundsAnimation.duration = 3
        layer.add(boundsAnimation, forKey: "frame")
    }
    
    private func setShadow() {
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shadowLayer.fillColor = UIColor.clear.cgColor
        
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
    }
}

@IBDesignable
class PlaceholderView: RoundViewWithGradient {
    
    @IBOutlet weak var post: UILabel?
    @IBOutlet weak var blog: UILabel?

    var selectedIndex: Int = 0
    var acceptedSelectedIndex: Int = 0

//    var xPosition: CGFloat = 0.0 {
//        didSet {
//            if xPosition != 0.0 {
//                var flag = true
//                if selectedIndex {
//                    if xPosition.sign == oldValue.sign {
//                        flag = false
//                    } else {
//                        selectedIndex = false
//                    }
//                }
//
//                if flag {
//                    if xPosition > 0 && !selectedIndex {
//                        gradientLayer.frame = CGRect(x: xPosition * bounds.width/2, y: 0, width: bounds.width/2, height: bounds.height)
//                        
//                    } else if xPosition < 0 && selectedIndex {
//                        gradientLayer.frame = CGRect(x: bounds.width/2 + xPosition * bounds.width/2, y: 0, width: bounds.width/2, height: bounds.height)
//                    }
//                }
//            } else {
//                selectedIndex = true
//            }
//            
//            layoutSubviews()
//        }
//    }
    
    override func setCorner() {
        let rectPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight, .bottomLeft, .bottomRight] , cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        
        let mask = CAShapeLayer()
        
        mask.frame = CGRect(x: 0, y: 0, width: bounds.width/2, height: bounds.height)
        
        mask.path = rectPath.cgPath
        
        layer.mask = mask
    }
    
    override func setGradientBackground() {
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.startPoint = firstPoint
        gradientLayer.endPoint = secondPoint
        if selectedIndex == 1 {
            gradientLayer.frame = CGRect(x: bounds.width/2, y: 0, width: bounds.width/2, height: bounds.height)
            blog?.textColor = .black
            post?.textColor = .white
        } else {
            gradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.width/2, height: bounds.height)
            post?.textColor = .black
            blog?.textColor = .white
        }
        gradientLayer.locations = [0, 1]
    }
    
    func choosePost() {
        UIView.animate(withDuration: 0.3) {
            self.selectedIndex = 0
            self.layoutSubviews()
        }
    }
    
    func chooseBlog() {
        UIView.animate(withDuration: 0.3) {
            self.selectedIndex = 1
            self.layoutSubviews()
        }
    }
}
