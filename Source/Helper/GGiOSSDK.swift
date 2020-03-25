//
//  GGiOSSDK.swift
//  GGiOSSDK
//
//  Created by Gaurav Gudaliya R on 14/03/20.
//

import Foundation

public class GGiOSSDK : NSObject {
    @objc public static let shared: GGiOSSDK = {
        return GGiOSSDK()
    }()
    var appSid = ""
    var baseURL = "https://www.drdsh.live"
    var APIbaseURL = "https://www.drdsh.live"+"/sdk/v1/"
    var AttachmentbaseURL = "https://www.drdsh.live"+"/uploads/m/"
    var AllDetails:ValidateIdentity = ValidateIdentity()
    var AgentDetail:AgentModel = AgentModel()
    @objc public class func GGiOSSDKBundlePath() -> String {
        return Bundle(for: GGiOSSDK.self).path(forResource: "GGiOSSDK", ofType: "bundle")!
    }
    @objc public class func presentChat(appSid:String,animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        if let data = UserDefaults.standard.object(forKey: "AllDetails") as? [String :AnyObject]{
            GGiOSSDK.shared.AllDetails <= data
        }
        GGiOSSDK.shared.appSid = appSid
        let vc = UIStoryboard(name: "GGiOSSDK", bundle: Bundle(for: GGiOSSDK.self)).instantiateViewController(withIdentifier: "MainLoadViewController") as! MainLoadViewController
        vc.modalPresentationStyle = .overFullScreen
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .overFullScreen
        GGiOSSDK.shared.topViewController()?.present(nav, animated: true, completion: {
            completion?(true)
        })
    }
    @objc public class func dismissChat(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        GGiOSSDK.shared.topViewController()?.dismiss(animated: true, completion: {
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
    func APICallMain(url:String,newTodo: [String: Any],successHanlder:([String: Any])->Void?,errorHanlder:()->Void?) {
      var todosUrlRequest = URLRequest(url: URL(string: url)!)
      todosUrlRequest.httpMethod = "POST"
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
      var successHanlder1 = successHanlder
      var errorHanlder1 = errorHanlder
      let task = session.dataTask(with: todosUrlRequest) {
        (data, response, error) in
        DispatchQueue.main.async {
            GGProgress.shared.hideProgress()
        }
        guard error == nil else {
            errorHanlder1()
          print("error calling POST on /todos/1",error!)
          return
        }
        guard let responseData = data else {
            errorHanlder1()
          print("Error: did not receive data")
          return
        }
        do {
          guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
            options: []) as? [String: Any] else {
                errorHanlder1()
              print("Could not get JSON from responseData as dictionary")
              return
          }
           successHanlder1(receivedTodo)
        } catch  {
            errorHanlder1()
          print("error parsing response from POST on /todos")
          return
        }
      }
      task.resume()
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

