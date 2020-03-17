//
//  WatingViewController.swift
//  GGiOSSDK
//
//  Created by Gaurav Gudaliya R on 17/03/20.
//

import UIKit

class WatingViewController: UIViewController {

     @IBOutlet weak var btnSend: GGButton!
    @IBOutlet weak var txtMsg: UITextField!
    @IBOutlet weak var lblMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var bundle = Bundle(for: GGiOSSDK.self)
        if let resourcePath = bundle.path(forResource: "GGiOSSDK", ofType: "bundle") {
            if let resourcesBundle = Bundle(path: resourcePath) {
                bundle = resourcesBundle
            }
        }
        btnSend.action = {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let backImage = UIImage(named: "back", in: bundle, compatibleWith: nil)
        let barItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(dissmissView))
        barItem.title = "Chat"
        navigationItem.leftBarButtonItem = barItem
        // Do any additional setup after loading the view.
    }
    @objc func dissmissView(){
        self.dismiss(animated: true, completion: nil)
    }

}
