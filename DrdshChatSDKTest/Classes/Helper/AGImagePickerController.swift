//
//  AGPHPhotoLibrary.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 11/15/17.
//  Copyright © 2017 GauravkumarGudaliya. All rights reserved.
//

import UIKit
import Photos
import PhotosUI
import MobileCoreServices

typealias AGImagePickerControllerDelegate = UIImagePickerControllerDelegate & UINavigationControllerDelegate

enum AGImagePickerMediaType {
    case photo
    case video
    case both
    
    var mediaTypes: [String] {
        switch self {
        case .photo:
            return [kUTTypeImage as String]
            
        case .video:
            return [kUTTypeMovie as String]
            
        case .both:
            return [kUTTypeMovie as String, kUTTypeImage as String]
        }
    }
}

open class AGImagePickerController: NSObject {
    
    private var pickerController = UIImagePickerController()
    private var isAllowsEditing: Bool = false
    
    typealias AGPickerController = UIViewController & AGImagePickerControllerDelegate
    
    private var iPadSetup: UIView
    private var media: AGImagePickerMediaType
    private var sourceType: UIImagePickerController.SourceType?
    private var rootViewController: AGPickerController
    
    @discardableResult
    init(with controller: AGPickerController, type: UIImagePickerController.SourceType? = nil, allowsEditing: Bool, media: AGImagePickerMediaType = .photo, iPadSetup: UIView){

        self.rootViewController = controller
        self.iPadSetup = iPadSetup
        self.media = media
        super.init()
        
        self.sourceType = type
        isAllowsEditing = allowsEditing
        setupAlertController()
    }
    
    func checkPermission() {
        switch self.sourceType {
        case .some(let type):
            switch type {
            case .photoLibrary:
                if PHPhotoLibrary.authorizationStatus() == .authorized {
                    self.presentPicker(with: type)
                }
                else{
                    self.photosAccessPermission()
                }
                
            default:
                if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized {
                    self.presentPicker(with: type)
                }
                else{
                    self.cameraAccessPermission()
                }
            }
            break
            
        default:
            if PHPhotoLibrary.authorizationStatus() == .notDetermined {
                self.photosAccessPermission()
            }
            else if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .notDetermined {
                self.cameraAccessPermission()
            }
            else{
                let isPhotosPermision = PHPhotoLibrary.authorizationStatus() == .authorized
                let isCameraPermision = AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized
                
                if isPhotosPermision && isCameraPermision {
                    setupAlertController()
                }
                else if isPhotosPermision {
                    self.presentPicker(with: .photoLibrary)
                }
                else if isCameraPermision {
                    self.presentPicker(with: .camera)
                }
            }
        }
    }
    
    func photosAccessPermission() {
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            checkPermission()
            break
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized{
                    self.checkPermission()
                }
            })
            break
            
        default:
            AGAlertBuilder(withAlert: "App Permission Denied", message: "To re-enable, please go to Settings and turn on Photo Library Service for this app.")
                .addAction(with: "Setting", style: .default, handler: { _ in
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
                    } else {
                        UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
                    }
                })
                .show()
            break
        }
    }
    
    func cameraAccessPermission() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch authStatus {
        case .authorized:
            checkPermission()
            break
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if granted {
                    self.checkPermission()
                }
            })
            break
            
        default:
            AGAlertBuilder(withAlert: "App Permission Denied", message: "To re-enable, please go to Settings and turn on Photo Library Service for this app.")
                .addAction(with: "Setting", style: .default, handler: { _ in
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!)
                    } else {
                        UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
                    }
                })
                .show()
            break
        }
    }
    
    private func presentPicker(with sourceType: UIImagePickerController.SourceType){
        
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            return
        }
        
        pickerController.delegate = rootViewController
        pickerController.mediaTypes = media.mediaTypes
        pickerController.allowsEditing = isAllowsEditing
        pickerController.modalPresentationStyle = .overFullScreen
        pickerController.sourceType = sourceType
        
        self.rootViewController.present(pickerController, animated: true, completion: nil)
    }
    
    private func setupAlertController() {
        let alert = AGAlertBuilder(withActionSheet: "Choose Option", message: "Select an option to pick an image", iPadOpen: .sourceView(iPadSetup))
        
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            alert.defaultAction(with: "Camera", handler: { (alert) in
                self.presentPicker(with: .camera)
            })
        }
        
        alert.defaultAction(with: "Photo Library") { (alert) in
            self.presentPicker(with: .photoLibrary)
        }
        
        alert.cancelAction(with: "Cancel")
        
        alert.show()
    }
    
    private var isCameraSupports: Bool {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            return true
        }
        
        //no camera found -- alert the user.
        AGAlertBuilder(withAlert: "No Camera", message: "Sorry, this device has no camera")
            .defaultAction(with: "OK")
            .show()
        return false
    }
}

class AGAlertBuilder: UIAlertController {

    typealias AGAlertActionBlock = ((UIAlertAction) -> Swift.Void)
    
    var isVisible : Bool {
        return self.view.superview != nil
    }
    
    enum TapOnType {
        case outSide
        case none
        case autoHidden(time: TimeInterval)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(withAlert title: String?, message: String?) {
        self.init(title: title, message: message, preferredStyle: .alert)
    }
 
    convenience init(withActionSheet title: String?, message: String?, iPadOpen: ActionSheetOpen, directions: UIPopoverArrowDirection = .any) {
        self.init(title: title, message: message, preferredStyle: .actionSheet)
        self.setPopoverPresentationProperties(iPadOpen, directions: directions)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UIAlertAction Methods
    @discardableResult
    func defaultAction(with title: String?, handler: AGAlertActionBlock? = nil) -> Self{
        let action = UIAlertAction(title: title, style: .default, handler: handler)
        addAction(action)
        return self
    }
    
    @discardableResult
    func cancelAction(with title: String?, handler: AGAlertActionBlock? = nil) -> Self{
        let action = UIAlertAction(title: title, style: .cancel, handler: handler)
        addAction(action)
        return self
    }
    
    @discardableResult
    func destructiveAction(with title: String?, handler: AGAlertActionBlock? = nil) -> Self{
        let action = UIAlertAction(title: title, style: .destructive, handler: handler)
        addAction(action)
        return self
    }
    
    @discardableResult
    func addAction(with title: String?, style: UIAlertAction.Style, handler: AGAlertActionBlock? = nil) -> Self{
        let action = UIAlertAction(title: title, style: style, handler: handler)
        addAction(action)
        return self
    }
    
    @discardableResult
    public func show(delayTime: TimeInterval? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> Self{
        
        //If a delay time has been set, delay the presentation of the alert by the delayTime
        if let time = delayTime {
            let dispatchTime = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                DrdshChatSDKTest.shared.topViewController()?.present(self, animated: animated, completion: completion)
            }
        }
        else{
            DispatchQueue.main.async {
                DrdshChatSDKTest.shared.topViewController()?.present(self, animated: animated, completion: completion)
            }
        }
        
        return self
    }
    
    func dissmiss(withType withHandler: @escaping (() -> Void), dismissType: TapOnType = .none) {
        switch dismissType {
            
        case .outSide:
            self.view.superview?.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(alertControllerBackgroundTapped))
            tap.numberOfTapsRequired = 1
            self.view.superview?.addGestureRecognizer(tap)
            break
            
        case .none: break
            
        case .autoHidden(time: let time):
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                if self.isVisible{
                    self.dismiss(animated: true, completion: nil)
                    withHandler()
                }
            }
            break
        }
    }
    
    enum ActionSheetOpen{
        case sourceView(UIView)
        case sourceRect(CGRect)
        case barButtonItem(UIBarButtonItem)
    }
    
    @discardableResult
    public func setPopoverPresentationProperties( _ iPadOpen: ActionSheetOpen, directions: UIPopoverArrowDirection = .any) -> Self {
        
        if let poc = self.popoverPresentationController {
            switch iPadOpen {
            case .sourceView(let view):
                poc.sourceView = view
                
            case .sourceRect(let rect):
                poc.sourceRect = rect
                
            case .barButtonItem(let item):
                poc.barButtonItem = item
            }
            
            poc.permittedArrowDirections = directions
        }
        
        return self
    }
    
    @objc func alertControllerBackgroundTapped(){
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: Image added in alert and Action Sheet
extension AGAlertBuilder {
    @discardableResult
    func addImage(with image: UIImage, width: CGFloat, height: CGFloat) -> Self{
        
        let displayImage = UIImageView(image: image)
        self.view.addSubview(displayImage)
        displayImage.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: displayImage, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: displayImage, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: displayImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width))
        self.view.addConstraint(NSLayoutConstraint(item: displayImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height))
        return self
    }
}

extension AGAlertBuilder {
    enum AttributeType: String{
        case attributedTitle
        case attributedMessage
    }
    
    func setAttributedTitle(type: AttributeType, attribute: [NSAttributedString.Key: Any]){
        let titleAttrString = NSMutableAttributedString(string: title ?? "", attributes: attribute)
        self.setValue(titleAttrString, forKey: type.rawValue)
    }
}
