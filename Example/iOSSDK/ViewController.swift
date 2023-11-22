//
//  ViewController.swift
//  iOSSDK
//
//  Created by gauravgudaliya on 03/14/2020.
//  Copyright (c) 2020 gauravgudaliya. All rights reserved.
//

import UIKit
import DrdshChatSDK
import Firebase

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
                AppDelegate.shared.token = token
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    deinit {
        
    }
    
    @IBAction func btnStartENAction(_ sender:UIButton){
         UIView.appearance().semanticContentAttribute = .forceLeftToRight
        let sdkCongig = DrdshChatSDKConfiguration()
        sdkCongig.appSid = "Put your appSid here"
        sdkCongig.FCM_Token = AppDelegate.shared.token
        sdkCongig.FCM_Auth_Key = AppDelegate.shared.Auth_key
        sdkCongig.local = "en"
       DrdshChatSDK.presentChat(config: sdkCongig)
    }
    @IBAction func btnStartARAction(_ sender:UIButton){
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        let sdkCongig = DrdshChatSDKConfiguration()
        sdkCongig.appSid = "Put your appSid here"
        sdkCongig.FCM_Token = AppDelegate.shared.token
        sdkCongig.FCM_Auth_Key = AppDelegate.shared.Auth_key
       sdkCongig.local = "ar"
       DrdshChatSDK.presentChat(config: sdkCongig)
    }
}

