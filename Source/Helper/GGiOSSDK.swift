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

