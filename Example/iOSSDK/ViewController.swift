//
//  ViewController.swift
//  iOSSDK
//
//  Created by gauravgudaliya on 03/14/2020.
//  Copyright (c) 2020 gauravgudaliya. All rights reserved.
//

import UIKit
import GGiOSSDK
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
     // mainload
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnStartAction(_ sender:UIButton){
        GGiOSSDK.presentChat()
    }
    @IBAction func btnStopAction(_ sender:UIButton){
        
    }
}

