//
//  Sock.swift
//  nexgin_ios
//
//  Created by Георгий on 07/04/2019.
//  Copyright © 2019 Георгий. All rights reserved.
//

import UIKit

class Sock: NSObject {

    static let shared = Sock()
    
    var inputStream: InputStream!
    let maxReadLength = 4096
    var readStream: Unmanaged<CFReadStream>?

    func connect() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            var readStream: Unmanaged<CFReadStream>?
            var writeStream: Unmanaged<CFWriteStream>?
            
            // 2
            CFStreamCreatePairWithSocketToHost(nil,
                                               "192.168.88.43" as CFString,
                                               5204,
                                               &readStream,
                                               &writeStream)
            
            self.inputStream = readStream!.takeUnretainedValue()
            self.inputStream.schedule(in: .current, forMode: .common)
            self.inputStream.delegate = self
            self.inputStream.open()
        }
        // 1
    }
}

extension Sock: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.hasBytesAvailable:
            readAvailableBytes(stream: aStream as! InputStream)
        case Stream.Event.endEncountered:
            print("new message received")
        case Stream.Event.errorOccurred:
            print("error occurred")
        case Stream.Event.hasSpaceAvailable:
            print("has space available")
        default:
            print("some other event...")
            break
        }
    }
    
    private func readAvailableBytes(stream: InputStream) {
        //1
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
        
        //2
        while stream.hasBytesAvailable {
            //3
            let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLength)
            
            //4
            if numberOfBytesRead < 0 {
                if let _ = stream.streamError {
                    break
                }
            }
            
            if let message = processedMessageString(buffer: buffer, length: numberOfBytesRead) {
                //Notify interested parties
                
            }
        }
    }
    
    private func processedMessageString(buffer: UnsafeMutablePointer<UInt8>,
                                        length: Int) -> String? {
        //1
        guard let stringArray = String(bytesNoCopy: buffer,
                                       length: length,
                                       encoding: .ascii,
                                       freeWhenDone: true) else {
                return nil
        }
        
        return stringArray
    }
}
