//
//  ChatViewController.swift
//  GGiOSSDK
//
//  Created by Gaurav Gudaliya R on 16/03/20.
//

import UIKit
import MobileCoreServices

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var btnSend: GGButton!
    @IBOutlet weak var btnLike: GGButton!
    @IBOutlet weak var btnDisLike: GGButton!
    @IBOutlet weak var btnMail: GGButton!
    @IBOutlet weak var btnAttachment: GGButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var agentView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var typingView: UIView!
    @IBOutlet weak var lblTyping: UILabel!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var txtMessage: UITextField!
    var timer:Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.agentView.isHidden = true
        timer = Timer(timeInterval: 120, target: self, selector: #selector(invitationMaxWaitTimeExceeded), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        if GGiOSSDK.shared.AllDetails.visitorConnectedStatus != 2{
            CommonSocket.shared.startChatRequest(data: [["dc_vid":GGiOSSDK.shared.AllDetails.visitorID]])
        }else if GGiOSSDK.shared.AllDetails.visitorConnectedStatus == 2{
            CommonSocket.shared.startChatRequest(data: [["dc_vid":GGiOSSDK.shared.AllDetails.visitorID]])
        }
        CommonSocket.shared.visitorLoadChatHistory(data: [["mid":GGiOSSDK.shared.AllDetails.messageID]]) { (data) in
            debugPrint(data)
        }
        var bundle = Bundle(for: GGiOSSDK.self)
        if let resourcePath = bundle.path(forResource: "GGiOSSDK", ofType: "bundle") {
            if let resourcesBundle = Bundle(path: resourcePath) {
                bundle = resourcesBundle
            }
        }
        self.table.tableFooterView = UIView()
        btnSend.setImage(UIImage(named: "send", in: bundle, compatibleWith: nil), for: .normal)
        btnLike.setImage(UIImage(named: "like", in: bundle, compatibleWith: nil), for: .normal)
        btnDisLike.setImage(UIImage(named: "dislike", in: bundle, compatibleWith: nil), for: .normal)
        btnMail.setImage(UIImage(named: "mail", in: bundle, compatibleWith: nil), for: .normal)
        btnAttachment.setImage(UIImage(named: "attchment", in: bundle, compatibleWith: nil), for: .normal)
        imgView.image = UIImage(named: "user", in: bundle, compatibleWith: nil)
        
        let backImage = UIImage(named: "back", in: bundle, compatibleWith: nil)
        let barItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = barItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Chat Close", style: .plain, target: self, action: #selector(dissmissView))
        
        btnSend.action = {
            CommonSocket.shared.updateVisitorRating(data: [["mid":GGiOSSDK.shared.AllDetails.messageID,"vid":GGiOSSDK.shared.AllDetails.visitorID,"feedback":"bad"]])
        }
        btnLike.action = {
            CommonSocket.shared.updateVisitorRating(data: [["mid":GGiOSSDK.shared.AllDetails.messageID,"vid":GGiOSSDK.shared.AllDetails.visitorID,"feedback":"good"]])
        }
        btnDisLike.action = {
            CommonSocket.shared.updateVisitorRating(data: [["mid":GGiOSSDK.shared.AllDetails.messageID,"vid":GGiOSSDK.shared.AllDetails.visitorID,"feedback":"bad"]])
        }
        btnMail.action = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RateViewController") as! RateViewController
           vc.modalPresentationStyle = .overFullScreen
           vc.type = 2
           vc.successHandler = {
               
           }
           self.present(vc, animated: true) {
               
           }
        }
        btnAttachment.action = {
           AGImagePickerController(with: self, allowsEditing: false, media: .both, iPadSetup: self.btnAttachment)
        }
    }
    @objc func invitationMaxWaitTimeExceeded(){
        timer.invalidate()
        CommonSocket.shared.invitationMaxWaitTimeExceeded(data: [["vid":GGiOSSDK.shared.AllDetails.visitorID,"form":GGiOSSDK.shared.AllDetails.embeddedChat.displayForm]]) { (data) in
            debugPrint(data)
            
        }
    }
    @objc func backAction(){
        self.timer.invalidate()
        self.navigationController?.popViewController(animated: true)
    }
    @objc func dissmissView(){
        self.timer.invalidate()
        if GGiOSSDK.shared.AllDetails.embeddedChat.postChatPromptComments{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RateViewController") as! RateViewController
            vc.modalPresentationStyle = .overFullScreen
            vc.successHandler = {
                CommonSocket.shared.disConnect()
                self.dismiss(animated: false) {
                    
                }
            }
            self.present(vc, animated: true) {
                
            }
        }else{
            CommonSocket.shared.visitorEndChatSession(data: [["id":GGiOSSDK.shared.AllDetails.companyId,"vid":GGiOSSDK.shared.AllDetails.visitorID,"name":GGiOSSDK.shared.AllDetails.name]]) { (data) in
                debugPrint(data)
                CommonSocket.shared.disConnect()
                self.dismiss(animated: false) {
                    
                }
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        CommonSocket.shared.ipBlocked { data in
            self.timer.invalidate()
        }
        CommonSocket.shared.totalOnlineAgents { data in
            
        }
        CommonSocket.shared.agentAcceptedChatRequest { data in
            self.timer.invalidate()
            self.agentView.isHidden = false
        }
        CommonSocket.shared.agentSendNewMessage { data in
            
        }
        CommonSocket.shared.agentChatSessionTerminated { data in
            self.timer.invalidate()
            self.agentView.isHidden = true
            self.messageView.isHidden = true
        }
        CommonSocket.shared.agentTypingListener { data in
             self.typingView.isHidden = false
        }
        CommonSocket.shared.newAgentAcceptedChatRequest { data in
            self.agentView.isHidden = false
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row%2 == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTableViewCell", for: indexPath) as! SenderTableViewCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverTableViewCell", for: indexPath) as! ReceiverTableViewCell
            return cell
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        CommonSocket.shared.visitorTyping(data: [["vid":GGiOSSDK.shared.AllDetails.visitorID,"id":GGiOSSDK.shared.AllDetails.companyId,"agent_id":GGiOSSDK.shared.AllDetails.agentId,"ts":1,"message":GGiOSSDK.shared.AllDetails.name+" start typing...","stop":false]])
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        CommonSocket.shared.visitorTyping(data: [["vid":GGiOSSDK.shared.AllDetails.visitorID,"id":GGiOSSDK.shared.AllDetails.companyId,"agent_id":GGiOSSDK.shared.AllDetails.agentId,"ts":0,"message":GGiOSSDK.shared.AllDetails.name+" is typing...","stop":true]])
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        CommonSocket.shared.visitorTyping(data: [["vid":GGiOSSDK.shared.AllDetails.visitorID,"id":GGiOSSDK.shared.AllDetails.companyId,"agent_id":GGiOSSDK.shared.AllDetails.agentId,"ts":2,"message":GGiOSSDK.shared.AllDetails.name+" is typing...","stop":false]])
        return true
    }
}
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
//            if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//               // self.imgUser.image = possibleImage
//               // self.updateprofilePic()
//            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { }
    }
}

class SenderTableViewCell:UITableViewCell{
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        var bundle = Bundle(for: GGiOSSDK.self)
        if let resourcePath = bundle.path(forResource: "GGiOSSDK", ofType: "bundle") {
            if let resourcesBundle = Bundle(path: resourcePath) {
                bundle = resourcesBundle
            }
        }
        imgProfile.image = UIImage(named: "user", in: bundle, compatibleWith: nil)
        self.backView.layer.cornerRadius = 10
        self.backView.clipsToBounds = true
        if #available(iOS 11.0, *) {
            self.backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        } else {
            
        }
       self.backView.backgroundColor = UIColor(hexCode:0xE7E7E7)
       self.lblMessage.textColor = UIColor(hexCode:0x322D33)
       self.lblTime.textColor = UIColor(hexCode:0x666666)
    }
}
class ReceiverTableViewCell:UITableViewCell{
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        var bundle = Bundle(for: GGiOSSDK.self)
        if let resourcePath = bundle.path(forResource: "GGiOSSDK", ofType: "bundle") {
            if let resourcesBundle = Bundle(path: resourcePath) {
                bundle = resourcesBundle
            }
        }
        imgProfile.image = UIImage(named: "user", in: bundle, compatibleWith: nil)
        self.backView.layer.cornerRadius = 10
        self.backView.clipsToBounds = true
        if #available(iOS 11.0, *) {
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        } else {
            
        }
        self.backView.backgroundColor = UIColor(hexCode:0x322D33)
               self.lblMessage.textColor = UIColor.white
               self.lblTime.textColor = UIColor(hexCode:0x666666)
        
    }
}
public enum DateFormatterType: String {
    case shipmentSendDate = "yyyy-MM-dd HH:mm:ss"
    case shipmentDisplayDate = "dd-MM-yyyy hh:mm a"
    case orderDisplayDate = "MMM dd, yyyy hh:mm a"
    case date = "dd-MM-yyyy"
    case dateMMM = "dd MMM, yyyy"
    case dateTimeMM = "dd MMM, HH:mm"
    case time = "hh:mm a"
    case senddate = "yyyy-MM-dd"
}

extension Date {
    
    // Initializes Date from string and format
    public init?(fromUTCString string: String, format: DateFormatterType) {
        self.init(fromUTCString: string, format: format.rawValue)
    }
    
    public init?(fromUTCString string: String, format: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: "Asia/Riyadh")!
        if let date = formatter.date(from: string) {
            self = date
        } else {
            return nil
        }
    }
    
    // Converts Date to String, with format
    public func toString(format: DateFormatterType, identifier: TimeZone = TimeZone.current) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = identifier
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
    
    func toLocalTimeZone(format: DateFormatterType)  -> String {
        return self.toString(format: format, identifier: TimeZone.current)
    }
}

extension String {
    
    func toUTCDate(format: DateFormatterType) -> Date? {
        return Date(fromUTCString: self, format: format)
    }
}


extension Date {
    
    public func timePassed() -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: self, to: date, options: [])
        
        var str: String
        
        if components.year! >= 1 {
            components.year == 1 ? (str = "year") : (str = "years")
            return String(format: components.year!.description+" "+str, components.year!.description)
        } else if components.month! >= 1 {
            components.month == 1 ? (str = "month") : (str = "months")
            return String(format: components.month!.description+" "+str, components.month!.description)
        } else if components.day! >= 1 {
            components.day == 1 ? (str = "day") : (str = "days")
            return String(format: components.day!.description+" "+str, components.day!.description)
        } else if components.hour! >= 1 {
            components.hour == 1 ? (str = "hour") : (str = "hours")
            return String(format: components.hour!.description+" "+str, components.hour!.description)
        } else if components.minute! >= 1 {
            components.minute == 1 ? (str = "minute") : (str = "minutes")
            return String(format: components.minute!.description+" "+str, components.minute!.description)
        } else if components.second! >= 1 {
            components.second == 1 ? (str = "second") : (str = "seconds")
            return String(format: components.second!.description+" "+str, components.second!.description)
        } else {
            return "JustNow"
        }
    }
    
    func toAge() -> Int {
        let now = Date()
        let ageComponents = Calendar.current.dateComponents([.year], from: self, to: now)
        return ageComponents.year ?? 0
    }
}
