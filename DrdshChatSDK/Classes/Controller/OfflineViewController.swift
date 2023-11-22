//
//  OfflineViewController.swift
//  DrdshChatSDK
//
//  Created by Gaurav Gudaliya R on 20/03/20.
//

import UIKit

class OfflineViewController: UIViewController {

   @IBOutlet weak var btnStart: GGButton!
   @IBOutlet weak var txtFullName: UITextField!
   @IBOutlet weak var txtEmailAddress: UITextField!
   @IBOutlet weak var txtMobile: UITextField!
   @IBOutlet weak var txtTypeYourQuestion: UITextField!
   @IBOutlet weak var txtSubject: UITextField!
   
   @IBOutlet weak var viewFullName: GGView!
   @IBOutlet weak var viewEmailAddress: GGView!
   @IBOutlet weak var viewMobile: GGView!
   @IBOutlet weak var viewTypeYourQuestion: GGView!
   @IBOutlet weak var viewSubject: GGView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = DrdshChatSDK.shared.localizedString(stringKey:"offline")
        self.view.backgroundColor = DrdshChatSDK.shared.config.bgColor.Color()
        self.txtFullName.text = GGUserSessionDetail.shared.name
        self.txtMobile.text = GGUserSessionDetail.shared.mobile
        self.txtEmailAddress.text = GGUserSessionDetail.shared.email
    
        if DrdshChatSDK.shared.config.local == "ar"{
            self.txtFullName.textAlignment = .right
            self.txtMobile.textAlignment = .right
            self.txtEmailAddress.textAlignment = .right
            self.txtSubject.textAlignment = .right
            self.txtTypeYourQuestion.textAlignment = .right
        }
        self.btnStart.setTitle(DrdshChatSDK.shared.localizedString(stringKey:"sendMessage"), for: .normal)
        var backImage = DrdshChatSDK.shared.config.backImage
        if DrdshChatSDK.shared.config.local == "ar"{
            backImage = backImage.rotate(radians: .pi)
        }
        let barItem = UIBarButtonItem(image:  backImage, style: .plain, target: self, action: #selector(dissmissView))
        navigationItem.leftBarButtonItem = barItem
        self.setupData()
        btnStart.action = {
           self.SendOfflineMsg()
       }
        // Do any additional setup after loading the view.
    }
    func setupData(){
        DispatchQueue.main.async {
            self.viewEmailAddress.isHidden = false
            self.viewMobile.isHidden = !DrdshChatSDK.shared.AllDetails.embeddedChat.offlineMsgShowMobileBox
            self.viewSubject.isHidden = !DrdshChatSDK.shared.AllDetails.embeddedChat.offlineMsgShowSubjectBox
            self.btnStart.backgroundColor = DrdshChatSDK.shared.config.topBarBgColor.Color()
            self.txtFullName.placeholder = DrdshChatSDK.shared.config.fieldPlaceholderName.Local()
            self.txtMobile.placeholder = DrdshChatSDK.shared.config.fieldPlaceholderMobile.Local()
            self.txtEmailAddress.placeholder = DrdshChatSDK.shared.config.fieldPlaceholderEmail.Local()
            self.txtTypeYourQuestion.placeholder = DrdshChatSDK.shared.config.fieldPlaceholderMessage.Local()
            self.btnStart.backgroundColor = DrdshChatSDK.shared.config.buttonColor.Color()
        }
    }
    @objc func dissmissView(){
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: MainLoadViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
        //self.dismiss(animated: true, completion: nil)
    }
    func SendOfflineMsg() {
        if self.txtFullName.text == ""{
            self.showAlertView(str: DrdshChatSDK.shared.config.pleaseEnterName)
            return
        }else if self.txtEmailAddress.text == ""{
            self.showAlertView(str: DrdshChatSDK.shared.config.pleaseEnterEmailAddress)
            return
        }else if !self.txtEmailAddress.text!.isValidEmail{
            self.showAlertView(str: DrdshChatSDK.shared.config.pleaseEnterValidEmail)
            return
        }else if self.txtMobile.text == "" && DrdshChatSDK.shared.AllDetails.embeddedChat.offlineMsgShowMobileBox{
            self.showAlertView(str: DrdshChatSDK.shared.config.pleaseEnterMobile)
            return
        }else if self.txtSubject.text == "" && DrdshChatSDK.shared.AllDetails.embeddedChat.offlineMsgShowSubjectBox{
            self.showAlertView(str: DrdshChatSDK.shared.config.pleaseEnterSubject)
            return
        }else if self.txtTypeYourQuestion.text == ""{
            self.showAlertView(str: DrdshChatSDK.shared.config.pleaseEnterMessage)
            return
        }
        
      let newTodo: [String: Any] = [
            "appSid" : DrdshChatSDK.shared.config.appSid,
            "locale" : DrdshChatSDK.shared.config.local,
            "_id":DrdshChatSDK.shared.AllDetails.visitorID,
            "subject" : self.txtSubject.text!,
            "name": self.txtFullName.text!,
            "mobile": self.txtMobile.text!,
            "email": self.txtEmailAddress.text!,
            "message": self.txtTypeYourQuestion.text!
        ]
        CommonSocket.shared.CommanEmitSokect(command: .submitOfflineMessage,data: [newTodo]) { receivedTodo in
            self.txtTypeYourQuestion.text = ""
            self.showAlertView(str: receivedTodo["message"] as? String ?? "")
        }
    }
    func showAlertView(str:String){
         let alert = UIAlertController(title: nil, message: str.Local(), preferredStyle: UIAlertController.Style.alert)
         alert.addAction(UIAlertAction(title: DrdshChatSDK.shared.config.ok.Local(), style: UIAlertAction.Style.default, handler: nil))
         DrdshChatSDK.shared.topViewController()?.present(alert, animated: true, completion: nil)
    }
}
