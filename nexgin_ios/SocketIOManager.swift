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
