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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func joinCallPressed(_ sender: Any) {
        guard let url = URL(string: "https://hangouts.google.com/call/coYtJmhhuN5CMkLkdxlIAEEE") else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    

}
