//
//  ViewController.swift
//  nexgin_ios
//
//  Created by Георгий on 08/12/2018.
//  Copyright © 2018 Георгий. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var oneTouches: UITapGestureRecognizer!
    @IBOutlet var doubleTouches: UITapGestureRecognizer!
    @IBOutlet var userTableViewModel: UserTableViewModel!
    @IBOutlet var areaTableViewModel: AreaTableViewModel!

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var gridView: GridView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    var images: [String: UIView] = [:]
    var labels: [String: UILabel] = [:]

    var areas: [AreaObject] = []
    var areaViews: [UIImageView] = []
    var selectedIndex: IndexPath?
    
    var colors: [UIColor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize.width = 1000
        scrollView.contentSize.height = 1000
        
        _ = (0...14).map({
            $0.description
            colors.append(.random())
        })

        SocketManager.shared.delegate = self
        userTableViewModel.delegate = self
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
        if let image = images[identifier], let label = labels[identifier] {
           UIView.animate(withDuration: 1.9, animations: {
                image.frame = CGRect(x: x , y: y , width: 20, height: 20)
                label.frame  = CGRect(x: x , y: y , width: 20, height: 20)
            
                image.backgroundColor = color
           })
            

            if let selectedIndex = selectedIndex {
                if identifier == String(selectedIndex.row) {
                    image.alpha = 1
                } else {
                    image.alpha = 0
                }
            } else {
                image.alpha = 1
            }
        } else {
            let image = UIView(frame: CGRect(x: x, y: y, width: 20, height: 20))
            image.layer.cornerRadius = 10
            image.clipsToBounds = false
            image.backgroundColor = color
            
            
            let label = UILabel(frame: image.frame)
            label.text = identifier
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
            label.textAlignment = .center
            
            labels[identifier] = label
            images[identifier] = image
            scrollView.addSubview(image)
            scrollView.addSubview(label)

        }
    }
    
    @IBAction func didTouchOnScroll(_ sender: Any) {
        guard let sender = sender as? UIGestureRecognizer else {
            return
        }

            let point = sender.location(in: sender.view)

        let width:CGFloat = 200.0
        let view = UIImageView(frame: CGRect(x: point.x - CGFloat(width/2), y: point.y - CGFloat(width/2), width: width, height: width))
        view.clipsToBounds = false
        view.layer.cornerRadius = width/2
        view.image = UIImage(named: "area")
        view.alpha = 0.6
        view.contentMode = .scaleAspectFit
        
        var pointg = view.center
        
        let path = "\(pointg.x),\(pointg.y),\(pointg.x ),\(pointg.y + width),\(pointg.x + width),\(pointg.y + width),\(pointg.x + width),\(pointg.y)"
        let area = AreaObject(JSON: ["identifier": areaViews.count,
                                     "status": "ok:",
                                     "path": path])
        area?.view = view
        areas.append(area!)
        areaViews.append(view)
        
        SocketManager.shared.sendAreas(areas: areas)
        scrollView.addSubview(view)
        scrollView.sendSubviewToBack(view)
        
        didRecieveObjects(objects: userTableViewModel.data! as! [String : UserModel])
        
        
        areaTableViewModel.data
    }
    
    @IBAction func removeView(_ sender: Any) {
        guard let sender = sender as? UIGestureRecognizer else {
            return
        }

        let point = sender.location(in: sender.view)
        let view = scrollView.hitTest(point, with: nil)
        if let view = view, areaViews.contains(view as! UIImageView) {
            view.removeFromSuperview()
            
            let index = areaViews.firstIndex(of: view as! UIImageView)!
            areaViews.remove(at: index)
            areas.remove(at: index)
            SocketManager.shared.sendAreas(areas: areas)
        }
    }
    
    @IBAction func reconnect(_ sender: Any) {
        SocketManager.shared.connect()
    }
}

extension ViewController: UserTableViewModelDelegate {
    func didSelected(indexptah: IndexPath?) {
        if var selectedIndex = selectedIndex, let indexptah = indexptah, selectedIndex.row == indexptah.row {
            self.selectedIndex = nil
        } else {
            selectedIndex = indexptah
        }
        
        didRecieveObjects(objects: userTableViewModel.data! as! [String : UserModel])
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Don't recognize a single tap until a double-tap fails.
        if gestureRecognizer == self.oneTouches &&
            otherGestureRecognizer == self.doubleTouches {
            return true
        }
        return false
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
                    existingObject.areas = value.areas
                    
                    
                    if let color = value.means {
                        existingObject.color = colors[Int(color)!]
                    }
                    
                    for area in areas {
                        if let image = images[existingObject.identifier!] {
                            //let frame = area.view!.convert(area.view!.frame, to: self.scrollView)
                            //let point = image.convert(image.frame.origin, to: self.scrollView)
                            
                            
                            existingObject.hidden = !area.view!.frame.contains(image.center)
                        }
                    }
                    
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

