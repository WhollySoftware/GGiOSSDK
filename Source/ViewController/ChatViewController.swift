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
    var list:[MessageModel] = []
    var agentName = "Agent"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.agentView.isHidden = true
        self.typingView.isHidden = true
        if GGiOSSDK.shared.AllDetails.visitorConnectedStatus == 1{
            timer = Timer(timeInterval: 120, target: self, selector: #selector(invitationMaxWaitTimeExceeded), userInfo: nil, repeats: false)
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        }
        
        if GGiOSSDK.shared.AllDetails.visitorConnectedStatus != 2{
            CommonSocket.shared.startChatRequest(data: [["dc_vid":GGiOSSDK.shared.AllDetails.visitorID]])
        }else if GGiOSSDK.shared.AllDetails.visitorConnectedStatus == 2{
            CommonSocket.shared.visitorJoinAgentRoom(data: [["vid":GGiOSSDK.shared.AllDetails.visitorID,"agent_id":GGiOSSDK.shared.AllDetails.agentId]])
        }
        CommonSocket.shared.visitorLoadChatHistory(data: [["mid":GGiOSSDK.shared.AllDetails.messageID]]) { (data) in
            if data.count > 0{
                if let arrDic = data[0] as? [[String:AnyObject]]{
                    self.list <= arrDic
                    self.table.reloadData()
                }
            }
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
            let text = self.txtMessage.text!
            self.txtMessage.text! = ""
            CommonSocket.shared.sendVisitorMessage(data: [["dc_id":GGiOSSDK.shared.AllDetails.companyId,"dc_mid":GGiOSSDK.shared.AllDetails.messageID,"dc_vid":GGiOSSDK.shared.AllDetails.visitorID,"dc_agent_id":GGiOSSDK.shared.AllDetails.agentId,"message":text,"is_attachment":0,"attachment_file":"","file_type":"","file_size":""]]){ data in
                var m:MessageModel = MessageModel()
                if data.count > 0{
                    if let t = data[0] as? [String:AnyObject]{
                        m <= t
                        self.list.append(m)
                        self.table.reloadData()
                    }
                }
                debugPrint(data)
            }
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
           AGImagePickerController(with: self, allowsEditing: true, media: .both, iPadSetup: self.btnAttachment)
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
            debugPrint(data)
            self.timer.invalidate()
        }
        CommonSocket.shared.totalOnlineAgents { data in
            debugPrint(data)
        }
        CommonSocket.shared.agentAcceptedChatRequest { data in
            debugPrint(data)
            self.timer.invalidate()
            self.agentView.isHidden = false
        }
        CommonSocket.shared.agentSendNewMessage { data in
            debugPrint(data)
        }
        CommonSocket.shared.agentChatSessionTerminated { data in
            debugPrint(data)
            self.timer.invalidate()
            self.agentView.isHidden = true
            self.messageView.isHidden = true
        }
        CommonSocket.shared.agentTypingListener { data in
            debugPrint(data)
             self.typingView.isHidden = false
        }
        CommonSocket.shared.newAgentAcceptedChatRequest { data in
            debugPrint(data)
            self.agentView.isHidden = false
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.list[indexPath.row].isSystem == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "systemTableViewCell", for: indexPath) as! systemTableViewCell
            cell.lblMessage.text = self.list[indexPath.row].message
            return cell
        }
        if self.list[indexPath.row].visitor_id._id != GGiOSSDK.shared.AllDetails.visitorID{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTableViewCell", for: indexPath) as! SenderTableViewCell
            cell.lblName.text = GGUserSessionDetail.shared.name
            cell.lblMessage.text = self.list[indexPath.row].message
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverTableViewCell", for: indexPath) as! ReceiverTableViewCell
            cell.lblName.text = self.agentName
            cell.lblMessage.text = self.list[indexPath.row].message
            return cell
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        CommonSocket.shared.visitorTyping(data: [["vid":GGiOSSDK.shared.AllDetails.visitorID,"id":GGiOSSDK.shared.AllDetails.companyId,"agent_id":GGiOSSDK.shared.AllDetails.agentId,"ts":1,"message":GGUserSessionDetail.shared.name+" start typing...","stop":false]])
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        CommonSocket.shared.visitorTyping(data: [["vid":GGiOSSDK.shared.AllDetails.visitorID,"id":GGiOSSDK.shared.AllDetails.companyId,"agent_id":GGiOSSDK.shared.AllDetails.agentId,"ts":0,"message":GGUserSessionDetail.shared.name+" is typing...","stop":true]])
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        CommonSocket.shared.visitorTyping(data: [["vid":GGiOSSDK.shared.AllDetails.visitorID,"id":GGiOSSDK.shared.AllDetails.companyId,"agent_id":GGiOSSDK.shared.AllDetails.agentId,"ts":2,"message":GGUserSessionDetail.shared.name+" is typing...","stop":false]])
        return true
    }
}
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
         picker.dismiss(animated: true) {
            if let possibleImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                if #available(iOS 11.0, *) {
                    let url = info[UIImagePickerControllerImageURL] as! URL
                    print("Img size = \((Double(url.fileSize) / 1000.00).rounded()) KB")
                    debugPrint(url.lastPathComponent)
                    debugPrint(url.pathExtension)
                    if let base64String = try? Data(contentsOf: url).base64EncodedString() {
                        print(base64String)
                        CommonSocket.shared.sendVisitorMessage(data: [["dc_id":GGiOSSDK.shared.AllDetails.companyId,"dc_mid":GGiOSSDK.shared.AllDetails.messageID,"dc_vid":GGiOSSDK.shared.AllDetails.visitorID,"dc_agent_id":GGiOSSDK.shared.AllDetails.agentId,"message":url.lastPathComponent,"is_attachment":1,"attachment_file":base64String,"file_type":url.pathExtension,"file_size":url.fileSize]]){ data in
                            var m:MessageModel = MessageModel()
                            if data.count > 0{
                                if let t = data[0] as? [String:AnyObject]{
                                    m <= t
                                    self.list.append(m)
                                    self.table.reloadData()
                                }
                            }
                            debugPrint(data)
                        }
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
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
class systemTableViewCell:UITableViewCell{
    @IBOutlet weak var lblMessage: UILabel!
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
extension URL {
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }

    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }

    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }

    var creationDate: Date? {
        return attributes?[.creationDate] as? Date
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
