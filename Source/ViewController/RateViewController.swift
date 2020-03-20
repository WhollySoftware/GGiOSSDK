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
    @IBOutlet weak var btnCancel1: GGButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDiscription: UILabel!
    @IBOutlet weak var txtComment: UITextView!
    var type = 0
    var successHandler:(()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnCancel.isHidden = type != 2
        self.btnDisLike.isHidden = type == 2
        self.btnLike.isHidden = type == 2
        self.btnMail.isHidden = type != 2
        txtComment.layer.borderWidth = 1
        txtComment.layer.borderColor = UIColor.lightGray.cgColor
        txtComment.text = ""

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
            if self.type == 2{
                if self.txtComment.text == ""{
                    let alert = UIAlertController(title: "Error", message: "Please enter email", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    GGiOSSDK.shared.topViewController()?.present(alert, animated: true, completion: nil)
                }else{
                    CommonSocket.shared.emailChatTranscript(data: [["mid":GGiOSSDK.shared.AllDetails.messageID,"vid":GGiOSSDK.shared.AllDetails.visitorID,"email":self.txtComment.text!]]) { (data) in
                        debugPrint(data)
                        self.dismiss(animated: false, completion: {
                            self.successHandler?()
                        })
                    }
                }
            }else{
                CommonSocket.shared.visitorEndChatSession(data: [["id":GGiOSSDK.shared.AllDetails.messageID,"vid":GGiOSSDK.shared.AllDetails.visitorID,"name":GGiOSSDK.shared.AllDetails.name,"comment":GGiOSSDK.shared.AllDetails.companyId,"feedback":""]]) { (data) in
                    debugPrint(data)
                    self.dismiss(animated: false, completion: {
                        self.successHandler?()
                    })
                }
            }
            
        }
        btnLike.action = {
            
        }
        btnCancel.action = {
            self.dismiss(animated: false, completion: {
                
            })
        }
        btnCancel1.action = {
           self.dismiss(animated: false, completion: {
               
           })
       }
        btnDisLike.action = {
            
        }
        btnMail.action = {
            
        }
    }
}
