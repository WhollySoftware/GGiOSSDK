//
//  Extension.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 12/6/17.
//  Copyright © 2017 AshvinGudaliya. All rights reserved.
//

import UIKit
import SwiftyJSON

typealias GGDictionary = [String: AnyObject]

@objcMembers
public class GGObject: NSObject {
    
    override public init() {
        super.init()
        
    }
    
    public var agDescription: String {
        return String(describing: self.toDict)
    }
    
    required convenience public init(with responseDict: [String: AnyObject]){
        self.init()
        
        self.convert(dataWith: responseDict)
    }
    
    var NoLogIfNotAssing: [String] = []
    
    func convert(dataWith responseDict: [String: AnyObject]) {
        for children in self.property() {
            if let key = children.label {
                if key == "descriptions"{
                    if let value = responseDict["description"] {
                        self.findClassAndAssignSingleValue(with: children.value, newValue: value, forKey: key)
                    }
                    else{
                        if !NoLogIfNotAssing.contains(key) {
                            debugPrint("[\(type(of: self))] Not Found:- \(key) in responseDict")
                        }
                    }
                    
                }else{
                    if let value = responseDict[key] {
                        self.findClassAndAssignSingleValue(with: children.value, newValue: value, forKey: key)
                    }
                    else{
                        if !NoLogIfNotAssing.contains(key) {
                            debugPrint("[\(type(of: self))] Not Found:- \(key) in responseDict")
                        }
                    }
                }
            }
        }
    }
    
    func getDataFromUserDefault(){
        for children in self.property() {
            if let value = UserDefaults.standard.value(forKey: children.label!) {
                self.findClassAndAssignSingleValue(with: children.value, newValue: value as AnyObject, forKey: children.label!)
            }
            else{
                NSLog("[Userdetails] Not get in UserDefaults :- key \(children.label!) value \(children.value)")
            }
        }
    }
    
    func saveToUserDefault(){
        for children in self.property() {
            
            if children.value is Int{
                UserDefaults.standard.set(children.value as! Int, forKey: children.label!)
            }
            else if children.value is Float {
                UserDefaults.standard.set(children.value as! Float, forKey: children.label!)
            }
            else if children.value is Bool {
                UserDefaults.standard.set(children.value as! Bool, forKey: children.label!)
            }
            else if children.value is String{
                UserDefaults.standard.set(children.value as! String, forKey: children.label!)
            }
            else{
                NSLog("[Userdetails] Not set in UserDefaults :- key \(children.label!) value \(children.value)")
            }
        }
    }
    
    func findClassAndAssignSingleValue(with defaultValue: Any, newValue: AnyObject, forKey: String){
        
        let name = "\(type(of: defaultValue))"
        let isArrayType: Bool = name == "Array<\(name.realType)>"
        
        switch name {
        case String(describing: String.self):
            if let string = JSON(newValue).string {
                self.setValue(string, forKey: forKey)
                return
            }
            
        case String(describing: [String].self):
            var temp: [String]  = []
            temp = self.getArray(newValue)
            self.setValue(temp, forKey: forKey)
            return
            
        case String(describing: [[String]].self):
            var temp: [[String]]  = []
            temp = self.getArray(newValue)
            self.setValue(temp, forKey: forKey)
            return
            
        case String(describing: Int.self):
            self.setValue(JSON(newValue).intValue, forKey: forKey)
            return
            
        case String(describing: Bool.self):
            self.setValue(JSON(newValue).boolValue, forKey: forKey)
            return
            
        case String(describing: Float.self), String(describing: CGFloat.self):
            self.setValue(JSON(newValue).floatValue, forKey: forKey)
            return
            
        case String(describing: Double.self):
            self.setValue(JSON(newValue).doubleValue, forKey: forKey)
            return
            
        default:
            if let subModelClass = classWith(className: name.realType) {
                if isArrayType {
                    if let subDict =  newValue as? [[String : AnyObject]]{
                        let arraySubModels: [AnyObject] = subDict.map {
                            subModelClass.init(with: $0 as [String: AnyObject])
                        }
                        self.setValue(arraySubModels, forKey: forKey)
                        return
                    }
                }
                else{
                    if let dict =  newValue as? [String : AnyObject]{
                        self.setValue(subModelClass.init(with: dict), forKey: forKey)
                        return
                    }
                }
            }
        }
        
        handleCustomKey(defaultValue: defaultValue, newValue: newValue, forKey: forKey)
    }
    
    func handleCustomKey(defaultValue: Any, newValue: Any, forKey: String) {
        let name = "\(type(of: defaultValue))"
        debugPrint("Problem to assign value: key: \(forKey)-\(name),    newValue: \(newValue)-\(type(of: newValue))")
    }
    
    
}

extension NSObject{
    var className: String {
        return String(describing: type(of: self))
    }
    
    func property() -> Mirror.Children {
        return Mirror(reflecting: self).children
    }
    
    func propertyList() {
        
        for (name, value) in property() {
            guard let name = name else { continue }
            print("\(name): \(type(of: value)) = '\(value)'")
        }
    }
}

