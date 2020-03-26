//
//  ViewController.swift
//  iOSSDK
//
//  Created by gauravgudaliya on 03/14/2020.
//  Copyright (c) 2020 gauravgudaliya. All rights reserved.
//

import UIKit
import DrdshChatSDKTest
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let sdkCongig = DrdshChatSDKConfiguration()
        sdkCongig.appSid = "5def86cf64be6d13f55f2034.5d96941bb5507599887b9c71829d5cffcdf55014"
        sdkCongig.local = "ar"
        DrdshChatSDKTest.presentChat(config: sdkCongig)
    }
    deinit {
        
    }
    @IBAction func btnStartAction(_ sender:UIButton){
        let sdkCongig = DrdshChatSDKConfiguration()
       sdkCongig.appSid = "5def86cf64be6d13f55f2034.5d96941bb5507599887b9c71829d5cffcdf55014"
       sdkCongig.local = "ar"
       DrdshChatSDKTest.presentChat(config: sdkCongig)
    }
    @IBAction func btnStopAction(_ sender:UIButton){
        let sdkCongig = DrdshChatSDKConfiguration()
        sdkCongig.appSid = "5def86cf64be6d13f55f2034.5d96941bb5507599887b9c71829d5cffcdf55014"
        sdkCongig.local = "ar"
        sdkCongig.mainColor = UIColor.cyan
        DrdshChatSDKTest.presentChat(config: sdkCongig)
    }
}

