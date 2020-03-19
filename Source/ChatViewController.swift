//
//  ChatViewController.swift
//  GGiOSSDK
//
//  Created by Gaurav Gudaliya R on 16/03/20.
//

import UIKit

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var btnSend: GGButton!
    @IBOutlet weak var btnLike: GGButton!
    @IBOutlet weak var btnDisLike: GGButton!
    @IBOutlet weak var btnMail: GGButton!
    @IBOutlet weak var btnAttachment: GGButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var agentView: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var txtMessage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var bundle = Bundle(for: GGiOSSDK.self)
        if let resourcePath = bundle.path(forResource: "GGiOSSDK", ofType: "bundle") {
            if let resourcesBundle = Bundle(path: resourcePath) {
                bundle = resourcesBundle
            }
        }
        self.table.tableFooterView = UIView()
        btnSend.setImage(UIImage(named: "send", in: bundle, compatibleWith: nil), for: .normal)
        btnLike.setImage(UIImage(named: "like", in: bundle, compatibleWith: nil), for: .normal)
        btnDisLike.setImage(UIImage(named: "dislike", in: bundle, compatibleWith: nil), for: .normal)
        btnMail.setImage(UIImage(named: "mail", in: bundle, compatibleWith: nil), for: .normal)
        btnAttachment.setImage(UIImage(named: "attchment", in: bundle, compatibleWith: nil), for: .normal)
        imgView.image = UIImage(named: "user", in: bundle, compatibleWith: nil)
        
        let backImage = UIImage(named: "back", in: bundle, compatibleWith: nil)
        let barItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = barItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Chat Close", style: .plain, target: self, action: #selector(dissmissView))
    }
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func dissmissView(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RateViewController") as! RateViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.successHandler = {
            CommonSocket.shared.disConnect()
            self.dismiss(animated: false) {
                
            }
        }
        self.present(vc, animated: true) {
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}
