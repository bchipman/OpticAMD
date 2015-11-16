//
//  SavedTestResults.swift
//  OpticAMD
//
//  Created by Brian on 11/8/15.
//  Copyright © 2015 Med AppJam 2015 - Team 9. All rights reserved.
//

import Foundation
import UIKit

class SavedTestResults {
    
    // MARK: Properties
    private var testResults = [TestResult]()
    
    
    // MARK: Initialization
    init() {
        // Load any saved testResults, otherwise load sample data.
        if let savedTestResults = load() {
            testResults += savedTestResults.reverse()
        } /*else {
            // Load the sample data.
            loadSampleTestResults()
        }*/
    }
    
    private func loadSampleTestResults() {
        let testResult1 = TestResult(date: NSDate(), leftImage: UIImage(named: "cat")!, rightImage: UIImage(named: "cat")!, leftImageAreaData: [String: Double](), rightImageAreaData: [String: Double]())!
        let testResult2 = TestResult(date: NSDate(), leftImage: UIImage(named: "amslerGrid")!, rightImage: UIImage(named: "cat")!, leftImageAreaData: [String: Double](), rightImageAreaData: [String: Double]())!
        testResults += [testResult1, testResult2]
    }
    
    func count() -> Int {
        return testResults.count
    }
    
    func get(row: Int) -> TestResult {
        return testResults[row]
    }
    
    func del(row: Int) {
        testResults.removeAtIndex(row)
    }
    
    func add(testResult: TestResult) {
        //testResults.append(testResult)
        testResults = [testResult] + testResults
    }
    
    
    // MARK: NSCoding
    func save() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(testResults.reverse(), toFile: TestResult.ArchiveURL.path!)
        if isSuccessfulSave {
            print("Successfully saved testResults.")
        } else {
            print("Failed to save testResults...")
        }
    }
    
    func load() -> [TestResult]? {
        return (NSKeyedUnarchiver.unarchiveObjectWithFile(TestResult.ArchiveURL.path!) as? [TestResult])
    }
}