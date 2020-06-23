//
//  RateViewController.swift
//  DrdshChatSDK
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
        if DrdshChatSDKTest.shared.config.local == "ar"{
            self.txtComment.textAlignment = .right
        }
        if self.type == 2{
            txtComment.text = GGUserSessionDetail.shared.email
            lblTitle.text = DrdshChatSDKTest.shared.config.pleaseInputYourEmailAddress.Local()
            txtComment.autocapitalizationType = .none
            txtComment.autocorrectionType = .no
        }else{
            lblTitle.text = DrdshChatSDKTest.shared.localizedString(stringKey:DrdshChatSDKTest.shared.config.exitSurveyHeaderTxt)
        }
        txtComment.isHidden = !DrdshChatSDKTest.shared.AllDetails.embeddedChat.postChatPromptComments

        self.btnSend.setTitle( DrdshChatSDKTest.shared.config.exitSurveySendButtonTxt.Local(), for: .normal)
        self.btnCancel.setTitle( DrdshChatSDKTest.shared.config.exitSurveyCloseButtonTxt.Local(), for: .normal)
        
        lblDiscription.text = DrdshChatSDKTest.shared.localizedString(stringKey:DrdshChatSDKTest.shared.config.exitSurveyMessageTxt)
        txtComment.layer.borderWidth = 1
        txtComment.layer.borderColor = UIColor.lightGray.cgColor
        txtComment.text = ""
        self.btnCancel.backgroundColor = DrdshChatSDKTest.shared.config.buttonColor.Color()
        self.btnSend.backgroundColor = DrdshChatSDKTest.shared.config.buttonColor.Color()
        btnLike.setImage(DrdshChatSDKTest.shared.config.likeImage, for: .normal)
        btnDisLike.setImage(DrdshChatSDKTest.shared.config.disLikeImage, for: .normal)
        btnLike.setImage(DrdshChatSDKTest.shared.config.likeSelctedImage, for: .selected)
        btnDisLike.setImage(DrdshChatSDKTest.shared.config.disLikeSelctedImage, for: .selected)
        btnMail.setImage(DrdshChatSDKTest.shared.config.mailImage, for: .normal)
        btnSend.action = {
            if self.type == 2{
                if self.txtComment.text == ""{
                    self.showAlertView(str: DrdshChatSDKTest.shared.config.pleaseEnterEmailAddress)
                    return
                }else if !self.txtComment.text.isValidEmail{
                    self.showAlertView(str: DrdshChatSDKTest.shared.config.pleaseEnterValidEmail)
                    return
                }else{
                    CommonSocket.shared.CommanEmitSokect(command: .emailChatTranscript,data: [[
                        "appSid" : DrdshChatSDKTest.shared.config.appSid,
                        "mid":DrdshChatSDKTest.shared.AllDetails.messageID,
                        "vid":DrdshChatSDKTest.shared.AllDetails.visitorID,
                        "email":self.txtComment.text!]]) { (data) in
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
                CommonSocket.shared.CommanEmitSokect(command: .visitorEndChatSession, data: [[
                    "appSid" : DrdshChatSDKTest.shared.config.appSid,
                    "id":DrdshChatSDKTest.shared.AllDetails.messageID,
                    "vid":DrdshChatSDKTest.shared.AllDetails.visitorID,
                    "name":DrdshChatSDKTest.shared.AllDetails.name,
                    "comment":self.txtComment.text!,
                    "feedback":feedback]]) { (data) in
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
            self.dismiss(animated: true, completion: {
                
            })
        }
        btnCancel1.action = {
           self.dismiss(animated: true, completion: {
               
           })
       }
        btnDisLike.action = {
            self.btnLike.isSelected = false
            self.btnDisLike.isSelected = true
        }
        btnMail.action = {
            
        }
    }
    func showAlertView(str:String){
       let alert = UIAlertController(title: DrdshChatSDKTest.shared.config.error.Local(), message: str.Local(), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: DrdshChatSDKTest.shared.config.ok.Local(), style: UIAlertAction.Style.default, handler: nil))
        DrdshChatSDKTest.shared.topViewController()?.present(alert, animated: true, completion: nil)
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
