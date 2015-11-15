//
//  WelcomeViewController.swift
//  OpticAMD
//
//  Created by Brian on 11/13/15.
//  Copyright © 2015 Med AppJam 2015 - Team 9. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Hide navigation bar when view about to appear
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        super.viewWillAppear(true)
    }
    
    // Show navigation bar when view about to disappear
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewWillDisappear(true)
    }

}
