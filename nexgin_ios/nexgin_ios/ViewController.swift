//
//  ViewController.swift
//  nexgin_ios
//
//  Created by Георгий on 08/12/2018.
//  Copyright © 2018 Георгий. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var userTableViewModel: UserTableViewModel!
    @IBOutlet var areaTableViewModel: AreaTableViewModel!

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var gridView: GridView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var images: [String: UIImageView] = [:]
    var areas: [AreaObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize.width = 1000
        scrollView.contentSize.height = 1000

        scrollView.minimumZoomScale = 0.5
        scrollView.minimumZoomScale = 1.0

        SocketManager.shared.delegate = self
        
        stratTimer()
    }
    
    func stratTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            let x = arc4random()%100 + 500
            let y = arc4random()%100 + 500
            
//            UIView.animate(withDuration: 0.3, animations: {
//
//                self.gridView.gridWidthMultiple = CGFloat(5 + arc4random()%10)
//                self.gridView.gridHeightMultiple = self.gridView.gridWidthMultiple
//                self.gridView.setNeedsDisplay()
//            })
        }.fire()
    }
    
    private func addImage(x: CGFloat, y: CGFloat, identifier: String, color: UIColor) {
        if let image = images[identifier] {
            UIView.animate(withDuration: 2.3, animations: {
                image.frame = CGRect(x: x , y: y , width: 20, height: 20)
            })
        } else {
            let image = UIImageView(frame: CGRect(x: x, y: y, width: 20, height: 20))
            image.layer.cornerRadius = 10
            image.clipsToBounds = false
            image.backgroundColor = color
            
            images[identifier] = image
            scrollView.addSubview(image)
        }
    }
    
    @IBAction func didTouchOnScroll(_ sender: Any) {
        guard let sender = sender as? UIGestureRecognizer else {
            return
        }

            let point = sender.location(in: sender.view)
            
            print(point.x)
            // again, point.x and point.y have the coordinates
        let width:CGFloat = 200.0
        let view = UIView(frame: CGRect(x: point.x - CGFloat(width/2), y: point.y - CGFloat(width/2), width: width, height: width))
        view.clipsToBounds = false
        view.layer.cornerRadius = width/2
        view.backgroundColor = .lightGray
        view.alpha = 0.3

        scrollView.addSubview(view)
        scrollView.sendSubviewToBack(view)
    }
    @IBAction func reconnect(_ sender: Any) {
        SocketManager.shared.connect()
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

extension ViewController: SocketManagerProtocol {
    func didRecieveObjects(objects: [String: UserModel]) {        
        if userTableViewModel.data == nil {
           userTableViewModel.data = objects
        } else {
            for (key, value) in objects {
                if let existingObject = userTableViewModel.data?[key] as? UserModel {
                    existingObject.x = value.x
                    existingObject.y = value.y
                    existingObject.delegate?.dataUpdated()
                    
                    addImage(x: CGFloat(Float(value.x!)!), y: CGFloat(Float(value.y!)!), identifier: value.identifier!, color: (existingObject.color)!)
                }
            }
        }
    }
}

class GridView: UIView
{
    private var path = UIBezierPath()
    var gridWidthMultiple: CGFloat = 20
    var gridHeightMultiple : CGFloat = 20
    
    fileprivate var gridWidth: CGFloat
    {
        return bounds.width/CGFloat(gridWidthMultiple)
    }
    
    fileprivate var gridHeight: CGFloat
    {
        return bounds.height/CGFloat(gridHeightMultiple)
    }
    
    fileprivate var gridCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    fileprivate func drawGrid()
    {
        path = UIBezierPath()
        path.lineWidth = 1.0
        
        for index in 1...Int(gridWidthMultiple) - 1
        {
            let start = CGPoint(x: CGFloat(index) * gridWidth, y: 0)
            let end = CGPoint(x: CGFloat(index) * gridWidth, y:bounds.height)
            path.move(to: start)
            path.addLine(to: end)
        }
        
        for index in 1...Int(gridHeightMultiple) - 1
        {
            let start = CGPoint(x: 0, y: CGFloat(index) * gridHeight)
            let end = CGPoint(x: bounds.width, y: CGFloat(index) * gridHeight)
            path.move(to: start)
            path.addLine(to: end)
        }
        
        //Close the path.
        path.close()
    }
    
    override func draw(_ rect: CGRect)
    {
        drawGrid()
        
        // Specify a border (stroke) color.
        UIColor.lightGray.setStroke()
        path.stroke()
    }
}

