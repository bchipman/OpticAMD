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

    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        setChart(months, values: unitsSold)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {

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
