//
//  OfflineViewController.swift
//  GGiOSSDK
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
        
        let barItem = UIBarButtonItem(image:  GGiOSSDK.shared.config.backImage, style: .plain, target: self, action: #selector(dissmissView))
        barItem.title = "Chat"
        navigationItem.leftBarButtonItem = barItem
        self.setupData()
        // Do any additional setup after loading the view.
    }
    func setupData(){
        DispatchQueue.main.async {
            self.viewEmailAddress.isHidden = !GGiOSSDK.shared.AllDetails.embeddedChat.emailRequired
            self.viewMobile.isHidden = !GGiOSSDK.shared.AllDetails.embeddedChat.mobileRequired
            self.viewTypeYourQuestion.isHidden = !GGiOSSDK.shared.AllDetails.embeddedChat.messageRequired
         self.btnStart.setTitle(GGiOSSDK.shared.AllDetails.embeddedChat.startChatButtonTxt, for: .normal)
            self.btnStart.backgroundColor = UIColor(hexCode:0x322D33)
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
     let validateIdentityAPI: String = GGiOSSDK.shared.APIbaseURL + "send/offline/message"
      var todosUrlRequest = URLRequest(url: URL(string: validateIdentityAPI)!)
      todosUrlRequest.httpMethod = "POST"
      let newTodo: [String: Any] = [
            "appSid" : GGiOSSDK.shared.appSid,
            "locale" : "en",
            "visitorID":GGiOSSDK.shared.AllDetails.visitorID,
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
      todosUrlRequest.setValue("en", forHTTPHeaderField: "locale")
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
                if let d = receivedTodo["data"] as? [String:AnyObject]{
                    print("Response : " + receivedTodo.description)
                }
            }else{
               
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        let alert = UIAlertController(title: "Error", message: receivedTodo["message"] as? String ?? "", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        GGiOSSDK.shared.topViewController()?.present(alert, animated: true, completion: nil)
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
}
