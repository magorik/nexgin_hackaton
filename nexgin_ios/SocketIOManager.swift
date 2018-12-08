//
//  SocketIOManager.swift
//  
//
//  Created by Георгий on 08/12/2018.
//

import SocketIO
import Starscream

class SocketManager:WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
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
