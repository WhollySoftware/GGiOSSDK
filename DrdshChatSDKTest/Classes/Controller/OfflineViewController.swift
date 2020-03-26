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

        self.txtFullName.text = GGUserSessionDetail.shared.name
        self.txtMobile.text = GGUserSessionDetail.shared.mobile
        self.txtEmailAddress.text = GGUserSessionDetail.shared.email
        
        txtFullName.placeholder = DrdshChatSDKTest.shared.localizedString(stringKey: "Full Name")
        txtMobile.placeholder = DrdshChatSDKTest.shared.localizedString(stringKey: "Mobile")
        txtEmailAddress.placeholder = DrdshChatSDKTest.shared.localizedString(stringKey: "Email Address")
        txtEmailAddress.placeholder = DrdshChatSDKTest.shared.localizedString(stringKey: "Subject")
        txtTypeYourQuestion.placeholder = DrdshChatSDKTest.shared.localizedString(stringKey: "Type your Question or message")
        btnStart.setTitle(DrdshChatSDKTest.shared.localizedString(stringKey: "Send Message"), for: .normal)
        
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
        barItem.title = "Chat"
        navigationItem.leftBarButtonItem = barItem
        self.setupData()
        // Do any additional setup after loading the view.
    }
    func setupData(){
        DispatchQueue.main.async {
            self.viewEmailAddress.isHidden = !DrdshChatSDKTest.shared.AllDetails.embeddedChat.emailRequired
            self.viewMobile.isHidden = !DrdshChatSDKTest.shared.AllDetails.embeddedChat.mobileRequired
            self.viewTypeYourQuestion.isHidden = !DrdshChatSDKTest.shared.AllDetails.embeddedChat.messageRequired
         self.btnStart.setTitle(DrdshChatSDKTest.shared.AllDetails.embeddedChat.startChatButtonTxt, for: .normal)
            self.btnStart.backgroundColor = DrdshChatSDKTest.shared.config.mainColor
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
            self.showAlertView(str: "Please enter name")
            return
        }else if self.txtEmailAddress.text == "" && DrdshChatSDKTest.shared.AllDetails.embeddedChat.emailRequired{
            self.showAlertView(str: "Please enter Email address")
            return
        }else if self.txtMobile.text == "" && DrdshChatSDKTest.shared.AllDetails.embeddedChat.mobileRequired{
            self.showAlertView(str: "Please enter Mobile")
            return
        }else if self.txtSubject.text == "" && DrdshChatSDKTest.shared.AllDetails.embeddedChat.mobileRequired{
            self.showAlertView(str: "Please enter Subject")
            return
        }else if self.txtTypeYourQuestion.text == "" && DrdshChatSDKTest.shared.AllDetails.embeddedChat.messageRequired{
            self.showAlertView(str: "Please enter Message")
            return
        }
     let validateIdentityAPI: String = DrdshChatSDKTest.shared.APIbaseURL + "send/offline/message"
      var todosUrlRequest = URLRequest(url: URL(string: validateIdentityAPI)!)
      todosUrlRequest.httpMethod = "POST"
      let newTodo: [String: Any] = [
            "appSid" : DrdshChatSDKTest.shared.config.appSid,
            "locale" : DrdshChatSDKTest.shared.config.local,
            "visitorID":DrdshChatSDKTest.shared.AllDetails.visitorID,
            "subject" : self.txtSubject.text!,
            "name": self.txtFullName.text!,
            "mobile": self.txtMobile.text!,
            "email": self.txtEmailAddress.text!,
            "message": self.txtTypeYourQuestion.text!
        ]
    
      let jsonTodo: Data
      do {
        jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
        todosUrlRequest.httpBody = jsonTodo
      } catch {
        print("Error: cannot create JSON from todo")
        return
      }
      todosUrlRequest.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
      todosUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
      todosUrlRequest.setValue(DrdshChatSDKTest.shared.config.local, forHTTPHeaderField: "locale")
      let session = URLSession.shared
        GGProgress.shared.showProgress(isFullLoader:false)
      let task = session.dataTask(with: todosUrlRequest) {
        (data, response, error) in
        DispatchQueue.main.async {
            GGProgress.shared.hideProgress()
        }
        guard error == nil else {
          print("error calling POST on /todos/1",error!)
          return
        }
        guard let responseData = data else {
          print("Error: did not receive data")
          return
        }
        do {
          guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
            options: []) as? [String: Any] else {
              print("Could not get JSON from responseData as dictionary")
              return
          }
            if receivedTodo["message"] as! String == "authorized"{
                 print("Response : " + receivedTodo.description)
            }else{
               
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        let alert = UIAlertController(title: "Error", message: receivedTodo["message"] as? String ?? "", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        DrdshChatSDKTest.shared.topViewController()?.present(alert, animated: true, completion: nil)
                    }
                }
                print("Response : " + receivedTodo.description)
            }
        } catch  {
          print("error parsing response from POST on /todos")
          return
        }
      }
      task.resume()
    }
    func showAlertView(str:String){
        let alert = UIAlertController(title: DrdshChatSDKTest.shared.localizedString(stringKey:"Error"), message: DrdshChatSDKTest.shared.localizedString(stringKey:str), preferredStyle: UIAlertController.Style.alert)
       alert.addAction(UIAlertAction(title: DrdshChatSDKTest.shared.localizedString(stringKey:"Ok"), style: UIAlertAction.Style.default, handler: nil))
       DrdshChatSDKTest.shared.topViewController()?.present(alert, animated: true, completion: nil)
    }
}
