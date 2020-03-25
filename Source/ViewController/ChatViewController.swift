//
//  ChatViewController.swift
//  DrdshChatSDK
//
//  Created by Gaurav Gudaliya R on 16/03/20.
//

import UIKit
import MobileCoreServices
let imageCache = NSCache<NSString, UIImage>()
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
    var CloseBarItem : UIBarButtonItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.agentView.isHidden = true
        self.typingView.isHidden = true
        if DrdshChatSDK.shared.AllDetails.visitorConnectedStatus == 1{
            timer = Timer(timeInterval: 120, target: self, selector: #selector(invitationMaxWaitTimeExceeded), userInfo: nil, repeats: false)
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        }
        self.table.tableFooterView = UIView()
        btnSend.setImage(DrdshChatSDK.shared.config.sendMessageImage, for: .normal)
        btnLike.setImage(DrdshChatSDK.shared.config.likeImage, for: .normal)
        btnDisLike.setImage(DrdshChatSDK.shared.config.disLikeImage, for: .normal)
        btnLike.setImage(DrdshChatSDK.shared.config.likeSelctedImage, for: .selected)
        btnDisLike.setImage(DrdshChatSDK.shared.config.disLikeSelctedImage, for: .selected)
        
        btnMail.setImage(DrdshChatSDK.shared.config.mailImage, for: .normal)
        btnAttachment.setImage(DrdshChatSDK.shared.config.attachmentImage, for: .normal)
        imgView.image = DrdshChatSDK.shared.config.userPlaceHolderImage
        
        let barItem = UIBarButtonItem(image: DrdshChatSDK.shared.config.backImage, style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = barItem
        self.CloseBarItem = UIBarButtonItem(title: "Chat Close", style: .plain, target: self, action: #selector(dissmissView))
        navigationItem.rightBarButtonItem = self.CloseBarItem
        self.navigationItem.rightBarButtonItem = nil
        if DrdshChatSDK.shared.AllDetails.visitorConnectedStatus != 2{
            CommonSocket.shared.startChatRequest(data: [["dc_vid":DrdshChatSDK.shared.AllDetails.visitorID]])
        }else if DrdshChatSDK.shared.AllDetails.visitorConnectedStatus == 2{
            self.setAgentDetail()
            self.navigationItem.rightBarButtonItem = self.CloseBarItem
            CommonSocket.shared.visitorJoinAgentRoom(data: [["vid":DrdshChatSDK.shared.AllDetails.visitorID,"agent_id":DrdshChatSDK.shared.AllDetails.agentId]])
        }
        CommonSocket.shared.visitorLoadChatHistory(data: [["mid":DrdshChatSDK.shared.AllDetails.messageID]]) { (data) in
            if data.count > 0{
                if let arrDic = data[0] as? [[String:AnyObject]]{
                    self.list <= arrDic
                    self.table.reloadData()
                    self.table.scroll(to: .bottom, animated: true)
                }
            }
            debugPrint(data)
        }
        CommonSocket.shared.agentDetail = { t in
            self.setAgentDetail()
            self.table.reloadData()
        }
        btnSend.action = {
            let text = self.txtMessage.text!
            self.txtMessage.text! = ""
            CommonSocket.shared.sendVisitorMessage(data: [["dc_id":DrdshChatSDK.shared.AllDetails.companyId,"dc_mid":DrdshChatSDK.shared.AllDetails.messageID,"dc_vid":DrdshChatSDK.shared.AllDetails.visitorID,"dc_agent_id":DrdshChatSDK.shared.AllDetails.agentId,"message":text,"is_attachment":0,"attachment_file":"","file_type":"","file_size":"","send_by": 2,"dc_name":DrdshChatSDK.shared.AllDetails.name]]){ data in
                var m:MessageModel = MessageModel()
                if data.count > 0{
                    if let t = data[0] as? [String:AnyObject]{
                        m <= t
                        self.list.append(m)
                        self.table.reloadData()
                        self.table.scroll(to: .bottom, animated: true)
                    }
                }
            }
        }
        btnLike.action = {
            CommonSocket.shared.updateVisitorRating(data: [["mid":DrdshChatSDK.shared.AllDetails.messageID,"vid":DrdshChatSDK.shared.AllDetails.visitorID,"feedback":"good"]])
            self.btnLike.isSelected = true
            self.btnDisLike.isSelected = false
        }
        btnDisLike.action = {
            CommonSocket.shared.updateVisitorRating(data: [["mid":DrdshChatSDK.shared.AllDetails.messageID,"vid":DrdshChatSDK.shared.AllDetails.visitorID,"feedback":"bad"]])
            self.btnLike.isSelected = false
            self.btnDisLike.isSelected = true
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
        CommonSocket.shared.ipBlocked { data in
            if DrdshChatSDK.shared.AllDetails.visitorConnectedStatus == 2{
                DrdshChatSDK.shared.AllDetails.visitorConnectedStatus = 0
            }
            self.timer.invalidate()
            self.agentView.isHidden = true
            self.messageView.isHidden = true
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OfflineViewController") as! OfflineViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
        CommonSocket.shared.totalOnlineAgents { data in
            debugPrint(data)
        }
        CommonSocket.shared.agentAcceptedChatRequest { data in
            DrdshChatSDK.shared.AllDetails.visitorConnectedStatus = 2
            DrdshChatSDK.shared.AgentDetail <= data
            DrdshChatSDK.shared.AllDetails.agentId = data["agent_id"] as! String
             DrdshChatSDK.shared.AgentDetail.agent_name = data["name"] as! String
             DrdshChatSDK.shared.AgentDetail.visitor_message_id = data["mid"] as! String
            self.setAgentDetail()
            self.navigationItem.rightBarButtonItem = self.CloseBarItem
        }
        CommonSocket.shared.agentSendNewMessage { data in
            var m:MessageModel = MessageModel()
            m <= data
            if self.list.first(where: { (model) -> Bool in
                model._id == m._id
            }) == nil{
                self.list.append(m)
                self.table.reloadData()
                self.table.scroll(to: .bottom, animated: true)
            }
        }
        CommonSocket.shared.agentChatSessionTerminated { data in
            if DrdshChatSDK.shared.AllDetails.visitorConnectedStatus == 2{
                DrdshChatSDK.shared.AllDetails.visitorConnectedStatus = 0
            }
            self.timer.invalidate()
            self.agentView.isHidden = true
            self.messageView.isHidden = true
        }
        CommonSocket.shared.agentTypingListener { data in
            if (data["stop"] as! Int) == 1{
                self.typingView.isHidden = true
            }else{
                 self.lblTyping.text = data["message"] as? String ?? ""
                self.typingView.isHidden = false
            }
            self.lblTyping.text = data["message"] as? String ?? ""
        }
        CommonSocket.shared.newAgentAcceptedChatRequest { data in
            DrdshChatSDK.shared.AllDetails.agentId = data["agent_id"] as! String
            DrdshChatSDK.shared.AgentDetail <= data
            DrdshChatSDK.shared.AgentDetail.agent_name = data["name"] as! String
            DrdshChatSDK.shared.AgentDetail.visitor_message_id = data["mid"] as! String
            self.timer.invalidate()
            self.setAgentDetail()
        }
    }
    func setAgentDetail(){
        self.timer.invalidate()
        let strProdile = DrdshChatSDK.shared.AgentDetail.agent_image
        imgView.setImage(urlString: strProdile)
        self.agentView.isHidden = false
        self.lblName.text = DrdshChatSDK.shared.AgentDetail.agent_name
    }
    @objc func invitationMaxWaitTimeExceeded(){
        timer.invalidate()
        CommonSocket.shared.invitationMaxWaitTimeExceeded(data: [["vid":DrdshChatSDK.shared.AllDetails.visitorID,"form":DrdshChatSDK.shared.AllDetails.embeddedChat.displayForm]]) { (data) in
            debugPrint(data)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OfflineViewController") as! OfflineViewController
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    @objc func backAction(){
        if DrdshChatSDK.shared.AllDetails.visitorConnectedStatus == 2{
            CommonSocket.shared.disConnect()
            self.dismiss(animated: true, completion: nil)
        }else{
            self.timer.invalidate()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OfflineViewController") as! OfflineViewController
             self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    @objc func dissmissView(){
        self.timer.invalidate()
        if DrdshChatSDK.shared.AllDetails.embeddedChat.postChatPromptComments{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RateViewController") as! RateViewController
            vc.modalPresentationStyle = .overFullScreen
            vc.successHandler = {
                self.agentView.isHidden = true
                self.messageView.isHidden = true
                self.navigationItem.rightBarButtonItem = nil
            }
            self.present(vc, animated: true) {
                
            }
        }else{
            CommonSocket.shared.visitorEndChatSession(data: [["id":DrdshChatSDK.shared.AllDetails.companyId,"vid":DrdshChatSDK.shared.AllDetails.visitorID,"name":DrdshChatSDK.shared.AllDetails.name]]) { (data) in
                self.agentView.isHidden = true
                self.messageView.isHidden = true
                self.navigationItem.rightBarButtonItem = nil
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.list[indexPath.row].isSystem == 1 || self.list[indexPath.row].isWelcome == 1 || self.list[indexPath.row].isDeleted == 1 || self.list[indexPath.row].isTransfer == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "systemTableViewCell", for: indexPath) as! systemTableViewCell
            cell.lblMessage.text = self.list[indexPath.row].message
            cell.lblMessage.textAlignment = .left
            return cell
        }
        if self.list[indexPath.row].send_by == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTableViewCell", for: indexPath) as! SenderTableViewCell
            let strProdile = DrdshChatSDK.shared.AttachmentbaseURL+self.list[indexPath.row].agent_image
            cell.imgProfile.setImage(urlString: strProdile)
            cell.lblName.text = GGUserSessionDetail.shared.name
            cell.lblMessage.text = self.list[indexPath.row].message
            cell.lblTime.text = self.list[indexPath.row].updatedAt.toUTCDate(format: .shipmentSendDate)?.timePassed()
            cell.imgAttachment.isHidden = self.list[indexPath.row].is_attachment == 0
            cell.lblMessage.isHidden = self.list[indexPath.row].is_attachment == 1
            if self.list[indexPath.row].is_attachment == 1{
                let strUrl = DrdshChatSDK.shared.AttachmentbaseURL+self.list[indexPath.row].attachment_file
                cell.imgAttachment.setImage(urlString: strUrl)
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverTableViewCell", for: indexPath) as! ReceiverTableViewCell
            let strProdile = DrdshChatSDK.shared.AttachmentbaseURL+self.list[indexPath.row].agent_image
            cell.imgProfile.setImage(urlString: strProdile)
            cell.lblName.text = self.list[indexPath.row].agent_name
            cell.lblMessage.text = self.list[indexPath.row].message
             cell.lblTime.text = self.list[indexPath.row].updatedAt.toUTCDate(format: .shipmentSendDate)?.timePassed()
            cell.imgAttachment.isHidden = self.list[indexPath.row].is_attachment == 0
            cell.lblMessage.isHidden = self.list[indexPath.row].is_attachment == 1
            if self.list[indexPath.row].is_attachment == 1{
                let strUrl = DrdshChatSDK.shared.AttachmentbaseURL+self.list[indexPath.row].attachment_file
                 cell.imgAttachment.setImage(urlString: strUrl)
            }
            return cell
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        CommonSocket.shared.visitorTyping(data: [["vid":DrdshChatSDK.shared.AllDetails.visitorID,"id":DrdshChatSDK.shared.AllDetails.companyId,"agent_id":DrdshChatSDK.shared.AllDetails.agentId,"ts":1,"message":GGUserSessionDetail.shared.name+" start typing...","stop":false]])
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        CommonSocket.shared.visitorTyping(data: [["vid":DrdshChatSDK.shared.AllDetails.visitorID,"id":DrdshChatSDK.shared.AllDetails.companyId,"agent_id":DrdshChatSDK.shared.AllDetails.agentId,"ts":0,"message":GGUserSessionDetail.shared.name+" is typing...","stop":true]])
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        CommonSocket.shared.visitorTyping(data: [["vid":DrdshChatSDK.shared.AllDetails.visitorID,"id":DrdshChatSDK.shared.AllDetails.companyId,"agent_id":DrdshChatSDK.shared.AllDetails.agentId,"ts":2,"message":GGUserSessionDetail.shared.name+" is typing...","stop":false]])
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
                        CommonSocket.shared.sendVisitorMessage(data: [["dc_id":DrdshChatSDK.shared.AllDetails.companyId,"dc_mid":DrdshChatSDK.shared.AllDetails.messageID,"dc_vid":DrdshChatSDK.shared.AllDetails.visitorID,"dc_agent_id":DrdshChatSDK.shared.AllDetails.agentId,"send_by": 2,"message":url.lastPathComponent,"is_attachment":1,"attachment_file":base64String,"file_type":url.pathExtension,"file_size":url.fileSize,"dc_name":DrdshChatSDK.shared.AllDetails.name]]){ data in
                            var m:MessageModel = MessageModel()
                            if data.count > 0{
                                if let t = data[0] as? [String:AnyObject]{
                                    m <= t
                                    self.list.append(m)
                                    self.table.reloadData()
                                    self.table.scroll(to: .bottom, animated: true)
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
    @IBOutlet weak var imgAttachment: GGImageViewPopup!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        var bundle = Bundle(for: DrdshChatSDK.self)
        if let resourcePath = bundle.path(forResource: "DrdshChatSDK", ofType: "bundle") {
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
    @IBOutlet weak var imgAttachment: GGImageViewPopup!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        var bundle = Bundle(for: DrdshChatSDK.self)
        if let resourcePath = bundle.path(forResource: "DrdshChatSDK", ofType: "bundle") {
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
    case shipmentSendDate = "yyyy-MM-ddTHH:mm:ss.sssZ"
    case shipmentDisplayDate = "dd-MM-yyyy hh:mm a"
    case orderDisplayDate = "MMM dd, yyyy hh:mm a"
}
//2020-03-21T10:03:54.679Z
extension Date {
   
    // Initializes Date from string and format
    public init?(fromUTCString string: String, format: DateFormatterType) {
        self.init(fromUTCString: string, format: format.rawValue)
    }
    
    public init?(fromUTCString string: String, format: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format
         formatter.locale = Locale(identifier: "ar_DZ")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
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

extension UITableView {
    func scroll(to: ScrollsTo, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            
            guard numberOfRows > 0 else { return }
            switch to{
            case .top:
                let indexPath = IndexPath(row: 0, section: 0)
                self.scrollToRow(at: indexPath, at: .top, animated: animated)
                break
                
            case .bottom:
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                break
            }
        }
    }
    
    enum ScrollsTo {
        case top,bottom
    }
}
extension UIImageView{
    func setImage(urlString:String){
        self.image = UIImage(named: "user")
        if let cachedImage = imageCache.object(forKey: NSString(string: urlString)) {
              self.image =  cachedImage
        }else{
              DispatchQueue.global(qos: .background).async {
                  let url = URL(string:urlString)
                  let data = try? Data(contentsOf: url!)
                  let image1: UIImage = UIImage(data: data!)!
                  DispatchQueue.main.async {
                      imageCache.setObject(image1, forKey:urlString as NSString)
                       self.image = image1
                  }
              }
        }
    }
}
class GGImageViewPopup: UIImageView {
    var tempRect: CGRect?
    var bgView: UIView!
    
    var animated: Bool = true
    var intDuration = 0.25
    //MARK: Life cycle
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(popUpImageToFullScreen))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
        //        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Actions of Gestures
    @objc func exitFullScreen () {
        let imageV = bgView.subviews[0] as! UIImageView
        
        UIView.animate(withDuration: intDuration, animations: {
                imageV.frame = self.tempRect!
                self.bgView.alpha = 0
            }, completion: { (bol) in
                self.bgView.removeFromSuperview()
        })
    }
    
    @objc func popUpImageToFullScreen() {
        
        if let window = UIApplication.shared.delegate?.window {
            let parentView = self.findParentViewController(self)!.view
            
            bgView = UIView(frame: UIScreen.main.bounds)
            bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(exitFullScreen)))
            bgView.alpha = 0
            bgView.backgroundColor = UIColor.black
            let imageV = UIImageView(image: self.image)
            let point = self.convert(self.bounds, to: parentView)
            imageV.frame = point
            tempRect = point
            imageV.contentMode = .scaleAspectFit
            self.bgView.addSubview(imageV)
            window?.addSubview(bgView)
            
            if animated {
                UIView.animate(withDuration: intDuration, animations: {
                    self.bgView.alpha = 1
                    imageV.frame = CGRect(x: 0, y: 0, width: (parentView?.frame.width)!, height: (parentView?.frame.width)!)
                    imageV.center = (parentView?.center)!
                })
            }
        }
    }
    
    func findParentViewController(_ view: UIView) -> UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
