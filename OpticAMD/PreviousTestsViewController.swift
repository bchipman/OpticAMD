//
//  PreviousTestsViewController.swift
//  OpticAMD
//
//  Created by Brian on 11/13/15.
//  Copyright © 2015 Med AppJam 2015 - Team 9. All rights reserved.
//

import UIKit

class PreviousTestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var previousTestsTableView: UITableView!

    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!

    // MARK: Properties
    var savedTestResults = SavedTestResults()


    override func viewDidLoad() {
        super.viewDidLoad()
        savedTestResults.load()
        
        let testResult = savedTestResults.get(0)
        leftImage.image = testResult.leftImage
        rightImage.image = testResult.rightImage
        
        previousTestsTableView.delegate = self
        previousTestsTableView.dataSource = self
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedTestResults.count()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "PreviousTestsTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PreviousTestsTableViewCell

        // Fetches the appropriate testResult for the data source layout.
        let testResult = savedTestResults.get(indexPath.row)

        // Convert NSDate to String
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = .ShortStyle
        let dateString = testResult.date != nil ? formatter.stringFromDate(testResult.date!) : "???"

        // Assign testResult data to cell and return cell
        cell.nameLabel.text = dateString
        
        cell.leftImageView.image = testResult.leftImage
        cell.leftWavy.text = String(format:"%.3f", testResult.leftImageAreaData!["wavy"]!)
        cell.leftBlurry.text = String(format:"%.3f", testResult.leftImageAreaData!["blurry"]!)
        cell.leftBlind.text = String(format:"%.3f", testResult.leftImageAreaData!["blind"]!)
        cell.leftDark.text = String(format:"%.3f", testResult.leftImageAreaData!["dark"]!)

        cell.rightImageView.image = testResult.rightImage
        cell.rightWavy.text = String(format:"%.3f", testResult.rightImageAreaData!["wavy"]!)
        cell.rightBlurry.text = String(format:"%.3f", testResult.rightImageAreaData!["blurry"]!)
        cell.rightBlind.text = String(format:"%.3f", testResult.rightImageAreaData!["blind"]!)
        cell.rightDark.text = String(format:"%.3f", testResult.rightImageAreaData!["dark"]!)

        for cellLabel in [cell.leftWavy, cell.leftBlurry, cell.leftBlind, cell.leftDark, cell.rightWavy, cell.rightBlurry, cell.rightBlind, cell.rightDark] {
            if cellLabel.text == "0.000" {
                cellLabel.text = "-"
            }
        }
        
        return cell
    }


    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        if editingStyle == .Delete {

            // Delete the row from the data source
            savedTestResults.del(indexPath.row)

            // Save the testResults array whenever a testResult is deleted.
            savedTestResults.save()

            // Delete the row from the view.
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }

        else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }

    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let testResult = savedTestResults.get(indexPath.row)
        leftImage.image = testResult.leftImage
        rightImage.image = testResult.rightImage
    }

}
