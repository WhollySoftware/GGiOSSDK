//
//  DrdshChatSDKTest.swift
//  DrdshChatSDKTest
//
//  Created by Gaurav Gudaliya R on 14/03/20.
//

import Foundation

public class DrdshChatSDKTest : NSObject {
    @objc public static let shared: DrdshChatSDKTest = {
        return DrdshChatSDKTest()
    }()
    var baseURL = "https://www.drdsh.live"
    var APIbaseURL = "https://www.drdsh.live"+"/sdk/v1/"
    var AttachmentbaseURL = "https://www.drdsh.live"+"/uploads/m/"
    var AllDetails:ValidateIdentity = ValidateIdentity()
    var AgentDetail:AgentModel = AgentModel()
    var config = DrdshChatSDKConfiguration()
    func DrdshChatSDKBundlePath() -> String {
        return Bundle(for: DrdshChatSDKTest.self).path(forResource: "DrdshChatSDKTest", ofType: "bundle")!
    }
    func DrdshChatSDKForcedBundlePath() -> String {
        let path = DrdshChatSDKBundlePath()
        let name = DrdshChatSDKTest.shared.config.local
        return Bundle(path: path)!.path(forResource: name, ofType: "lproj")!
    }
    func localizedString(stringKey: String) -> String {
        var path: String
        let table = "Localizable"
        path = DrdshChatSDKForcedBundlePath()
        return Bundle(path: path)!.localizedString(forKey: stringKey, value: stringKey, table: table)
    }
    
    @objc public class func presentChat(config: DrdshChatSDKConfiguration,animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        if let data = UserDefaults.standard.object(forKey: "AllDetails") as? [String :AnyObject]{
            DrdshChatSDKTest.shared.AllDetails <= data
        }
        DrdshChatSDKTest.shared.config = config
        if DrdshChatSDKTest.shared.config.appSid == ""{
            let alert = UIAlertController(title: DrdshChatSDKTest.shared.localizedString(stringKey:"Error"), message: DrdshChatSDKTest.shared.localizedString(stringKey:"appSid can not be blank"), preferredStyle: UIAlertController.Style.alert)
          alert.addAction(UIAlertAction(title: DrdshChatSDKTest.shared.localizedString(stringKey:"Ok"), style: UIAlertAction.Style.default, handler: nil))
          DrdshChatSDKTest.shared.topViewController()?.present(alert, animated: true, completion: {
             
          })
           
        }else{
            let vc = UIStoryboard(name: "DrdshChatSDK", bundle: Bundle(for: DrdshChatSDKTest.self)).instantiateViewController(withIdentifier: "MainLoadViewController") as! MainLoadViewController
            vc.modalPresentationStyle = .overFullScreen
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .overFullScreen
            DrdshChatSDKTest.shared.topViewController()?.present(nav, animated: true, completion: {
                completion?(true)
            })
        }
    }
    @objc public class func dismissChat(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        DrdshChatSDKTest.shared.topViewController()?.dismiss(animated: true, completion: {
             completion?(true)
        })
    }
    func pushViewController(VC:UIViewController,animated: Bool){
        topViewController()?.navigationController?.pushViewController(VC, animated: animated)
        
    }
    func present(VC:UIViewController,animated: Bool, completion1: (() -> Void)? = nil){
        topViewController()?.navigationController?.present(VC, animated: animated, completion: {
            if let com = completion1{
                com()
            }
        })
    }
    func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        debugPrint(base as Any)
        return base
    }
//    func APICallMain(url:String,newTodo: [String: Any],successHanlder:([String: Any])->Void?,errorHanlder:()->Void?) {
//      var todosUrlRequest = URLRequest(url: URL(string: url)!)
//      todosUrlRequest.httpMethod = "POST"
//      let jsonTodo: Data
//      do {
//        jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
//        todosUrlRequest.httpBody = jsonTodo
//      } catch {
//        print("Error: cannot create JSON from todo")
//        return
//      }
//      todosUrlRequest.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
//      todosUrlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//      todosUrlRequest.setValue("en", forHTTPHeaderField: "locale")
//      let session = URLSession.shared
//        GGProgress.shared.showProgress(isFullLoader:false)
//      var successHanlder1 = successHanlder
//      var errorHanlder1 = errorHanlder
//      let task = session.dataTask(with: todosUrlRequest) {
//        (data, response, error) in
//        DispatchQueue.main.async {
//            GGProgress.shared.hideProgress()
//        }
//        guard error == nil else {
//            errorHanlder1()
//          print("error calling POST on /todos/1",error!)
//          return
//        }
//        guard let responseData = data else {
//            errorHanlder1()
//          print("Error: did not receive data")
//          return
//        }
//        do {
//          guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
//            options: []) as? [String: Any] else {
//                errorHanlder1()
//              print("Could not get JSON from responseData as dictionary")
//              return
//          }
//           successHanlder1(receivedTodo)
//        } catch  {
//            errorHanlder1()
//          print("error parsing response from POST on /todos")
//          return
//        }
//      }
//      task.resume()
//    }
}
public class DrdshChatSDKConfiguration : GGObject {
    public var appSid:String = ""
    public var local:String = "en"
    var secondryColor:UIColor = UIColor.groupTableViewBackground
    public var myChatBubbleColor:String  = "#EEEEEE"
    public var myChatTextColor:String  = "#000000"
    public var oppositeChatBubbleColor:String  = ""
    public var oppositeChatTextColor:String  = "#FFFFFF"
    public var bgColor:String  = ""
    public var buttonBorderColor:String  = ""
    public var buttonColor:String  = ""
    public var greetingFontColor:String  = ""
    public var labelColor:String  = ""
    public var systemMessageColor:String  = ""
    public var topBarBgColor:String  = ""
    public var valueColor:String  = ""
    
    public var backImage:UIImage = UIImage()
    public var likeImage:UIImage = UIImage()
    public var disLikeImage:UIImage = UIImage()
    public var likeSelctedImage:UIImage = UIImage()
    public var disLikeSelctedImage:UIImage = UIImage()
    public var mailImage:UIImage = UIImage()
    public var attachmentImage:UIImage = UIImage()
    public var sendMessageImage:UIImage = UIImage()
    public var userPlaceHolderImage:UIImage = UIImage()
    public var offlineTxt:String  = "offlineTxt"
    public var onHoldMsg:String  = "onHoldMsg"
    public var onlineTxt:String  = "onlineTxt"
    public var preChatOfflineMessageTxt:String  = "preChatOfflineMessageTxt"
    public var preChatOnlineMessageTxt:String  = "preChatOnlineMessageTxt"
    public var sendButtonTxt:String  = "sendButtonTxt"
    public var startChatButtonTxt:String  = "startChatButtonTxt"
    public var exitSurveyCloseButtonTxt:String  = "exitSurveyCloseButtonTxt"
    public var exitSurveyCommentTxt:String  = "exitSurveyCommentTxt"
    public var exitSurveyHeaderTxt:String  = "exitSurveyHeaderTxt"
    public var exitSurveyMessageTxt:String  = "exitSurveyMessageTxt"
    public var exitSurveySendButtonTxt:String  = "exitSurveySendButtonTxt"
    public var fieldPlaceholderEmail:String  = "fieldPlaceholderEmail"
    public var fieldPlaceholderMessage:String  = "fieldPlaceholderMessage"
    public var fieldPlaceholderMobile:String  = "fieldPlaceholderMobile"
    public var fieldPlaceholderName:String  = "fieldPlaceholderName"
    public var fieldPlaceholderSubject:String  = "fieldPlaceholderSubject"
    public var typeHere:String = "typeHere"
    public var sendMessage:String = "Send Message"
    public var chatClose:String = "chatClose"
    public var startTyping:String = "startTyping"
    public var isTyping:String = "isTyping"
    public var error:String = "error"
    public var pleaseEnterName:String = "pleaseEnterName"
    public var pleaseEnterEmailAddress:String = "pleaseEnterEmailAddress"
    public var pleaseEnterValidEmail:String = "pleaseEnterValidEmail"
    public var pleaseEnterMobile:String = "pleaseEnterMobile"
    public var pleaseEnterSubject:String = "pleaseEnterSubject"
    public var pleaseEnterMessage:String = "pleaseEnterMessage"
    public var pleaseInputYourEmailAddress:String = "pleaseInputYourEmailAddress"
    public var noCamera:String = "noCamera"
    public var sorryThisDeviceHasNoCamera:String = "sorryThisDeviceHasNoCamera"
    public var ok:String = "oK"
    public var cancel:String = "cancel"
    public var photoLibrary:String = "photoLibrary"
    public var camera:String = "camera"
    public var chooseOption:String = "chooseOption"
    public var selectAnOptionToPickAnImage:String = "selectAnOptionToPickAnImage"
    public var done:String = "done"
    public var justnow:String = "justnow"
    public var second:String = "second"
    public var seconds:String = "seconds"
    public var minute:String = "minute"
    public var minutes:String = "minutes"
    public var hour:String = "hour"
    public var hours:String = "hours"
    public var day:String = "day"
    public var days:String = "days"
    public var month:String = "month"
    public var months:String = "months"
    public var year:String = "year"
    public var years:String = "years"
    public var connecting:String = "connecting..."
    public var waitingForAgent:String = "waitingForAgent"
    public var chat:String = "chat"
    public var offlineMessageRedirectUrl:String  = ""

    public override init() {
        var bundle = Bundle(for: DrdshChatSDKTest.self)
        if let resourcePath = bundle.path(forResource: "DrdshChatSDKTest", ofType: "bundle") {
            if let resourcesBundle = Bundle(path: resourcePath) {
                bundle = resourcesBundle
            }
        }
        backImage = UIImage(named: "back", in: bundle, compatibleWith: nil)!
        likeImage = UIImage(named: "like", in: bundle, compatibleWith: nil)!
        disLikeImage = UIImage(named: "dislike", in: bundle, compatibleWith: nil)!
        likeSelctedImage = UIImage(named: "selectedlike", in: bundle, compatibleWith: nil)!
        disLikeSelctedImage = UIImage(named: "selecteddislike", in: bundle, compatibleWith: nil)!
        mailImage = UIImage(named: "mail", in: bundle, compatibleWith: nil)!
        attachmentImage = UIImage(named: "attchment", in: bundle, compatibleWith: nil)!
        sendMessageImage = UIImage(named: "send", in: bundle, compatibleWith: nil)!
        userPlaceHolderImage = UIImage(named: "user", in: bundle, compatibleWith: nil)!
    }
    func mapServerData(to:[String:Any]){
        for (key,value) in to{
            if key == "bgColor",bgColor == ""{
                bgColor = value as! String
            }else if key == "buttonBorderColor",buttonBorderColor == ""{
                buttonBorderColor = value as! String
            }else if key == "buttonColor",buttonColor == ""{
                buttonColor = value as! String
            }else if key == "greetingFontColor",greetingFontColor == ""{
                greetingFontColor = value as! String
            }else if key == "labelColor",labelColor == ""{
                labelColor = value as! String
            }else if key == "systemMessageColor",systemMessageColor == ""{
                systemMessageColor = value as! String
            }else if key == "topBarBgColor",topBarBgColor == ""{
                topBarBgColor = value as! String
            }else if key == "valueColor",valueColor == ""{
                valueColor = value as! String
            }
            if key == "topBarBgColor",oppositeChatBubbleColor == ""{
                oppositeChatBubbleColor = value as! String
            }else if key == "topBarBgColor",myChatBubbleColor == ""{
                myChatBubbleColor = value as! String
            }
        }
    }
}

public extension UIColor {

    convenience init(hexCode:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hexCode & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hexCode & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hexCode & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }

}
extension String{
    func Color()->UIColor{
        return UIColor(hexString: self)
    }
    func Local()->String{
        return DrdshChatSDKTest.shared.localizedString(stringKey:self)
    }
}
