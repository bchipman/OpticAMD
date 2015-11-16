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
    
    @IBOutlet weak var wavyAreaChart: LineChartView!
    
    @IBOutlet weak var blurryAreaChart: LineChartView!
    
    @IBOutlet weak var blindAreaChart: LineChartView!
    
    @IBOutlet weak var darkAreaChart: LineChartView!
    
    @IBOutlet weak var totalAreaChart: LineChartView!
    
    func setChart(lineChartView: LineChartView!, dataType: String) {
        var leftDataEntries: [ChartDataEntry] = []
        var rightDataEntries: [ChartDataEntry] = []
        var xValues = [String]()
        let count = testResults.count() - 1
        
        for i in 0..<testResults.count() {
            let leftDataEntry = ChartDataEntry(value: testResults.get(count - i).leftImageAreaData![dataType]!, xIndex: i)
            let rightDataEntry = ChartDataEntry(value: testResults.get(count - i).rightImageAreaData![dataType]!, xIndex: i)
            
            leftDataEntries.append(leftDataEntry)
            rightDataEntries.append(rightDataEntry)
            
            let formatter = NSDateFormatter()
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            formatter.timeStyle = .ShortStyle
            let dateString = testResults.get(count - i).date != nil ? formatter.stringFromDate(testResults.get(count - i).date!) : "???"
            xValues.append(dateString)
            //xValues.append(i)
        }
        
        let leftChartDataSet = LineChartDataSet(yVals: leftDataEntries, label: dataType + " Left Area (%)")
        let rightChartDataSet = LineChartDataSet(yVals: rightDataEntries, label: dataType + " Right Area (%)")
        
        leftChartDataSet.colors = [UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)]
        leftChartDataSet.circleColors = [UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)]
        leftChartDataSet.circleHoleColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        leftChartDataSet.lineWidth = 2.5
        leftChartDataSet.circleRadius = 4.0
        
        rightChartDataSet.colors = [UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)]
        rightChartDataSet.circleColors = [UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)]
        rightChartDataSet.circleHoleColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
        rightChartDataSet.lineWidth = 2.5
        rightChartDataSet.circleRadius = 4.0
        
        switch dataType {
        case "wavy":
            lineChartView.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.5)
        case "blurry":
            lineChartView.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 0.5)
        case "blind":
            lineChartView.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 0.5)
        case "dark":
            lineChartView.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.5)
        case "total":
            lineChartView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        default:
            break
        }
        
        let chartDataSets = [leftChartDataSet, rightChartDataSet]
        
        let chartData = LineChartData(xVals: xValues, dataSets: chartDataSets)
        //barChartView.xAxis.labelPosition = .Bottom
        lineChartView.data = chartData
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        lineChartView.descriptionText = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(testResults.count())
        setChart(wavyAreaChart, dataType: "wavy")
        setChart(blurryAreaChart, dataType: "blurry")
        setChart(blindAreaChart, dataType: "blind")
        setChart(darkAreaChart, dataType: "dark")
        setChart(totalAreaChart, dataType: "total")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
