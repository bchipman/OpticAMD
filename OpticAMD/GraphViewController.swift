//
//  GraphViewController.swift
//  OpticAMD
//
//  Created by Brian on 11/14/15.
//  Copyright © 2015 Med AppJam 2015 - Team 9. All rights reserved.
//

import UIKit
import Charts

class GraphViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var lineChartView: LineChartView!
    
    // MARK: Properties
    var savedTestResults = SavedTestResults()
    
    // MARK: Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        savedTestResults.load()
//        setExampleGraph()
        setupMyTestGraph()
//        debug()
    }
    
    // MARK: Debug
    func debug() {
        
        let epochHour = 3600.0
        let epochDay = 86400.0
        let epochWeek = 604800.0
        let epochMonth = 2629743.0
        let epochYear = 31556926.0
        
        for i in 0 ... (savedTestResults.count() - 1) {
            let testResult = savedTestResults.get(i)
            print("")
//            print("\n\(i)\ndate: \(testResult.date!)\nleft area: \(testResult.leftImageAreaData)\nright area: \(testResult.rightImageAreaData)")
            print("\n\(i)\ndate: \(testResult.date!)\nseconds since epoch: \(testResult.date!.timeIntervalSince1970)")
            
            let epochTime = testResult.date!.timeIntervalSince1970
            
            
            
        }
    }
    
    // MARK: Sample Graph
    func setupMyTestGraph() {
        let dates = [11.000,11.033,11.067,11.100,11.133,11.167,11.200,11.233,11.267,11.300,11.333,11.367,11.400,11.433,11.467,11.500,11.533,11.567,11.600,11.633,11.667,11.700,11.733,11.767,11.800,11.833,11.867,11.900,11.933,11.967,12.000]
        let areas = [0.19,0.09,0.15,0.15,0.11,0.15,0.19,0.18,0.09,0.09,0.15,0.08,0.17,0.10,0.20,0.17,0.18,0.19,0.09,0.08,0.19,0.18,0.20,0.10,0.18,0.08,0.17,0.08,0.18,0.11,0.14]
        let areas2 = [0.41,0.33,0.4,0.43,0.28,0.27,0.47,0.32,0.38,0.32,0.43,0.4,0.48,0.26,0.45,0.26,0.4,0.47,0.31,0.38,0.43,0.5,0.48,0.33,0.37,0.28,0.26,0.36,0.3,0.36,0.25]

        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dates.count {
            let dataEntry = ChartDataEntry(value: areas[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        var dataEntries2: [ChartDataEntry] = []
        for i in 0..<dates.count {
            let dataEntry = ChartDataEntry(value: areas2[i], xIndex: i)
            dataEntries2.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Orange")
        lineChartDataSet.colors = [UIColor(red: 15/255, green: 117/255, blue: 188/255, alpha: 1)]
        lineChartDataSet.circleColors = [UIColor(red: 15/255, green: 117/255, blue: 188/255, alpha: 1)]
        lineChartDataSet.circleHoleColor = UIColor(red: 15/255, green: 117/255, blue: 188/255, alpha: 1)
        lineChartDataSet.lineWidth = 2.5
        lineChartDataSet.circleRadius = 4.0

        let lineChartDataSet2 = LineChartDataSet(yVals: dataEntries2, label: "Blue")
        lineChartDataSet2.colors = [UIColor(red: 251/255, green: 176/255, blue: 76/255, alpha: 1)]
        lineChartDataSet2.circleColors = [UIColor(red: 251/255, green: 176/255, blue: 76/255, alpha: 1)]
        lineChartDataSet2.circleHoleColor = UIColor(red: 251/255, green: 176/255, blue: 76/255, alpha: 1)
        lineChartDataSet2.lineWidth = 2.5
        lineChartDataSet2.circleRadius = 4.0
        

        let allLineChartData = LineChartData(xVals: dates, dataSets: [lineChartDataSet, lineChartDataSet2])

        lineChartView.data = allLineChartData
        print(lineChartView.xAxis.limitLines)
        print(allLineChartData.getYMax())
        print(allLineChartData.getYMin())
        print(allLineChartData.yMin)
        print(allLineChartData.yMax)
        print(lineChartView.chartYMin)
        print(lineChartView.chartYMax)
        print(lineChartView.extraBottomOffset)
        print(lineChartView.extraTopOffset)
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    
    
    func setExampleGraph() {
        let dataPoints = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let values = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
    
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Units Sold")
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
        lineChartDataSet.circleColors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
    }

}
