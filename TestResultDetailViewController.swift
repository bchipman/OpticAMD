//
//  TestResultDetailViewController.swift
//  opticAMD
//
//  Created by Victor Nie on 11/12/15.
//  Copyright © 2015 Med AppJam 2015 - Team 9. All rights reserved.
//

import UIKit

class TestResultDetailViewController: UIViewController {
    
    @IBOutlet weak var testResultImageView: UIImageView!
    
    var testResult: TestResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Test Result"
        if (testResult == nil) {
            testResultImageView?.image = UIImage(named: "cat")
        } else {
            testResultImageView?.image = testResult.image
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
