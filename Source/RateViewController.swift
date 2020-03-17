//
//  RateViewController.swift
//  GGiOSSDK
//
//  Created by Gaurav Gudaliya R on 17/03/20.
//

import UIKit

class RateViewController: UIViewController {

    @IBOutlet weak var btnLike: GGButton!
    @IBOutlet weak var btnDisLike: GGButton!
    @IBOutlet weak var btnMail: GGButton!
    @IBOutlet weak var btnSend: GGButton!
    @IBOutlet weak var btnCancel: GGButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDiscription: UILabel!
    @IBOutlet weak var txtComment: UITextView!
    var type = 0
    var successHandler:(()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnCancel.isHidden = type == 0
        txtComment.layer.borderWidth = 1
        txtComment.layer.borderColor = UIColor.lightGray.cgColor
        txtComment.text = ""
//        self.lblTitle.text = "Rate your chat experience"
//        self.lblDiscription.text = "To help us serve you better, please provide some information concerning your chat experience."
        
       var bundle = Bundle(for: GGiOSSDK.self)
        if let resourcePath = bundle.path(forResource: "GGiOSSDK", ofType: "bundle") {
            if let resourcesBundle = Bundle(path: resourcePath) {
                bundle = resourcesBundle
            }
        }
        btnLike.setImage(UIImage(named: "like", in: bundle, compatibleWith: nil), for: .normal)
        btnDisLike.setImage(UIImage(named: "dislike", in: bundle, compatibleWith: nil), for: .normal)
        btnMail.setImage(UIImage(named: "mail", in: bundle, compatibleWith: nil), for: .normal)
        btnSend.action = {
            self.dismiss(animated: false, completion: {
                self.successHandler?()
            })
        }
        btnLike.action = {
            
        }
        btnCancel.action = {
            self.dismiss(animated: false, completion: {
                
            })
        }
        btnDisLike.action = {
            
        }
        btnMail.action = {
            
        }
    }
}
