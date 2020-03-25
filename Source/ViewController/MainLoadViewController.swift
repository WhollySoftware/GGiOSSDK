//
//  MainLoadViewController.swift
//  GGiOSSDK
//
//  Created by Gaurav Gudaliya R on 14/03/20.
//

import UIKit
import IQKeyboardManagerSwift
class MainLoadViewController: UIViewController {
    @IBOutlet weak var btnStart: GGButton!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtTypeYourQuestion: UITextField!
    
    @IBOutlet weak var viewFullName: GGView!
    @IBOutlet weak var viewEmailAddress: GGView!
    @IBOutlet weak var viewMobile: GGView!
    @IBOutlet weak var viewTypeYourQuestion: GGView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chat"
        
        self.txtFullName.text = GGUserSessionDetail.shared.name
        self.txtMobile.text = GGUserSessionDetail.shared.mobile
        self.txtEmailAddress.text = GGUserSessionDetail.shared.email
        
        
        IQKeyboardManager.shared.enable = true
        var bundle = Bundle(for: GGiOSSDK.self)
        if let resourcePath = bundle.path(forResource: "GGiOSSDK", ofType: "bundle") {
            if let resourcesBundle = Bundle(path: resourcePath) {
                bundle = resourcesBundle
            }
        }
        btnStart.action = {
            self.startChat()
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
      var newTodo: [String: Any] = [
            "appSid" : GGiOSSDK.shared.appSid,
            "locale" : "en",
            "expandWidth": self.view.frame.width.description,
            "expendHeight": self.view.frame.height.description,
            "deviceID": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "ipAddress": "192.168.1.2",
            "browser": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:73.0)",
            "domain": "drdsh.live",
            //"fullUrl": "https://www.drdsh.live/contact/us",
            //"metaTitle": "Contact Us",
            //"resolution": "750x300",
           //"visitorID" : "5e637ccae4cb961e36dfb5a5"
        ]
        if GGiOSSDK.shared.AllDetails.visitorID != ""{
            newTodo["visitorID"] = GGiOSSDK.shared.AllDetails.visitorID
             newTodo["name"] = GGUserSessionDetail.shared.name
             newTodo["email"] = GGUserSessionDetail.shared.email
             newTodo["mobile"] = GGUserSessionDetail.shared.mobile
        }
        if getIFAddresses().count > 0{
            newTodo["ipAddress"] = getIFAddresses()[0]
        }
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
                    var newTodo: [String: Any] =  GGiOSSDK.shared.AllDetails.toDict
                    newTodo["embeddedChat"] = GGiOSSDK.shared.AllDetails.embeddedChat.toDict
                    UserDefaults.standard.setValue(newTodo, forKey: "AllDetails")
                    
                    if GGiOSSDK.shared.AllDetails.visitorConnectedStatus == 1 || GGiOSSDK.shared.AllDetails.visitorConnectedStatus == 2{
                        DispatchQueue.main.async {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                            self.navigationController?.pushViewController(vc, animated: false)
                        }
                    }
                    CommonSocket.shared.initSocket { (status) in
                        var strStatus = ""
                        if GGiOSSDK.shared.AllDetails.visitorConnectedStatus == 2{
                            strStatus = "ignore_request"
                        }else{
                            strStatus = "site_visitor"
                        }
                        CommonSocket.shared.joinVisitorsRoom(data: [["dc_id":GGiOSSDK.shared.AllDetails.companyId,"dc_name":GGiOSSDK.shared.AllDetails.name,"dc_vid":GGiOSSDK.shared.AllDetails.visitorID,"dc_online":strStatus]]){ data in
                            if GGiOSSDK.shared.AllDetails.visitorConnectedStatus == 2{
                                GGiOSSDK.shared.AgentDetail <= data
                                GGiOSSDK.shared.AllDetails.agentId = data["agent_id"] as! String
                                 GGiOSSDK.shared.AgentDetail.agent_name = data["name"] as! String
                                 GGiOSSDK.shared.AgentDetail.visitor_message_id = data["mid"] as! String
                            }
                            debugPrint(data)
                        }
                    }
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
    func getIFAddresses() -> [String] {
        var addresses = [String]()

        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }

        // For each interface ...
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let flags = Int32(ptr.pointee.ifa_flags)
            let addr = ptr.pointee.ifa_addr.pointee

            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {

                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    if (getnameinfo(ptr.pointee.ifa_addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                                    nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                        let address = String(cString: hostname)
                        if address.count <= 16{
                            addresses.append(address)
                        }
                    }
                }
            }
        }

        freeifaddrs(ifaddr)
        return addresses
    }
    func startChat() {
        if self.txtFullName.text == ""{
            self.showAlertView(str: "Please enter name")
            return
        }else if self.txtEmailAddress.text == "" && GGiOSSDK.shared.AllDetails.embeddedChat.emailRequired{
            self.showAlertView(str: "Please enter Email address")
            return
        }else if self.txtMobile.text == "" && GGiOSSDK.shared.AllDetails.embeddedChat.mobileRequired{
            self.showAlertView(str: "Please enter Mobile")
            return
        }else if self.txtTypeYourQuestion.text == "" && GGiOSSDK.shared.AllDetails.embeddedChat.messageRequired{
            self.showAlertView(str: "Please enter Message")
            return
        }
     let validateIdentityAPI: String = GGiOSSDK.shared.APIbaseURL + "initiate/chat"
      var todosUrlRequest = URLRequest(url: URL(string: validateIdentityAPI)!)
      todosUrlRequest.httpMethod = "POST"
      let newTodo: [String: Any] = [
            "appSid" : GGiOSSDK.shared.appSid,
            "locale" : "en",
            "visitorID":GGiOSSDK.shared.AllDetails.visitorID,
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
            if receivedTodo["message"] as! String == "waiting_for_agent"{
                if let d = receivedTodo["data"] as? [String:AnyObject]{
                    print("Response : " + receivedTodo.description)
                    GGiOSSDK.shared.AllDetails.agentOnline = d["agentOnline"] as? Int ?? 0
                    GGiOSSDK.shared.AllDetails.visitorConnectedStatus = d["visitorConnectedStatus"] as? Int ?? 0
                    GGiOSSDK.shared.AllDetails.messageID = d["messageID"] as? String ?? ""
                    GGUserSessionDetail.shared.name = self.txtFullName.text!
                    GGUserSessionDetail.shared.mobile = self.txtMobile.text!
                    GGUserSessionDetail.shared.email = self.txtEmailAddress.text!
                    var newTodo: [String: Any] =  GGiOSSDK.shared.AllDetails.toDict
                    newTodo["embeddedChat"] = GGiOSSDK.shared.AllDetails.embeddedChat.toDict
                    CommonSocket.shared.startChatRequest(data: [["dc_vid":GGiOSSDK.shared.AllDetails.visitorID]])
                    UserDefaults.standard.setValue(newTodo, forKey: "AllDetails")
                    DispatchQueue.main.async {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }else{
               
                DispatchQueue.main.async {
                     self.showAlertView(str: receivedTodo["message"] as? String ?? "")
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
        let alert = UIAlertController(title: "Error", message: str, preferredStyle: UIAlertController.Style.alert)
       alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
       GGiOSSDK.shared.topViewController()?.present(alert, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.txtTypeYourQuestion.text = ""
    }
    @objc func dissmissView(){
        CommonSocket.shared.disConnect()
        self.dismiss(animated: true, completion: nil)
    }
}
