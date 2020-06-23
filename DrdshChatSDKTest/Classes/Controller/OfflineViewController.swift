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
        self.title = "Offline"
        self.view.backgroundColor = DrdshChatSDKTest.shared.config.bgColor.Color()
        self.txtFullName.text = GGUserSessionDetail.shared.name
        self.txtMobile.text = GGUserSessionDetail.shared.mobile
        self.txtEmailAddress.text = GGUserSessionDetail.shared.email
    
        if DrdshChatSDKTest.shared.config.local == "ar"{
            self.txtFullName.textAlignment = .right
            self.txtMobile.textAlignment = .right
            self.txtEmailAddress.textAlignment = .right
            self.txtSubject.textAlignment = .right
            self.txtTypeYourQuestion.textAlignment = .right
        }
        var backImage = DrdshChatSDKTest.shared.config.backImage
        if DrdshChatSDKTest.shared.config.local == "ar"{
            backImage = backImage.rotate(radians: .pi)
        }
        let barItem = UIBarButtonItem(image:  backImage, style: .plain, target: self, action: #selector(dissmissView))
        barItem.title = DrdshChatSDKTest.shared.localizedString(stringKey:"Chat")
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
            self.viewMobile.isHidden = !DrdshChatSDKTest.shared.AllDetails.embeddedChat.offlineMsgShowMobileBox
            self.viewSubject.isHidden = !DrdshChatSDKTest.shared.AllDetails.embeddedChat.offlineMsgShowSubjectBox
            self.btnStart.backgroundColor = DrdshChatSDKTest.shared.config.topBarBgColor.Color()
            self.txtFullName.placeholder = DrdshChatSDKTest.shared.config.fieldPlaceholderName.Local()
            self.txtMobile.placeholder = DrdshChatSDKTest.shared.config.fieldPlaceholderMobile.Local()
            self.txtEmailAddress.placeholder = DrdshChatSDKTest.shared.config.fieldPlaceholderEmail.Local()
            self.txtTypeYourQuestion.placeholder = DrdshChatSDKTest.shared.config.fieldPlaceholderMessage.Local()
            self.btnStart.backgroundColor = DrdshChatSDKTest.shared.config.buttonColor.Color()
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
            self.showAlertView(str: DrdshChatSDKTest.shared.config.pleaseEnterName)
            return
        }else if self.txtEmailAddress.text == ""{
            self.showAlertView(str: DrdshChatSDKTest.shared.config.pleaseEnterEmailAddress)
            return
        }else if !self.txtEmailAddress.text!.isValidEmail{
            self.showAlertView(str: DrdshChatSDKTest.shared.config.pleaseEnterValidEmail)
            return
        }else if self.txtMobile.text == "" && DrdshChatSDKTest.shared.AllDetails.embeddedChat.offlineMsgShowMobileBox{
            self.showAlertView(str: DrdshChatSDKTest.shared.config.pleaseEnterMobile)
            return
        }else if self.txtSubject.text == "" && DrdshChatSDKTest.shared.AllDetails.embeddedChat.offlineMsgShowSubjectBox{
            self.showAlertView(str: DrdshChatSDKTest.shared.config.pleaseEnterSubject)
            return
        }else if self.txtTypeYourQuestion.text == ""{
            self.showAlertView(str: DrdshChatSDKTest.shared.config.pleaseEnterMessage)
            return
        }
        
      let newTodo: [String: Any] = [
            "appSid" : DrdshChatSDKTest.shared.config.appSid,
            "locale" : DrdshChatSDKTest.shared.config.local,
            "_id":DrdshChatSDKTest.shared.AllDetails.visitorID,
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
         alert.addAction(UIAlertAction(title: DrdshChatSDKTest.shared.config.ok.Local(), style: UIAlertAction.Style.default, handler: nil))
         DrdshChatSDKTest.shared.topViewController()?.present(alert, animated: true, completion: nil)
    }
}
