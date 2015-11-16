//
//  AreaGraphsViewController.swift
//  OpticAMD
//
//  Created by Victor Nie on 11/16/15.
//  Copyright © 2015 Med AppJam 2015 - Team 9. All rights reserved.
//

import UIKit
import Charts

class AreaGraphsViewController: UIViewController {
    
    var testResults = SavedTestResults()
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    func setChart() {
        var leftDataEntries: [ChartDataEntry] = []
        var rightDataEntries: [ChartDataEntry] = []
        var xValues = [String]()
        let count = testResults.count() - 1
        
        for i in 0..<testResults.count() {
            let leftDataEntry = ChartDataEntry(value: testResults.get(count - i).leftImageAreaData!["total"]!, xIndex: i)
            let rightDataEntry = ChartDataEntry(value: testResults.get(count - i).rightImageAreaData!["total"]!, xIndex: i)
            
            
            leftDataEntries.append(leftDataEntry)
            rightDataEntries.append(rightDataEntry)
            
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            formatter.timeStyle = .ShortStyle
            let dateString = testResults.get(count - i).date != nil ? formatter.stringFromDate(testResults.get(count - i).date!) : "???"
            xValues.append(dateString)
            //xValues.append(i)
        }
        
        let leftChartDataSet = LineChartDataSet(yVals: leftDataEntries, label: "Left Area (%)")
        let rightChartDataSet = LineChartDataSet(yVals: rightDataEntries, label: "Right Area (%)")
        
        leftChartDataSet.colors = [UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)]
        leftChartDataSet.circleColors = [UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)]

        
        let chartDataSets = [leftChartDataSet, rightChartDataSet]
        
        let chartData = LineChartData(xVals: xValues, dataSets: chartDataSets)
        //barChartView.xAxis.labelPosition = .Bottom
        lineChartView.data = chartData
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setChart()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
