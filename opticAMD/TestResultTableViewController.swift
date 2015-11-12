//
//  TestResultTableViewController.swift
//  opticAMD
//
//  Created by Brian on 11/8/15.
//  Copyright © 2015 Med AppJam 2015 - Team 9. All rights reserved.
//

import UIKit

class TestResultTableViewController: UITableViewController {
    
    
    // MARK: Properties
    var savedTestResults = SavedTestResults()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedTestResults.load()
        tableView.reloadData()
    }

    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedTestResults.count()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TestResultTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TestResultTableViewCell

        // Fetches the appropriate testResult for the data source layout.
        let testResult = savedTestResults.get(indexPath.row)
        
        // Convert NSDate to String
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        formatter.timeStyle = .ShortStyle
        let dateString = testResult.date != nil ? formatter.stringFromDate(testResult.date!) : "???"

        // Assign testResult data to cell and return cell
        cell.nameLabel.text = dateString
        cell.resultImageView.image = testResult.image
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Hello")
        self.performSegueWithIdentifier("showDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetail" {
            print("Hello")
            let index = self.tableView.indexPathForSelectedRow! as NSIndexPath
            
            let vc = segue.destinationViewController as! TestResultDetailViewController
            
            vc.testResult = savedTestResults.get(index.row)
            
            self.tableView.deselectRowAtIndexPath(index, animated: true)
        }
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

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

}
