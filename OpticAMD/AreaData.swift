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
    
    init() {
        wavyArea = 0.0
        blurryArea = 0.0
        blindArea = 0.0
        darkArea = 0.0
        darkArea = 0.0
        totalAffectedArea = 0.0
    }
    
    init(imageData: [Int: Int]) {
        var totalPixelCount = 0.0
        for (_,v) in imageData {
            totalPixelCount += Double(v)
        }
        
        wavyArea = (Double(imageData[128065000]!) + Double(imageData[255192127]!)) / totalPixelCount // orange
        blurryArea = (Double(imageData[65128]!) + Double(imageData[127192255]!)) / totalPixelCount // blue
        blindArea = (Double(imageData[65000]!) + Double(imageData[127192127]!)) / totalPixelCount // light grey
        darkArea = (Double(imageData[141141141]!) + Double(imageData[14014014]!)) / totalPixelCount // dark grey
        totalAffectedArea = wavyArea + blurryArea + blindArea + darkArea
    }
}