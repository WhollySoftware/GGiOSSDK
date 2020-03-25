//
//  UserDetails.swift
//  Alfayda
//
//  Created by Wholly-iOS on 25/08/18.
//  Copyright © 2018 Whollysoftware. All rights reserved.
//

import UIKit


class GGUserSessionDetail: GGObject {
    
    var name: String {
        get { return UserDefaults.standard.string(forKey: "name") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "name") }
    }
    var mobile: String {
        get { return UserDefaults.standard.string(forKey: "mobile") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "mobile") }
    }
    var email: String {
        get { return UserDefaults.standard.string(forKey: "email") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "email") }
    }
    
    static var shared = GGUserSessionDetail()
    override init() {
        super.init()
        
    }
}


class GGApplication: NSObject {
    
    /// EZSE: Returns app's version number
    public static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleInfoDictionaryVersionKey as String) as? String ?? ""
    }
    
    /// EZSE: Return app's build number
    public static var appBuild: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? ""
    }
}
class ValidateIdentity:GGObject{
    var agentId:String = ""
    var agentOnline:Int  = 0
    var companyId:String  = ""
    var embeddedChat:EmbeddedChat  = EmbeddedChat()
    var isBlocked:Bool  = false
    var messageID:String  = ""
    var name:String  = ""
    var email:String  = ""
    var mobile:String  = ""
    var visitorConnectedStatus:Int  = 0
    var visitorID:String  = ""
}
class EmbeddedChat:GGObject{
    var _id:String  = ""
    var displayForm:Int  = 0
    var emailRequired:Bool  = false
    var messageRequired:Bool  = false
    var mobileRequired:Bool  = false
    var offlineMessageOptions:Bool  = false
    var offlineMsgShowMobileBox:Bool  = false
    var offlineMsgShowSubjectBox:Bool  = false
    var postChatPromptComments:Bool  = false
    var showAgentPanel:Bool  = false
    var showHeaderImg:Bool  = false
    var offlineTxt:String  = ""
    var onHoldMsg:String  = ""
    var onlineTxt:String  = ""
    var preChatOfflineMessageTxt:String  = ""
    var preChatOnlineMessageTxt:String  = ""
    var sendButtonTxt:String  = ""
    var startChatButtonTxt:String  = ""
}
class MessageModel:GGObject{
    var __v:Int  = 0
    var _id:String  = ""
    var isBlocked:String  = ""
    var agent_image:String  = ""
    var agent_name:String  = ""
    var attachment_file:String  = ""
    var company_id:String  = ""
    var file_size:String  = ""
    var file_type:String  = ""
    var formatted_file_size:Int  = 0
    var isDeleted:Int  = 0
    var isSystem:Int  = 0
    var isTransfer:Int  = 0
    var isWelcome:Int  = 0
    var is_attachment:Int  = 0
    var localId:String  = ""
    var message:String  = ""
    var new_agent_id:String  = ""
    var new_agent_image:String  = ""
    var new_agent_name:String  = ""
    var send_by:Int  = 0
    var updatedAt:String  = ""
    var visitor_id:VisitorIdModel  = VisitorIdModel()
    var visitor_message_id:String  = ""
}

class VisitorIdModel:GGObject{
    var name:String  = ""
    var _id:String  = ""
    var image:String  = ""
}

class AgentModel:GGObject{
    var __v:Int  = 0
    var _id:String  = ""
    var account_id:String  = ""
    var agent_id:String  = ""
    var agent_image:String  = ""
    var agent_name:String  = ""
    var company_id:String  = ""
    var message:String  = ""
    var mobile:String  = ""
    var name:String  = ""
    var status:Int  = 0
    var total_chats:Int  = 0
    var total_visits:Int  = 0
    var visitor_message_id:String  = ""
    var waitingDuration:Int  = 0
}
