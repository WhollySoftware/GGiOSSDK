//
//  NSObject.swift
//  BaseProject
//
//  Created by Gauravkumar Gudaliya on 12/17/17.
//  Copyright © 2017 AshvinGudaliya. All rights reserved.
//

import UIKit
extension Array where Element: GGObject {
    
    var toDict: [[String: Any]]{
        return self.map { $0.toDict }
    }
    
    public var toJson: String? {
        return toData?.toJson
    }
    
    public var toData: Data? {
     
        do {
            return try JSONSerialization.data(withJSONObject: self.toDict, options: [.prettyPrinted])
        }
        catch { return nil }
    }
}

extension String {
    
    public var toData: Data {
        do {
            return try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
        }
        catch { return Data() }
    }
}

extension GGObject {
    
    public var toData: Data? {
        do {
            return try JSONSerialization.data(withJSONObject: self.toDict, options: [.prettyPrinted])
        }
        catch { return nil }
    }
    
    public var toJson: String? {
        return toData?.toJson
    }
    
    var toDict: [String: Any] {
        var dict: [String: Any] = [:]
        for chiled in self.property() {
            
            if chiled.value is AGObject.Type{
                dict[chiled.label!] = (chiled.value as? AGObject)?.toDict ?? "{}"
            }
            else if let value = chiled.value as? Array<AGObject>{
                dict[chiled.label!] = value.toDict
            }
            else{
                dict[chiled.label!] = chiled.value
            }
        }
        
        return dict
    }
}

extension Data {
    //  Convert NSData to String
    public var toJson : String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
}

public extension Collection {
    var toJson: String? {
        get {
            let data = self as AnyObject
            var jsonString: String? = nil
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
                jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as String?
                
            } catch let error as NSError {
                debugPrint(error.description)
            }
            return jsonString
        }
    }
}

extension Array where Element: Codable {
    
    public var toData: Data {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(self)
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public var toJson: String? {
        return toData.toJson
    }
}

// MARK: - Methods
public extension Dictionary {
    
    /// - Parameter prettify: set true to prettify data (default is false).
    /// - Returns: optional JSON Data (if applicable).
    public func jsonData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: options)
            return jsonData
        } catch {
            return nil
        }
    }
}

extension String {
    
    var convertToDictionary: [String: Any]? {
        if let data = data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
