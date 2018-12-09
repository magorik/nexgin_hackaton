//
//  SocketIOManager.swift
//  
//
//  Created by Георгий on 08/12/2018.
//

import SocketIO
import Starscream
import ObjectMapper
import SwiftyJSON

protocol SocketManagerProtocol {
    func didRecieveObjects(objects: [String: UserModel])
}

class SocketManager:WebSocketDelegate {
    
    var delegate: SocketManagerProtocol?
    
    func websocketDidConnect(socket: WebSocketClient) {
        let area = AreaObject(JSON: ["identifier": 1,
                                     "status": "ok:",
                                     "history": [true, false],
                                     "path": "1,2,2,2,4,2,1,2"])
        
        sendAreas(areas: [area!])
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        let rawData = text.data(using: .utf8)
        
        do {
            let parsedData = try JSONSerialization.jsonObject(with: rawData!) as! [String:Any]
            if let array = parsedData["message"] as? [String:[String: Any]] {
                let objects =  Mapper<UserModel>().mapDictionary(JSON: array)
                if let delegate = delegate {
                    delegate.didRecieveObjects(objects: objects!)
                }
            }

        } catch {
            
        }
    }
    
    
    func sendAreas(areas:[AreaObject]) {
        let json = ["message": areas.toJSON()]
        
        if let theJSONData = try?  JSONSerialization.data(
            withJSONObject: json,
            options: .prettyPrinted
            ),
            let theJSONText = String(data: theJSONData,
                                     encoding: String.Encoding.ascii) {
            sock.write(string: theJSONText)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
    static let shared = SocketManager()
    
    var sock:WebSocket!
    
    func connect() {
        let request = NSMutableURLRequest(url: URL(string:"ws://127.0.0.1:8000/ws/chat/George/")!)
        request.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: HTTPCookieStorage.shared.cookies!)
        sock = WebSocket.init(request: request as URLRequest)
        sock.delegate = self
        sock.connect()
    }
    
}
