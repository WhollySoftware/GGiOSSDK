//
//  UserDetails.swift
//  Alfayda
//
//  Created by Wholly-iOS on 25/08/18.
//  Copyright © 2018 Whollysoftware. All rights reserved.
//

import UIKit


class GGUserSessionDetail: GGObject {
    
    static var isNewInstallled: Bool {
        get { return UserDefaults.standard.bool(forKey: "isUserLogin") }
        set { UserDefaults.standard.set(newValue, forKey: "isUserLogin") }
    }
    
    static var shared = GGUserSessionDetail()
    override init() {
        super.init()
        
    }
}


class GGApplication: NSObject {
    
    /// EZSE: Returns app's version number
    public static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleInfoDictionaryVersionKey as String) as? String ?? ""
    }
    
    /// EZSE: Return app's build number
    public static var appBuild: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? ""
    }
}
