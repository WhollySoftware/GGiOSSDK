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
public class DrdshChatSDKConfiguration : NSObject {
    public var appSid:String = ""
    public var local:String = "en"
    public var mainColor:UIColor = UIColor(hexCode:0x322D33)
    public var secondryColor:UIColor = UIColor.groupTableViewBackground
    public var backImage:UIImage = UIImage()
    public var likeImage:UIImage = UIImage()
    public var disLikeImage:UIImage = UIImage()
    public var likeSelctedImage:UIImage = UIImage()
    public var disLikeSelctedImage:UIImage = UIImage()
    public var mailImage:UIImage = UIImage()
    public var attachmentImage:UIImage = UIImage()
    public var sendMessageImage:UIImage = UIImage()
    public var userPlaceHolderImage:UIImage = UIImage()
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
}

