//
//  MainLoadViewController.swift
//  GGiOSSDK
//
//  Created by Gaurav Gudaliya R on 14/03/20.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift
class MainLoadViewController: UIViewController {
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
        self.title = "Chat"
        IQKeyboardManager.shared.enable = true
        var bundle = Bundle(for: GGiOSSDK.self)
        if let resourcePath = bundle.path(forResource: "GGiOSSDK", ofType: "bundle") {
            if let resourcesBundle = Bundle(path: resourcePath) {
                bundle = resourcesBundle
            }
        }
        btnStart.action = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,.font : UIFont.init(name: "AvenirLTStd-Black", size: 17.0) ?? UIFont.boldSystemFont(ofSize: 17)]
        let backImage = UIImage(named: "back", in: bundle, compatibleWith: nil)
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor(hexCode:0x322D33)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let barItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(dissmissView))
        barItem.title = "Chat"
        navigationItem.leftBarButtonItem = barItem
        makePostCall()
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
    func makePostCall() {
     let validateIdentityAPI: String = GGiOSSDK.shared.APIbaseURL + "validate-identity"
      var todosUrlRequest = URLRequest(url: URL(string: validateIdentityAPI)!)
      todosUrlRequest.httpMethod = "POST"
      let newTodo: [String: Any] = [
            "appSid" : GGiOSSDK.shared.appSid,
            "locale" : "en",
            "expandWidth": self.view.frame.width.description,
            "expendHeight": self.view.frame.height.description,
            "deviceID": "ABC12345",
            "ipAddress": "192.168.1.2",
            "browser": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:73.0)",
            "domain": "drdsh.live",
            //"name": "Virendra Kumar",
            //"email": "virendra@htf.sa",
            //"mobile": "9990418225",
            //"fullUrl": "https://www.drdsh.live/contact/us",
            //"metaTitle": "Contact Us",
            //"resolution": "750x300",
           //"visitorID" : "5e637ccae4cb961e36dfb5a5"
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
      GGProgress.shared.showProgress()
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
                    GGiOSSDK.shared.AllDetails <= d
                    self.setupData()
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
    @objc func dissmissView(){
        self.dismiss(animated: true, completion: nil)
    }
}
