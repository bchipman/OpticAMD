//
//  AreaData.swift
//  opticAMD
//
//  Created by Victor Nie on 11/14/15.
//  Copyright © 2015 Med AppJam 2015 - Team 9. All rights reserved.
//

import Foundation

struct AreaData {
    var wavyArea: Double
    var blurryArea: Double
    var blindArea: Double
    var darkArea: Double
    var totalAffectedArea: Double
    
    init(imageData: [Int: Int]) {
        var totalPixelCount = 0.0
        for (_,v) in imageData {
            totalPixelCount += Double(v)
        }
        
        wavyArea = (Double(imageData[128065000]!) + Double(imageData[255192127]!)) / totalPixelCount
        blurryArea = (Double(imageData[65128]!) + Double(imageData[127192255]!)) / totalPixelCount
        blindArea = (Double(imageData[65000]!) + Double(imageData[127192127]!)) / totalPixelCount
        darkArea = (Double(imageData[141141141]!) + Double(imageData[14014014]!)) / totalPixelCount
        totalAffectedArea = wavyArea + blurryArea + blindArea + darkArea
    }
}