//
//  SocketManager.swift
//  Hallo
//
//  Created by Dreamup on 7/19/17.
//  Copyright © 2017 Dreamup. All rights reserved.
//

import UIKit
import SocketIO

protocol SIOConnectionDelegate : class {
    func didConnect()
    func didDisConnect()
}

protocol SIOSockMessageDelegate : class {
    func didReceiveMessage()
}

class SocketManager: NSObject {

    static let sharedInstance : SocketManager = {
        let instance = SocketManager()
        return instance
    }()

    weak var connectionDelegate:SIOConnectionDelegate?
    weak var messageDelegate:SIOSockMessageDelegate?
    
    var nickName = ""
    let socket = SocketIOClient(socketURL: NSURL(string: "http://192.168.0.120:8080")!, config: nil)
    
    override init() {
        super.init()
        
        socket.on("userConnectUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: dataArray[0], userInfo: nil)
        }
        
        socket.on("userExitUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: dataArray[0] as! String, userInfo: nil)
        }
        
        socket.on("userTypingUpdate") { (dataArray, socketAck) -> Void in
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userTypingNotification"), object: dataArray[0] as? [String: AnyObject], userInfo: nil)
        }
        
        socket.on("SomeMessage") { ( dataArray, ack) -> Void in
            
        }
        
    }

    
    //MARK : CONNECTION
    func connectToServerWithNickname(nickname: String, completionHandler: @escaping (_ userList: [[String: AnyObject]]?) -> Void) {
        nickName = nickname
        socket.on("userList") { ( dataArray, ack) -> Void in
            completionHandler(dataArray[0] as? [[String: AnyObject]])
        }
        socket.emit("connectUser", nickname)

    }
    
    func exitChatWithNickname(completionHandler: () -> Void) {
        socket.emit("exitUser", nickName)
        completionHandler()
    }
    
    func establishConnection() {
        socket.on("connect", callback: {
            data,ack in
            self.connectionDelegate?.didConnect()
            print("socket connected")
        })
        
        socket.on("disconnect", callback: {
            data,ack in
            self.connectionDelegate?.didDisConnect()
            print("socket connected")
        })
        
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    //MARK: MESSAGING
    func sendMessage(message: String) {
        socket.emit("chatMessage", nickName, message)
    }
    
    
    func loadOldMessage(completionHandler: @escaping (_ messageInfo: [String: String]) -> Void) {
        socket.on("newChatMessage") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: String]()
            messageDictionary["nickname"] = dataArray[0] as? String
            messageDictionary["message"] = dataArray[1] as? String
            messageDictionary["date"] = dataArray[2] as? String
            
            completionHandler(messageDictionary)
        }
    }
    
    
}
