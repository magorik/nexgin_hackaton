//
//  ViewController.swift
//  nexgin_ios
//
//  Created by Георгий on 08/12/2018.
//  Copyright © 2018 Георгий. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var gridView: GridView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    let image = UIView(frame: CGRect(x: 10, y: 300, width: 20, height: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        image.layer.cornerRadius = 10
        image.clipsToBounds = false
        image.backgroundColor = .green
        
        scrollView.contentSize.width = 1000
        scrollView.addSubview(image)
        
        stratTimer()
    }
    
    func stratTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            let x = arc4random()%100 + 500
            let y = arc4random()%100 + 500
            
            UIView.animate(withDuration: 0.3, animations: {
                self.image.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: 20, height: 20)
                self.gridView.gridWidthMultiple = CGFloat(5 + arc4random()%10)
                self.gridView.gridHeightMultiple = self.gridView.gridWidthMultiple
                self.gridView.setNeedsDisplay()
    
            })
        }.fire()
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

