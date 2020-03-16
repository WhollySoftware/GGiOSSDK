//
//  UserDetails.swift
//  Alfayda
//
//  Created by Wholly-iOS on 25/08/18.
//  Copyright © 2018 Whollysoftware. All rights reserved.
//

import UIKit


class GGUserSessionDetail: GGObject {
    
    static var isNewInstallled: Bool {
        get { return UserDefaults.standard.bool(forKey: "isUserLogin") }
        set { UserDefaults.standard.set(newValue, forKey: "isUserLogin") }
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
    var visitorConnectedStatus:Int  = 0
    var visitorID:String  = ""
}
class EmbeddedChat:GGObject{
    var isBlocked:Bool  = false
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
