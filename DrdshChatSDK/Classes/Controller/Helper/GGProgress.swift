//
//  GGProgress.swift
//  ShowBuddy
//
//  Created by Gauravkumar Gudaliya on 16/03/18.
//  Copyright © 2018 AshvinGudaliya. All rights reserved.
//

import UIKit
import MBProgressHUD

class GGProgress: NSObject {
    
    static var shared: GGProgress = GGProgress()
    
    var hub: MBProgressHUD!
    
    func showProgress(with title: String = "", file: String = #function,isFullLoader:Bool=true){
        DispatchQueue.main.async {
            self.hideProgress()
            debugPrint("GGProgress : \(file) strat")
            self.hub = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
            self.hub.label.text = title
            self.hub.contentColor = UIColor.white
            if isFullLoader{
                self.hub.backgroundColor = UIColor.white
                self.hub.bezelView.color = UIColor.black
                self.hub.bezelView.style = .solidColor
            }else{
                self.hub.bezelView.color = UIColor.black
                self.hub.bezelView.style = .solidColor
            }
        }
    }
    
    func hideProgress(_ file: String = #function){
        if hub != nil {
            debugPrint("GGProgress : \(file) end")
            self.hub.hide(animated: true)
            self.hub = nil
        }
    }
}

