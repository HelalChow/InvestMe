//
//  ProfileViewController.swift
//  investMe
//
//  Created by Helal Chowdhury on 3/7/20.
//  Copyright © 2020 Helal. All rights reserved.
//

import UIKit
import SafariServices

class ProfileViewController: UIViewController {
    @IBOutlet weak var joinCall: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        joinCall.addTarget(self, action: Selector(("joinCallPressed")), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func joinCallPressed(_ sender: Any) {
        guard let url = URL(string: "https://hangouts.google.com/call/coYtJmhhuN5CMkLkdxlIAEEE") else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
        
        
//        if let url = NSURL(string: "https://hangouts.google.com/call/coYtJmhhuN5CMkLkdxlIAEEE") {
//            UIApplication.shared.openURL(url as URL)
        }
    }
    
    


