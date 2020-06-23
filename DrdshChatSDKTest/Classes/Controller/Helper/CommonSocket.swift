//
//  CommonSocket.swift
//  ChinaTravelsSwift
//
//  Created by WebMazix Pro1 on 27/12/18.
//  Copyright © 2018 WebMazix Pro1. All rights reserved.
//

import UIKit
import SocketIO

enum GGSokcetEmitKey {
    
    case joinVisitorsRoom
    case visitorJoinAgentRoom
    case invitationMaxWaitTimeExceeded
    case visitorLoadChatHistory
    case visitorTyping
    case emailChatTranscript
    case sendVisitorMessage
    case visitorEndChatSession
    case updateVisitorRating
    case inviteChat
    case submitOfflineMessage
    case joinAgentRoom


    var relative: String {
        return self.value
    }
    
    private var value: String {
        switch self {
        case .joinVisitorsRoom : return "joinVisitorsRoom"
        case .visitorJoinAgentRoom : return "visitorJoinAgentRoom"
        case .invitationMaxWaitTimeExceeded : return "invitationMaxWaitTimeExceeded"
        case .visitorLoadChatHistory : return "visitorLoadChatHistory"
        case .visitorTyping : return "visitorTyping"
        case .emailChatTranscript : return "emailChatTranscript"
        case .sendVisitorMessage : return "sendVisitorMessage"
        case .visitorEndChatSession : return "visitorEndChatSession"
        case .updateVisitorRating : return "updateVisitorRating"
        case .inviteChat : return "inviteChat"
        case .submitOfflineMessage : return "submitOfflineMessage"
        case .joinAgentRoom : return "joinAgentRoom"
        }
    }
}

class CommonSocket: NSObject {

    static let shared = CommonSocket()
    
    var agentDetail:(([String:AnyObject])->Void)?
    var manager = SocketManager(socketURL: URL(string: "https://www.drdsh.live")!, config: [.log(false), .compress])
    
    func initSocket(completion: @escaping(Bool) -> Void) {
        manager.defaultSocket.on(clientEvent: .connect) { data, ack in
            print("socket connected \(data)")
            completion(true)
        }
        manager.defaultSocket.on("client balance change") { dataArray, ack in
            print("socket connected \(dataArray)")
        }
        manager.defaultSocket.on(clientEvent: .disconnect) {data, ack in
            print("socket disconnected \(data)")
            self.manager.defaultSocket.connect()
        }
        manager.defaultSocket.on(clientEvent: .reconnect) {data, ack in
            if ack.expected {
                print("reconnect inside \(data) ack")
            }else{
                print("reconnect inside without ack \(data) ")
            }
        }
        if manager.defaultSocket.status == .disconnected || manager.defaultSocket.status == .notConnected{
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
        return
        //manager.defaultSocket.disconnect()
        //socket = SocketManager(socketURL: URL(string: "https://www.drdsh.live")!, config: [.log(true), .compress]).defaultSocket
    }
    func CommanEmitSokect(command:GGSokcetEmitKey,data: [Any], completion: @escaping([String:AnyObject]) -> Void)
    {
        var t:[String:Any] = [:]
        t = data[0] as? [String:Any] ?? [:]
        t["appSid"] = DrdshChatSDKTest.shared.config.appSid
        t["device"] = "ios"
        
        if isConnected()
        {
            manager.defaultSocket.emitWithAck(command.relative, with: [t]).timingOut(after: 0) {resp in
                print(resp)
                if resp.count > 1{
                    if (resp[0] as? Int ?? 0) == 200{
                        completion(resp[1] as? [String:AnyObject] ?? [:])
                    }
                }else{
                    completion(resp[0] as? [String:AnyObject] ?? [:])
                }
            }
        }else{
            initSocket(completion: { (result) in
                self.manager.defaultSocket.emitWithAck(command.relative, with: [t]).timingOut(after: 0) {resp in
                    print(resp)
                    if resp.count > 1{
                        if (resp[0] as? Int ?? 0) == 200{
                            completion(resp[1] as? [String:AnyObject] ?? [:])
                        }
                    }else{
                        completion(resp[0] as? [String:AnyObject] ?? [:])
                    }
                }
            })
        }
    }
    func ipBlocked(completion: @escaping([String:AnyObject]) -> Void)
    {
        self.manager.defaultSocket.on("ipBlocked") { (resp, emitter) in
            print(resp)
            if let t = resp[0] as? [String:AnyObject]{
                completion(t)
            }
        }
    }
    func totalOnlineAgents(completion: @escaping([String:AnyObject]) -> Void)
    {
        self.manager.defaultSocket.on("totalOnlineAgents") { (resp, emitter) in
            print(resp)
            if let t = resp[0] as? [String:AnyObject]{
                completion(t)
            }
        }
    }
    func agentAcceptedChatRequest(completion: @escaping([String:AnyObject]) -> Void)
    {
        self.manager.defaultSocket.on("agentAcceptedChatRequest") { (resp, emitter) in
            print(resp)
            if let t = resp[0] as? [String:AnyObject]{
                completion(t)
            }
        }
    }
    func agentSendNewMessage(completion: @escaping([String:AnyObject]) -> Void)
    {
        self.manager.defaultSocket.on("agentSendNewMessage") { (resp, emitter) in
            print(resp)
            if let t = resp[0] as? [String:AnyObject]{
                completion(t)
            }
        }
    }
    func agentChatSessionTerminated(completion: @escaping([String:AnyObject]) -> Void)
    {
        self.manager.defaultSocket.on("agentChatSessionTerminated") { (resp, emitter) in
            print(resp)
            if let t = resp[0] as? [String:AnyObject]{
                completion(t)
            }
        }
    }
    func inviteVisitorListener(completion: @escaping([String:AnyObject]) -> Void)
    {
        self.manager.defaultSocket.on("inviteVisitorListener") { (resp, emitter) in
            print(resp)
            if let t = resp[0] as? [String:AnyObject]{
                completion(t)
            }
        }
    }
    func agentTypingListener(completion: @escaping([String:AnyObject]) -> Void)
    {
        self.manager.defaultSocket.on("agentTypingListener") { (resp, emitter) in
            print(resp)
            if let t = resp[0] as? [String:AnyObject]{
                completion(t)
            }
        }
    }
    func newAgentAcceptedChatRequest(completion: @escaping([String:AnyObject]) -> Void)
    {
        self.manager.defaultSocket.on("newAgentAcceptedChatRequest") { (resp, emitter) in
            print(resp)
            if let t = resp[0] as? [String:AnyObject]{
                completion(t)
            }
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
}









