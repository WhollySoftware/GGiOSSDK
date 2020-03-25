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
        
        if self.type == 2{
            lblTitle.text = "Please input your email address"
            txtComment.autocapitalizationType = .none
            txtComment.autocorrectionType = .no
        }else{
            lblTitle.text = "Rate your chat experience"
        }
        lblDiscription.text = "To help us server you better, please provide some information concerning your chat experience."
        txtComment.layer.borderWidth = 1
        txtComment.layer.borderColor = UIColor.lightGray.cgColor
        txtComment.text = ""
        
        btnSend.setImage(GGiOSSDK.shared.config.sendMessageImage, for: .normal)
        btnLike.setImage(GGiOSSDK.shared.config.likeImage, for: .normal)
        btnDisLike.setImage(GGiOSSDK.shared.config.disLikeImage, for: .normal)
        btnLike.setImage(GGiOSSDK.shared.config.likeSelctedImage, for: .selected)
        btnDisLike.setImage(GGiOSSDK.shared.config.disLikeSelctedImage, for: .selected)
        btnMail.setImage(GGiOSSDK.shared.config.mailImage, for: .normal)named: "mail", in: bundle, compatibleWith: nil), for: .normal)
        btnSend.action = {
            if self.type == 2{
                if self.txtComment.text == ""{
                    let alert = UIAlertController(title: "Error", message: "Please enter email", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    GGiOSSDK.shared.topViewController()?.present(alert, animated: true, completion: nil)
                }else if !self.txtComment.text.isValidEmail{
                    let alert = UIAlertController(title: "Error", message: "Please enter valid email", preferredStyle: UIAlertController.Style.alert)
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
               
                var feedback = ""
                if self.btnLike.isSelected{
                    feedback = "good"
                }else if self.btnDisLike.isSelected{
                    feedback = "bad"
                }
                CommonSocket.shared.visitorEndChatSession(data: [["id":GGiOSSDK.shared.AllDetails.messageID,"vid":GGiOSSDK.shared.AllDetails.visitorID,"name":GGiOSSDK.shared.AllDetails.name,"comment":self.txtComment.text!,"feedback":feedback]]) { (data) in
                    debugPrint(data)
                    self.dismiss(animated: false, completion: {
                        self.successHandler?()
                    })
                }
            }
            
        }
        btnLike.action = {
            self.btnLike.isSelected = true
            self.btnDisLike.isSelected = false
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
            self.btnLike.isSelected = false
            self.btnDisLike.isSelected = true
        }
        btnMail.action = {
            
        }
    }
}
extension String {
   var isValidEmail: Bool {
      let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
      return testEmail.evaluate(with: self)
   }
   var isValidPhone: Bool {
      let regularExpressionForPhone = "^\\d{3}-\\d{3}-\\d{4}$"
      let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
      return testPhone.evaluate(with: self)
   }
}
