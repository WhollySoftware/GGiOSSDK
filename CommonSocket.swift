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
    var socket = SocketManager(socketURL: URL(string: "https://www.drdsh.live")!, config: [.log(true), .compress]).defaultSocket
    //MARK:- INIT
    func initSocket(completion: @escaping(Bool) -> Void) {
        self.socket.on("ipBlocked") { (resp, emitter) in
            print(resp)
            NotificationCenter.default.post(name: NSNotification.Name("ipBlocked"), object: self, userInfo: ["data": resp])
        }
        self.socket.on("totalOnlineAgents") { (resp, emitter) in
            print(resp)
            NotificationCenter.default.post(name: NSNotification.Name("totalOnlineAgents"), object: self, userInfo: ["data": resp])
        }
        self.socket.on("agentAcceptedChatRequest") { (resp, emitter) in
            print(resp)
            NotificationCenter.default.post(name: NSNotification.Name("agentAcceptedChatRequest"), object: self, userInfo: ["data": resp])
        }
        self.socket.on("agentSendNewMessage") { (resp, emitter) in
            print(resp)
            NotificationCenter.default.post(name: NSNotification.Name("agentSendNewMessage"), object: self, userInfo: ["data": resp])
        }
        self.socket.on("agentChatSessionTerminated") { (resp, emitter) in
            print(resp)
            NotificationCenter.default.post(name: NSNotification.Name("agentChatSessionTerminated"), object: self, userInfo: ["data": resp])
        }
        self.socket.on("agentTypingListener") { (resp, emitter) in
            print(resp)
            NotificationCenter.default.post(name: NSNotification.Name("agentTypingListener"), object: self, userInfo: ["data": resp])
        }
        self.socket.on("newAgentAcceptedChatRequest") { (resp, emitter) in
            print(resp)
            NotificationCenter.default.post(name: NSNotification.Name("newAgentAcceptedChatRequest"), object: self, userInfo: ["data": resp])
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
        socket = SocketManager(socketURL: URL(string: "https://www.drdsh.live")!, config: [.log(true), .compress]).defaultSocket
    }
//    func onChangeGroupName(completion: @escaping([String:AnyObject]) -> Void)
//    {
//        self.socket.on("") { (resp, emitter) in
//            print(resp)
//            if let t = resp[0] as? [String:AnyObject]{
//                completion(t)
//            }
//        }
//    }
    func startChatRequest(data: [Any], completion: @escaping([Any]) -> Void)
    {
        if !isConnected()
        {
            initSocket(completion: { (result) in
                self.socket.emitWithAck("startChatRequest", with: data).timingOut(after: 0) {resp in
                    print(resp)
                    completion(resp)
                }
            })
            return
        }
        self.socket.emitWithAck("startChatRequest", with: data).timingOut(after: 0) {resp in
            print(resp)
            completion(resp)
        }
    }
    func visitorJoinAgentRoom(data: [Any], completion: @escaping([Any]) -> Void)
    {
        if !isConnected()
        {
            initSocket(completion: { (result) in
                self.socket.emitWithAck("visitorJoinAgentRoom", with: data).timingOut(after: 0) {resp in
                    print(resp)
                    completion(resp)
                }
            })
            return
        }
        self.socket.emitWithAck("visitorJoinAgentRoom", with: data).timingOut(after: 0) {resp in
            print(resp)
            completion(resp)
        }
    }
    func invitationMaxWaitTimeExceeded(data: [Any], completion: @escaping([Any]) -> Void)
    {
        if !isConnected()
        {
            initSocket(completion: { (result) in
                self.socket.emitWithAck("invitationMaxWaitTimeExceeded", with: data).timingOut(after: 0) {resp in
                    print(resp)
                    completion(resp)
                }
            })
            return
        }
        self.socket.emitWithAck("invitationMaxWaitTimeExceeded", with: data).timingOut(after: 0) {resp in
            print(resp)
            completion(resp)
        }
    }
    func visitorLoadChatHistory(data: [Any], completion: @escaping([Any]) -> Void)
    {
        if !isConnected()
        {
            initSocket(completion: { (result) in
                self.socket.emitWithAck("visitorLoadChatHistory", with: data).timingOut(after: 0) {resp in
                    print(resp)
                    completion(resp)
                }
            })
            return
        }
        self.socket.emitWithAck("visitorLoadChatHistory", with: data).timingOut(after: 0) {resp in
            print(resp)
            completion(resp)
        }
    }
    func visitorTyping(data: [Any], completion: @escaping([Any]) -> Void)
    {
        if !isConnected()
        {
            initSocket(completion: { (result) in
                self.socket.emitWithAck("visitorTyping", with: data).timingOut(after: 0) {resp in
                    print(resp)
                    completion(resp)
                }
            })
            return
        }
        self.socket.emitWithAck("visitorTyping", with: data).timingOut(after: 0) {resp in
            print(resp)
            completion(resp)
        }
    }
    func emailChatTranscript(data: [Any], completion: @escaping([Any]) -> Void)
    {
        if !isConnected()
        {
            initSocket(completion: { (result) in
                self.socket.emitWithAck("emailChatTranscript", with: data).timingOut(after: 0) {resp in
                    print(resp)
                    completion(resp)
                }
            })
            return
        }
        self.socket.emitWithAck("emailChatTranscript", with: data).timingOut(after: 0) {resp in
            print(resp)
            completion(resp)
        }
    }
    func sendVisitorMessage(data: [Any], completion: @escaping([Any]) -> Void)
    {
        if !isConnected()
        {
            initSocket(completion: { (result) in
                self.socket.emitWithAck("sendVisitorMessage", with: data).timingOut(after: 0) {resp in
                    print(resp)
                    completion(resp)
                }
            })
            return
        }
        self.socket.emitWithAck("sendVisitorMessage", with: data).timingOut(after: 0) {resp in
            print(resp)
            completion(resp)
        }
    }
    func visitorEndChatSession(data: [Any], completion: @escaping([Any]) -> Void)
    {
        if !isConnected()
        {
            initSocket(completion: { (result) in
                self.socket.emitWithAck("visitorEndChatSession", with: data).timingOut(after: 0) {resp in
                    print(resp)
                    completion(resp)
                }
            })
            return
        }
        self.socket.emitWithAck("visitorEndChatSession", with: data).timingOut(after: 0) {resp in
            print(resp)
            completion(resp)
        }
    }
    func updateVisitorRating(data: [Any], completion: @escaping([Any]) -> Void)
    {
        if !isConnected()
        {
            initSocket(completion: { (result) in
                self.socket.emitWithAck("updateVisitorRating", with: data).timingOut(after: 0) {resp in
                    print(resp)
                    completion(resp)
                }
            })
            return
        }
        self.socket.emitWithAck("updateVisitorRating", with: data).timingOut(after: 0) {resp in
            print(resp)
            completion(resp)
        }
    }
    
    
}









