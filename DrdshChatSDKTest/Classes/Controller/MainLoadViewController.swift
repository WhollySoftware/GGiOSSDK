//
//  MainLoadViewController.swift
//  DrdshChatSDK
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
        
        self.title = "chat".Local()
        
        self.txtFullName.text = GGUserSessionDetail.shared.name
        self.txtMobile.text = GGUserSessionDetail.shared.mobile
        self.txtEmailAddress.text = GGUserSessionDetail.shared.email
        //        txtFullName.placeholder = DrdshChatSDKTest.shared.localizedString(stringKey: "Full Name")
        //        txtMobile.placeholder = DrdshChatSDKTest.shared.localizedString(stringKey: "Mobile")
        //        txtEmailAddress.placeholder = DrdshChatSDKTest.shared.localizedString(stringKey: "Email Address")
        //        txtTypeYourQuestion.placeholder = DrdshChatSDKTest.shared.localizedString(stringKey: "Type your Question or message")
        //        btnStart.setTitle(DrdshChatSDKTest.shared.localizedString(stringKey: "Start Chat"), for: .normal)
        if DrdshChatSDKTest.shared.config.local == "ar"{
            self.txtFullName.textAlignment = .right
            self.txtMobile.textAlignment = .right
            self.txtEmailAddress.textAlignment = .right
            self.txtTypeYourQuestion.textAlignment = .right
        }
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = DrdshChatSDKTest.shared.config.done.Local()
        IQKeyboardManager.shared.disabledToolbarClasses = [ChatViewController.self]
        btnStart.action = {
            self.startChat()
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,.font : UIFont.init(name: "AvenirLTStd-Black", size: 17.0) ?? UIFont.boldSystemFont(ofSize: 17)]
        var backImage = DrdshChatSDKTest.shared.config.backImage
        if DrdshChatSDKTest.shared.config.local == "ar"{
            backImage = backImage.rotate(radians: .pi)
        }
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = DrdshChatSDKTest.shared.config.topBarBgColor.Color()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let barItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(dissmissView))
        barItem.title = DrdshChatSDKTest.shared.localizedString(stringKey:"Chat")
        navigationItem.leftBarButtonItem = barItem
        self.btnStart.backgroundColor = DrdshChatSDKTest.shared.config.topBarBgColor.Color()
        makePostCall()
        CommonSocket.shared.inviteVisitorListener { data in
            DrdshChatSDKTest.shared.AllDetails.visitorConnectedStatus = 2
            DrdshChatSDKTest.shared.AgentDetail <= data
            DrdshChatSDKTest.shared.AllDetails.agentId = data["agent_id"] as? String ?? ""
            DrdshChatSDKTest.shared.AgentDetail.agent_name = data["agent_name"] as? String ?? ""
            DrdshChatSDKTest.shared.AgentDetail.visitor_message_id = data["visitor_message_id"] as? String ?? ""
            DrdshChatSDKTest.shared.AllDetails.agentOnline = data["agentOnline"] as? Int ?? 0
            DrdshChatSDKTest.shared.AllDetails.messageID = data["visitor_message_id"] as? String ?? ""
            
            var newTodo: [String: Any] =  DrdshChatSDKTest.shared.AllDetails.toDict
            newTodo["embeddedChat"] = DrdshChatSDKTest.shared.AllDetails.embeddedChat.toDict
            UserDefaults.standard.setValue(newTodo, forKey: "AllDetails")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            self.navigationController?.pushViewController(vc, animated: true)
            CommonSocket.shared.CommanEmitSokect(command: .joinAgentRoom,data: [[
                "agent_id":DrdshChatSDKTest.shared.AllDetails.agentId]]) { receivedTodo in
                    
            }
        }
    }
    func setupData(){
        DispatchQueue.main.async {
            
            self.viewEmailAddress.isHidden = DrdshChatSDKTest.shared.AllDetails.embeddedChat.emailRequired == 0
            self.viewMobile.isHidden = DrdshChatSDKTest.shared.AllDetails.embeddedChat.mobileRequired == 0
            self.viewTypeYourQuestion.isHidden = DrdshChatSDKTest.shared.AllDetails.embeddedChat.messageRequired == 0
            self.txtFullName.placeholder = DrdshChatSDKTest.shared.config.fieldPlaceholderName.Local()
            self.txtMobile.placeholder = DrdshChatSDKTest.shared.config.fieldPlaceholderMobile.Local()
            self.txtEmailAddress.placeholder = DrdshChatSDKTest.shared.config.fieldPlaceholderEmail.Local()
            self.txtTypeYourQuestion.placeholder = DrdshChatSDKTest.shared.config.fieldPlaceholderMessage.Local()
            self.btnStart.setTitle( DrdshChatSDKTest.shared.config.startChatButtonTxt.Local(), for: .normal)
            self.view.backgroundColor = DrdshChatSDKTest.shared.config.bgColor.Color()
            self.navigationController?.navigationBar.barTintColor = DrdshChatSDKTest.shared.config.topBarBgColor.Color()
            self.btnStart.backgroundColor = DrdshChatSDKTest.shared.config.buttonColor.Color()
        }
    }
    func makePostCall() {
        let validateIdentityAPI: String = DrdshChatSDKTest.shared.APIbaseURL + "validate-identity"
        var todosUrlRequest = URLRequest(url: URL(string: validateIdentityAPI)!)
        todosUrlRequest.httpMethod = "POST"
        
        let browser = Bundle.main.bundleIdentifier!+",AppVersion:"+"\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"+",BuildVersion:"+"\(Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? "")"
        var newTodo: [String: Any] = [
            "appSid" : DrdshChatSDKTest.shared.config.appSid,
            "locale" : DrdshChatSDKTest.shared.config.local,
            "expandWidth": self.view.frame.width.description,
            "expendHeight": self.view.frame.height.description,
            "deviceID": UIDevice.current.identifierForVendor?.uuidString ?? "",
            "ipAddress": "192.168.1.2",
            "device": "ios",
            "timeZone" : TimeZone.current.identifier,
            "browser": browser,
            "name":self.txtFullName.text!,
            "email":self.txtEmailAddress.text!,
            "mobile":self.txtMobile.text!,
            "domain": "www.drdsh.live"
        ]
        if DrdshChatSDKTest.shared.AllDetails.visitorID != ""{
            newTodo["visitorID"] = DrdshChatSDKTest.shared.AllDetails.visitorID
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
        todosUrlRequest.setValue(DrdshChatSDKTest.shared.config.local, forHTTPHeaderField: "locale")
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
                if receivedTodo["message"] as! String == "Authorized"{
                    if let d = receivedTodo["data"] as? [String:AnyObject]{
                        print("Response : " + receivedTodo.description)
                        DrdshChatSDKTest.shared.AllDetails <= d
                        var newTodo: [String: Any] =  DrdshChatSDKTest.shared.AllDetails.toDict
                        DrdshChatSDKTest.shared.config.mapServerData(to: DrdshChatSDKTest.shared.AllDetails.embeddedChat.toDict)
                        self.setupData()
                        newTodo["embeddedChat"] = DrdshChatSDKTest.shared.AllDetails.embeddedChat.toDict
                        UserDefaults.standard.setValue(newTodo, forKey: "AllDetails")
                        
                        if DrdshChatSDKTest.shared.AllDetails.visitorConnectedStatus == 1 || DrdshChatSDKTest.shared.AllDetails.visitorConnectedStatus == 2{
                            if DrdshChatSDKTest.shared.AllDetails.visitorConnectedStatus == 1{
                                if !DrdshChatSDKTest.shared.AllDetails.embeddedChat.displayForm{
                                    self.startChat(isDirect: true)
                                    return
                                }
                            }
                            DispatchQueue.main.async {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                                self.navigationController?.pushViewController(vc, animated: false)
                            }
                        }
                        CommonSocket.shared.initSocket { (status) in
                            CommonSocket.shared.CommanEmitSokect(command: .joinVisitorsRoom,data:[["dc_vid":DrdshChatSDKTest.shared.AllDetails.visitorID]]){ data in
                                if DrdshChatSDKTest.shared.AllDetails.visitorConnectedStatus == 2{
                                    DrdshChatSDKTest.shared.AgentDetail <= data
                                    DrdshChatSDKTest.shared.AllDetails.agentId = data["agent_id"] as? String ?? ""
                                    DrdshChatSDKTest.shared.AgentDetail.agent_name = data["agent_name"] as! String
                                    DrdshChatSDKTest.shared.AgentDetail.visitor_message_id = data["visitor_message_id"] as! String
                                }
                                debugPrint(data)
                            }
                        }
                    }
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
    func startChat(isDirect:Bool = false) {
        if !isDirect{
            if self.txtFullName.text == ""{
                self.showAlertView(str: DrdshChatSDKTest.shared.config.pleaseEnterName)
                return
            }else if self.txtEmailAddress.text == "" && DrdshChatSDKTest.shared.AllDetails.embeddedChat.emailRequired == 2{
                self.showAlertView(str: DrdshChatSDKTest.shared.config.pleaseEnterEmailAddress)
                return
            }else if DrdshChatSDKTest.shared.AllDetails.embeddedChat.emailRequired == 2 && !self.txtEmailAddress.text!.isValidEmail{
                self.showAlertView(str: DrdshChatSDKTest.shared.config.pleaseEnterValidEmail)
                return
            }else if self.txtMobile.text == "" && DrdshChatSDKTest.shared.AllDetails.embeddedChat.mobileRequired == 2{
                self.showAlertView(str: DrdshChatSDKTest.shared.config.pleaseEnterMobile)
                return
            }
            else if self.txtTypeYourQuestion.text == "" && DrdshChatSDKTest.shared.AllDetails.embeddedChat.mobileRequired == 2{
                self.showAlertView(str: DrdshChatSDKTest.shared.config.pleaseEnterMessage)
                return
            }
        }
        let newTodo: [String: Any] = [
            "locale" : DrdshChatSDKTest.shared.config.local,
            "_id":DrdshChatSDKTest.shared.AllDetails.visitorID,
            "name": self.txtFullName.text != "" ? self.txtFullName.text! : "Guest",
            "mobile": self.txtMobile.text!,
            "email": self.txtEmailAddress.text!,
            "message": self.txtTypeYourQuestion.text!
        ]
        CommonSocket.shared.CommanEmitSokect(command: .inviteChat,data: [newTodo]) { receivedTodo in
            print("Response : " + receivedTodo.description)
            DrdshChatSDKTest.shared.AllDetails.agentOnline = receivedTodo["agentOnline"] as? Int ?? 0
            DrdshChatSDKTest.shared.AllDetails.visitorConnectedStatus = 2
            DrdshChatSDKTest.shared.AllDetails.messageID = receivedTodo["visitor_message_id"] as? String ?? ""
            
            var newTodo: [String: Any] =  DrdshChatSDKTest.shared.AllDetails.toDict
            newTodo["embeddedChat"] = DrdshChatSDKTest.shared.AllDetails.embeddedChat.toDict
            UserDefaults.standard.setValue(newTodo, forKey: "AllDetails")
            DispatchQueue.main.async {
                GGUserSessionDetail.shared.name = self.txtFullName.text!
                GGUserSessionDetail.shared.mobile = self.txtMobile.text!
                GGUserSessionDetail.shared.email = self.txtEmailAddress.text!
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func showAlertView(str:String){
        
        let alert = UIAlertController(title: DrdshChatSDKTest.shared.config.error.Local(), message: str.Local(), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: DrdshChatSDKTest.shared.config.ok.Local(), style: UIAlertAction.Style.default, handler: nil))
        DrdshChatSDKTest.shared.topViewController()?.present(alert, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupData()
        self.txtTypeYourQuestion.text = ""
    }
    @objc func dissmissView(){
        CommonSocket.shared.disConnect()
        self.dismiss(animated: true, completion: nil)
    }
}
extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        
        return self
    }
}
