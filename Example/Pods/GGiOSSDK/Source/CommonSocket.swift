//
//  CommonSocket.swift
//  ChinaTravelsSwift
//
//  Created by WebMazix Pro1 on 27/12/18.
//  Copyright © 2018 WebMazix Pro1. All rights reserved.
//

import UIKit
import SocketIO

class CommonSocket: NSObject {

    static let shared = CommonSocket()
    var socket = SocketIOClient(socketURL: URL(string: kGeneralBaseUrl)!, config: [.log(false), .compress])
    
    //MARK:- INIT
    func initSocket(completion: @escaping(Bool) -> Void) {
        
        self.socket.on(GroupNotif.kFriendAdded.rawValue) { (resp, emitter) in

            print("new friend added")
            print(resp)
            NotificationCenter.default.post(name: NSNotification.Name("new_friend_added"), object: self, userInfo: ["data": resp])
        }

        self.socket.on(GeneralChat.gotMsg.rawValue) { (resp, emitter) in
            
            print("did get general message")
            print(resp)
            NotificationCenter.default.post(name: NSNotification.Name("new_general_msg"), object: self, userInfo: ["data": resp])
        }
        
        self.socket.on(GroupNotif.kMsgReceived.rawValue) { (resp, emitter) in
            
            print("did get group message")
            print(resp)
            NotificationCenter.default.post(name: NSNotification.Name("new_group_msg"), object: self, userInfo: ["data": resp])
        }
        
        self.socket.on(RecentChat.kNewMsg.rawValue) { (resp, emitter) in
            
            print("did get single message")
            print(resp)
            NotificationCenter.default.post(name: NSNotification.Name("new_single_msg"), object: self, userInfo: ["data": resp])
        }
        
        
        self.socket.on("socketEvent") { (data, ark) in
            print("socketEvent inside \(data)")
            guard let dataFromString = (data[0] as? [String:Any]) else {return}
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dataFromString, options: .init(rawValue: 0))
                let model = try JSONDecoder().decode(SocketModelData.self, from: jsonData)
                
                if GlobalValues.sharedInstance.isLoginData == true {
                    NotificationCenter.default.post(name: NSNotification.Name("FeedSocketEvent"), object: self, userInfo: ["data": model])
                    
                } else {
                    NotificationCenter.default.post(name: NSNotification.Name("FeedSocketEvent"), object: self, userInfo: ["data": model])
                }
            } catch let err {
                NotificationCenter.default.post(name: NSNotification.Name("FeedSocketEvent"), object: self, userInfo: ["message": err.localizedDescription])
            }
        }
        
        
        self.socket.on(clientEvent: .connect) {data, ack in
            if ack.expected {
                print("connect inside \(data) ack")
            }else{
                print("connect inside without ack \(data) ")
            }
            completion(true)
        }
        
        
        self.socket.on(clientEvent: .reconnect) {data, ack in
            if ack.expected {
                print("reconnect inside \(data) ack")
            }else{
                print("reconnect inside without ack \(data) ")
            }
        }
        if self.socket.status == .disconnected || self.socket.status == .notConnected{
            self.socket.connect()
        }
    }
    
    //MARK:- CHECK CONNECTED
    func isConnected() -> Bool{
        if socket.status == .connected{
            return true
        }
        return false
    }

    //MARK:- CHECK DISCONNECTED
    func disConnect() {
        socket.disconnect()
        socket = SocketIOClient(socketURL: URL(string: kGeneralBaseUrl)!, config: [.log(false), .compress])
    }
    func onRecieveGeneralMsg(completion: @escaping([Any]) -> Void) {
        self.socket.on(GeneralChat.gotMsg.rawValue) { (resp, emitter) in
            
            print(resp)
            completion(resp)
        }
    }

    func onChangeGroupName(completion: @escaping([String:AnyObject]) -> Void) {
        self.socket.on(GroupNotif.kNameChanged.rawValue) { (resp, emitter) in
            print(resp)
            if let t = resp[0] as? [String:AnyObject]{
                completion(t)
            }
        }
    }
    func onImageChanged(completion: @escaping([String:AnyObject]) -> Void) {
        self.socket.on(GroupNotif.kImageChanged.rawValue) { (resp, emitter) in
            print(resp)
            if let t = resp[0] as? [String:AnyObject]{
                completion(t)
            }
        }
    }
    func onMakeAdmin(completion: @escaping([String:AnyObject]) -> Void) {
        self.socket.on(GroupNotif.kMakeAdmin.rawValue) { (resp, emitter) in
            print(resp)
            if let t = resp[0] as? [String:AnyObject]{
                completion(t)
            }
        }
    }
    func onRemovedAdmin(completion: @escaping([String:AnyObject]) -> Void) {
        self.socket.on(GroupNotif.kRemovedAdmin.rawValue) { (resp, emitter) in
            print(resp)
            if let t = resp[0] as? [String:AnyObject]{
                completion(t)
            }
        }
    }
    func onUserLeft(completion: @escaping([String:AnyObject]) -> Void) {
        self.socket.on(GroupNotif.kUserLeft.rawValue) { (resp, emitter) in
            print(resp)
            if let t = resp[0] as? [String:AnyObject]{
                completion(t)
            }
        }
    }
    func onRemoveUser(completion: @escaping([String:AnyObject]) -> Void) {
        self.socket.on(GroupNotif.kRemoveUser.rawValue) { (resp, emitter) in
            print(resp)
            if let t = resp[0] as? [String:AnyObject]{
                completion(t)
            }
        }
    }
    func onNewUserAdded(completion: @escaping([String:AnyObject]) -> Void) {
        self.socket.on(GroupNotif.kNewUserAdded.rawValue) { (resp, emitter) in
            print(resp)
            if let t = resp[0] as? [String:AnyObject]{
                completion(t)
            }
        }
    }
    func followUserFromOtherProfile(data: [Any], completion: @escaping([Any]) -> Void)
    {
        if !isConnected()
        {
            initSocket(completion: { (result) in
                self.socket.emitWithAck("followUser", with: data).timingOut(after: 0) {resp in
                    print(resp)
                    completion(resp)
                }
            })
            return
        }
        self.socket.emitWithAck("followUser", with: data).timingOut(after: 0) {resp in
            print(resp)
            completion(resp)
        }
    }
    
}
