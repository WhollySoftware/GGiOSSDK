//
//  AGButton.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 31/01/19.
//  Copyright © 2017 GauravkumarGudaliya. All rights reserved.
//

import UIKit

class GGButton: UIButton {
    
    @IBInspectable
    public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.masksToBounds = false
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor? {
        get {
            return  layer.borderColor == nil ? nil : UIColor(cgColor: layer.borderColor!)
        }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable
    public var shadowColor: UIColor? {
        get {
            return  layer.shadowColor == nil ? nil : UIColor(cgColor: layer.shadowColor!)
        }
        set { layer.shadowColor = newValue?.cgColor }
    }
    
    @IBInspectable
    public var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable
    public var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    @IBInspectable
    public var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }

    typealias ButtonAction = () -> Void
    
    @IBInspectable var isCircle : Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.defaultInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.defaultInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.setTitle(Language.get(self.currentTitle), for: .normal)
//        self.setTitle(Language.get(self.currentTitle), for: .selected)
//        self.titleLabel?.text = Language.get(self.currentTitle)
        if isCircle {
            self.cornerRadius = self.layer.frame.size.height / 2
        }
    }
    
    private struct AssociatedKeys {
        static var ActionKey = "ActionKey"
    }
    
    private class ActionWrapper {
        let action: ButtonAction
        init(action: @escaping ButtonAction) {
            self.action = action
        }
    }
    
    var action: ButtonAction? {
        set(newValue) {
            if action != nil {
                fatalError("Action method is already assigned. Must be remove old action")
            }
            removeTarget(self, action: #selector(performAction), for: .touchUpInside)
            var wrapper: ActionWrapper? = nil
            if let newValue = newValue {
                wrapper = ActionWrapper(action: newValue)
                addTarget(self, action: #selector(performAction), for: .touchUpInside)
            }
            objc_setAssociatedObject(self, &AssociatedKeys.ActionKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            guard let wrapper = objc_getAssociatedObject(self, &AssociatedKeys.ActionKey) as? ActionWrapper else {
                return nil
            }
            
            return wrapper.action
        }
    }
    
    private func defaultInit() {
    
    }
    
    @objc private func performAction() {
        
        if let vc = self.parentViewController {
           // vc.view.endEditing(true)
        }

        guard let action = action else {
            return
        }

        action()
    }
}
