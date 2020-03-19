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
    
    var manager = SocketManager(socketURL: URL(string: "https://www.drdsh.live")!, config: [.log(true), .compress,.enableSOCKSProxy(true)])
    
    func initSocket(completion: @escaping(Bool) -> Void) {
        manager.defaultSocket.disconnect()
        manager.defaultSocket.on(clientEvent: .connect) { data, ack in
            print("socket connected \(data)")
            completion(true)
        }
        manager.defaultSocket.on("client balance change") { dataArray, ack in
            print("socket connected \(dataArray)")
        }
        manager.defaultSocket.on(clientEvent: .disconnect) {data, ack in
            print("socket disconnected \(data)")
        }
        manager.defaultSocket.connect()
        manager.defaultSocket.on("ipBlocked") { (resp, emitter) in
            print(resp)
            NotificationCenter.default.post(name: NSNotification.Name("ipBlocked"), object: self, userInfo: ["data": resp])
        }
        manager.defaultSocket.on("totalOnlineAgents") { (resp, emitter) in
            print(resp)
            NotificationCenter.default.post(name: NSNotification.Name("totalOnlineAgents"), object: self, userInfo: ["data": resp])
        }
        manager.defaultSocket.on("agentAcceptedChatRequest") { (resp, emitter) in
            print(resp)
            NotificationCenter.default.post(name: NSNotification.Name("agentAcceptedChatRequest"), object: self, userInfo: ["data": resp])
        }
        manager.defaultSocket.on("agentSendNewMessage") { (resp, emitter) in
            print(resp)
            NotificationCenter.default.post(name: NSNotification.Name("agentSendNewMessage"), object: self, userInfo: ["data": resp])
        }
        manager.defaultSocket.on("agentChatSessionTerminated") { (resp, emitter) in
            print(resp)
            NotificationCenter.default.post(name: NSNotification.Name("agentChatSessionTerminated"), object: self, userInfo: ["data": resp])
        }
        manager.defaultSocket.on("agentTypingListener") { (resp, emitter) in
            print(resp)
            NotificationCenter.default.post(name: NSNotification.Name("agentTypingListener"), object: self, userInfo: ["data": resp])
        }
        manager.defaultSocket.on("newAgentAcceptedChatRequest") { (resp, emitter) in
            print(resp)
            NotificationCenter.default.post(name: NSNotification.Name("newAgentAcceptedChatRequest"), object: self, userInfo: ["data": resp])
        }
        manager.defaultSocket.on(clientEvent: .connect) {data, ack in
            if ack.expected {
                print("connect inside \(data) ack")
            }else{
                print("connect inside without ack \(data) ")
            }
            completion(true)
        }
        manager.defaultSocket.on(clientEvent: .reconnect) {data, ack in
            if ack.expected {
                print("reconnect inside \(data) ack")
            }else{
                print("reconnect inside without ack \(data) ")
            }
        }
        if manager.defaultSocket.status == .disconnected || manager.defaultSocket.status == .notConnected{
            manager.defaultSocket.disconnect()
            manager.defaultSocket.connect()
        }
    }
    
    //MARK:- CHECK CONNECTED
    func isConnected() -> Bool{
        if manager.defaultSocket.status == .connected{
            return true
        }
        return false
    }

    //MARK:- CHECK DISCONNECTED
    func disConnect() {
        manager.defaultSocket.disconnect()
        //socket = SocketManager(socketURL: URL(string: "https://www.drdsh.live")!, config: [.log(true), .compress]).defaultSocket
    }
//    func onChangeGroupName(completion: @escaping([String:AnyObject]) -> Void)
//    {
//        socket.on("") { (resp, emitter) in
//            print(resp)
//            if let t = resp[0] as? [String:AnyObject]{
//                completion(t)
//            }
//        }
//    }
    func startChatRequest(data: [Any])
    {
        if !isConnected()
        {
            initSocket(completion: { (result) in
                self.manager.defaultSocket.emitWithAck("startChatRequest", with: data).timingOut(after: 0) {resp in
                    print(resp)
                }
            })
            return
        }
        manager.defaultSocket.emitWithAck("startChatRequest", with: data).timingOut(after: 0) {resp in
            print(resp)
             print(resp)
        }
    }
    func visitorJoinAgentRoom(data: [Any])
    {
        if !isConnected()
        {
            initSocket(completion: { (result) in
                self.manager.defaultSocket.emitWithAck("visitorJoinAgentRoom", with: data).timingOut(after: 0) {resp in
                    print(resp)
                }
            })
            return
        }
        manager.defaultSocket.emitWithAck("visitorJoinAgentRoom", with: data).timingOut(after: 0) {resp in
            print(resp)
        }
    }
    func invitationMaxWaitTimeExceeded(data: [Any], completion: @escaping([Any]) -> Void)
    {
        if !isConnected()
        {
            initSocket(completion: { (result) in
                self.manager.defaultSocket.emitWithAck("invitationMaxWaitTimeExceeded", with: data).timingOut(after: 0) {resp in
                    print(resp)
                    completion(resp)
                }
            })
            return
        }
        manager.defaultSocket.emitWithAck("invitationMaxWaitTimeExceeded", with: data).timingOut(after: 0) {resp in
            print(resp)
            completion(resp)
        }
    }
    func visitorLoadChatHistory(data: [Any], completion: @escaping([Any]) -> Void)
    {
        if !isConnected()
        {
            initSocket(completion: { (result) in
                self.manager.defaultSocket.emitWithAck("visitorLoadChatHistory", with: data).timingOut(after: 0) {resp in
                    print(resp)
                    completion(resp)
                }
            })
            return
        }
        manager.defaultSocket.emitWithAck("visitorLoadChatHistory", with: data).timingOut(after: 0) {resp in
            print(resp)
            completion(resp)
        }
    }
    func visitorTyping(data: [Any])
    {
        if !isConnected()
        {
            initSocket(completion: { (result) in
                self.manager.defaultSocket.emitWithAck("visitorTyping", with: data).timingOut(after: 0) {resp in
                    print(resp)
                }
            })
            return
        }
        manager.defaultSocket.emitWithAck("visitorTyping", with: data).timingOut(after: 0) {resp in
            print(resp)
        }
    }
    func emailChatTranscript(data: [Any], completion: @escaping([Any]) -> Void)
    {
        if !isConnected()
        {
            initSocket(completion: { (result) in
                self.manager.defaultSocket.emitWithAck("emailChatTranscript", with: data).timingOut(after: 0) {resp in
                    print(resp)
                    completion(resp)
                }
            })
            return
        }
        manager.defaultSocket.emitWithAck("emailChatTranscript", with: data).timingOut(after: 0) {resp in
            print(resp)
            completion(resp)
        }
    }
    func sendVisitorMessage(data: [Any], completion: @escaping([Any]) -> Void)
    {
        if !isConnected()
        {
            initSocket(completion: { (result) in
                self.manager.defaultSocket.emitWithAck("sendVisitorMessage", with: data).timingOut(after: 0) {resp in
                    print(resp)
                    completion(resp)
                }
            })
            return
        }
        manager.defaultSocket.emitWithAck("sendVisitorMessage", with: data).timingOut(after: 0) {resp in
            print(resp)
            completion(resp)
        }
    }
    func visitorEndChatSession(data: [Any], completion: @escaping([Any]) -> Void)
    {
        if !isConnected()
        {
            initSocket(completion: { (result) in
                self.manager.defaultSocket.emitWithAck("visitorEndChatSession", with: data).timingOut(after: 0) {resp in
                    print(resp)
                    completion(resp)
                }
            })
            return
        }
        manager.defaultSocket.emitWithAck("visitorEndChatSession", with: data).timingOut(after: 0) {resp in
            print(resp)
            completion(resp)
        }
    }
    func updateVisitorRating(data: [Any])
    {
        if !isConnected()
        {
            initSocket(completion: { (result) in
                self.manager.defaultSocket.emitWithAck("updateVisitorRating", with: data).timingOut(after: 0) {resp in
                    print(resp)
                }
            })
            return
        }
        manager.defaultSocket.emitWithAck("updateVisitorRating", with: data).timingOut(after: 0) {resp in
            print(resp)
        }
    }
}









