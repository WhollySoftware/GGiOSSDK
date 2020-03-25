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
        DrdshChatSDKTest.presentChat(appSid: "5def86cf64be6d13f55f2034.5d96941bb5507599887b9c71829d5cffcdf55014")
    }
    deinit {
        
    }
    @IBAction func btnStartAction(_ sender:UIButton){
         DrdshChatSDKTest.presentChat(appSid: "5def86cf64be6d13f55f2034.5d96941bb5507599887b9c71829d5cffcdf55014")
    }
    @IBAction func btnStopAction(_ sender:UIButton){
        
    }
}

