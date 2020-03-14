//
//  GGiOSSDK.swift
//  GGiOSSDK
//
//  Created by Gaurav Gudaliya R on 14/03/20.
//

import Foundation
public class GGiOSSDK : NSObject {
    @available(iOS 13.0, *)
    @objc public static var windowScene: UIWindowScene?
    @objc public static let shared: GGiOSSDK = {
        return GGiOSSDK()
    }()
    @objc public class func GGiOSSDKBundlePath() -> String {
        return Bundle(for: GGiOSSDK.self).path(forResource: "GGiOSSDK", ofType: "bundle")!
    }
    @objc public class func presentChat(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        
//        let vc = UIStoryboard(name: "GGiOSSDK", bundle: nil).instantiateViewController(withIdentifier: "MainLoadViewController") as! MainLoadViewController
//        vc.modalPresentationStyle = .overFullScreen
        let nav = UINavigationController(rootViewController: MainLoadViewController())
        nav.modalPresentationStyle = .overFullScreen
        GGiOSSDK.shared.topViewController()?.present(nav, animated: true, completion: {
            completion?(true)
        })
      //  Manager.sharedInstance.presentChat(animated: animated, completion: completion)
    }
    @objc public class func dismissChat(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        Manager.sharedInstance.dismissChat(animated: animated, completion: completion)
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
private class PassThroughWindow: UIWindow {
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return super.hitTest(point, with: event)
    }
}
private class Manager : NSObject{
    fileprivate let window = PassThroughWindow()
    private var previousKeyWindow : UIWindow?
    fileprivate let overlayViewController = MainLoadViewController()
    static let sharedInstance: Manager = {
        return Manager()
    }()
    override init() {
        window.backgroundColor = UIColor.clear
        window.frame = UIScreen.main.bounds
        window.windowLevel = UIWindow.Level.normal + 1
        window.rootViewController = overlayViewController
        
        super.init()
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { (notification) in
            if let keyWindow = UIApplication.shared.keyWindow {
                self.window.frame = keyWindow.frame
            }
        }
    }
    func presentChat(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        previousKeyWindow = UIApplication.shared.keyWindow
        if #available(iOS 13.0, *) {
            if GGiOSSDK.windowScene != nil {
                window.windowScene = GGiOSSDK.windowScene
            }
        }
        window.makeKeyAndVisible()
    }
    
    func dismissChat(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        self.previousKeyWindow?.makeKeyAndVisible()
        self.previousKeyWindow = nil
        self.window.isHidden = true
    }
}
