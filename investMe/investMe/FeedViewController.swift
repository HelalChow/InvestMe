//
//  FeedViewController.swift
//  investMe
//
//  Created by Helal Chowdhury on 3/7/20.
//  Copyright © 2020 Helal. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    @IBAction func switchClicked(_ sender: Any) {
         performSegue(withIdentifier: "goToMap", sender: self)
        tabBarController!.selectedIndex = 0
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            if segue.identifier == "goToMap" {
//                let vc = segue.destination as! MapViewController
//
//                let tabCtrl: UITabBarController = segue.destination as! UITabBarController
//                let destinationVC = tabCtrl.viewControllers![0] as! MapViewController
//            }
//        }

}
