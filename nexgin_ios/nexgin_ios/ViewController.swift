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
    var areaViews: [UIView] = []
    var userSelectedIndex: IndexPath?
    var areaSelectedIndex: IndexPath?
    
    var areaSelectedView: UIView?

    var colors: [UIColor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        scrollView.contentSize.width = 1000
        scrollView.contentSize.height = 1000
        
        colors.append(UIColor.hexStringToUIColor(hex: "ef5350"))
        colors.append(UIColor.hexStringToUIColor(hex: "f57f17"))
        colors.append(UIColor.hexStringToUIColor(hex: "c63f17"))
        colors.append(UIColor.hexStringToUIColor(hex: "5d4037"))
        colors.append(UIColor.hexStringToUIColor(hex: "ec407a"))
        colors.append(UIColor.hexStringToUIColor(hex: "ab47bc"))
        colors.append(UIColor.hexStringToUIColor(hex: "7e57c2"))
        colors.append(UIColor.hexStringToUIColor(hex: "5c6bc0"))
        colors.append(UIColor.hexStringToUIColor(hex: "42a5f5"))
        colors.append(UIColor.hexStringToUIColor(hex: "29b6f6"))
        colors.append(UIColor.hexStringToUIColor(hex: "6ff9ff"))
        colors.append(UIColor.hexStringToUIColor(hex: "64d8cb"))
        colors.append(UIColor.hexStringToUIColor(hex: "ffff89"))
        colors.append(UIColor.hexStringToUIColor(hex: "ffa726"))
        colors.append(UIColor.hexStringToUIColor(hex: "a7c0cd"))
        
        areaTableViewModel.data = [:]
                
        SocketManager.shared.delegate = self
        userTableViewModel.delegate = self
        areaTableViewModel.delegate = self
        
        startTimer()
    }

    
    private func addImage(x: CGFloat, y: CGFloat, identifier: String, color: UIColor) {
        if let image = images[identifier], let label = labels[identifier] {
           UIView.animate(withDuration: 1.9, animations: {
                image.frame = CGRect(x: x , y: y , width: 20, height: 20)
                label.frame  = CGRect(x: x , y: y , width: 20, height: 20)
            
                image.backgroundColor = color
           })
            

            if let selectedIndex = userSelectedIndex {
                if identifier == String(selectedIndex.row) {
                    image.alpha = 1
                } else {
                    image.alpha = 0
                }
            } else {
                image.alpha = 1
            }
            
            label.alpha = image.alpha
        } else {
            let image = UIView(frame: CGRect(x: x, y: y, width: 20, height: 20))
            image.layer.cornerRadius = 10
            image.clipsToBounds = false
            image.backgroundColor = color
            
            
            let label = UILabel(frame: image.frame)
            label.text = identifier
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 7, weight: .semibold)
            label.textAlignment = .center
            
            labels[identifier] = label
            images[identifier] = image
            scrollView.addSubview(image)
            scrollView.addSubview(label)

        }
    }
    
    @IBAction func changeTransform(_ sender: UISlider) {
        if let image = areaSelectedView {
            UIView.animate(withDuration: 0.0) {
                image.transform = CGAffineTransform(scaleX: CGFloat(1 + sender.value/2), y:  CGFloat(1 + sender.value/2))
            }
        }
    }
    
    @IBAction func didTouchOnScroll(_ sender: Any) {
        guard let sender = sender as? UIGestureRecognizer else {
            return
        }

            let point = sender.location(in: sender.view)

        let width:CGFloat = 200.0
        let view = NGView(frame: CGRect(x: point.x - CGFloat(width/2), y: point.y - CGFloat(width/2), width: width, height: width))
        view.clipsToBounds = false
        //view.layer.cornerRadius = width/2
        //view.image = UIImage(named: "area")
        view.alpha = 0.6
        
        view.backgroundColor = .clear
        
        let borderLayer = CAShapeLayer.init()
        borderLayer.lineWidth = 2.0
        borderLayer.fillColor = UIColor.green.cgColor
        borderLayer.strokeColor = UIColor.gray.cgColor
        borderLayer.backgroundColor = UIColor.blue.cgColor
        borderLayer.lineDashPattern = [6, 4]
        borderLayer.frame = view.bounds
        borderLayer.path = UIBezierPath.init(rect: view.bounds).cgPath
        
        view.layer.addSublayer(borderLayer)
        
        var pointg = view.center
        areaViews.append(view)
        let path = "\(pointg.x),\(pointg.y),\(pointg.x ),\(pointg.y + width),\(pointg.x + width),\(pointg.y + width),\(pointg.x + width),\(pointg.y)"
        let area = AreaObject(JSON: ["identifier": areaViews.count - 1,
                                     "status": "ok:",
                                     "path": path])
        
        area?.view = view
        view.aera = area
        areas.append(area!)
        
        SocketManager.shared.sendAreas(areas: areas)
        scrollView.addSubview(view)
        scrollView.sendSubviewToBack(view)
        
        areaTableViewModel.data[String(areaViews.count - 1)] = area
        areaTableViewModel.tableView.reloadData()
        
        didRecieveObjects(objects: userTableViewModel.data as! [String : UserModel])
    }
    
    var deidef = false {
        didSet {
            userSelectedIndex = deidef ? IndexPath(row: 100000, section: 10) : nil
        }
    }
    
    @IBAction func changeDeidentification(_ sender: Any) {
        deidef = !deidef
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.navigationBar.barTintColor = self.deidef ? .red : .white
            self.navigationController?.navigationBar.tintColor = self.deidef ? .white : .black
            self.navigationController?.navigationBar.titleTextAttributes = self.deidef ? [.foregroundColor: UIColor.white] : [.foregroundColor: UIColor.black]

        }
        
        didRecieveObjects(objects: userTableViewModel.data as! [String : UserModel])
    }
    
    @IBAction func removeView(_ sender: Any) {
        guard let sender = sender as? UIGestureRecognizer else {
            return
        }

        let point = sender.location(in: sender.view)
        let view = scrollView.hitTest(point, with: nil)
        if let view = view as? NGView, areaViews.contains(view) {
            view.removeFromSuperview()
            
            let index = areaViews.firstIndex(of: view)!
            
            areaTableViewModel.data[String(view.aera!.identifier!)] = nil
            
            areaTableViewModel.tableView.reloadData()
            
            areaViews.remove(at: index)
            areas.remove(at: areas.firstIndex(where: {$0.identifier == view.aera!.identifier})!)
            
            SocketManager.shared.sendAreas(areas: areas)
            
            
        }
    }
    
    @IBAction func reconnect(_ sender: Any) {
        SocketManager.shared.connect()
    }
    
    private var timerTick = 0
    private var timer: Timer?

    private func startTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    var startDate = Date()
    
    @objc private func updateTime() {
        timerTick += 1
        
        let difference = Date().timeIntervalSince(startDate)
        
        let date = Date(timeIntervalSince1970: Double(difference))
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "HH:mm:ss"
        
        let dateString = formatter.string(from: date)
        
        timerLabel.text = dateString
        
    }
}

extension ViewController: UserTableViewModelDelegate {
    func didSelected(indexptah: IndexPath?) {
        if var selectedIndex = userSelectedIndex, let indexptah = indexptah, selectedIndex.row == indexptah.row {
            self.userSelectedIndex = nil
        } else {
            userSelectedIndex = indexptah
        }
        
        didRecieveObjects(objects: userTableViewModel.data as! [String : UserModel])
    }
}

extension ViewController: AreaTableViewModelDelegate {
    func didSelect(indexptah: IndexPath?) {
        if indexptah == nil {
            self.areaSelectedIndex = nil
            areaSelectedView = nil
            //_ = areaViews.map({$0.alpha = 0.3})
        } else {
            areaSelectedIndex = indexptah
            
            let view = areaViews[(indexptah?.row)!]
            scrollView.setContentOffset(CGPoint(x: view.center.x - 1.8*view.frame.width, y: view.center.y - view.frame.height * 1.6), animated: true)//scrollRectToVisible(view.frame, animated: true)
            areaSelectedView = view
            
            //_ = areaViews.filter({$0 != view}).map({$0.alpha = 0})
        }
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

class NGView: UIView {
    var aera: AreaObject?
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
        if userTableViewModel.data.count == 0 {
           userTableViewModel.data = objects
            
           userTableViewModel.tableView.reloadData()
        } else {
            _ = areas.map({$0.personCount = 0})
            
            for (key, value) in objects {
                if let existingObject = userTableViewModel.data[key] as? UserModel {
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
                            if !existingObject.hidden {
                                area.personCount += 1
                            }
                            
                            area.delegate?.dataUpdated()
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

