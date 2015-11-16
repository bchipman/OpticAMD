//
//  AboutUsViewController.swift
//  OpticAMD
//
//  Created by Brian on 11/16/15.
//  Copyright © 2015 Med AppJam 2015 - Team 9. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBAction func twitterButton(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string:"https://twitter.com/OpticAMDapp")!)
    }
    @IBAction func facebookButton(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string:"https://www.facebook.com/opticamd/")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
