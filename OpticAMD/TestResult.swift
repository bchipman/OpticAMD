//
//  TestResult.swift
//  OpticAMD
//
//  Created by Brian on 11/8/15.
//  Copyright © 2015 Med AppJam 2015 - Team 9. All rights reserved.
//

import UIKit

class TestResult: NSObject, NSCoding {

    // MARK: Properties
    var date: NSDate?
    var leftImage: UIImage?
    var rightImage: UIImage?
    var leftImageAreaData: [String: Double]?
    var rightImageAreaData: [String: Double]?

    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("testResults")

    // MARK: Types
    struct PropertyKey {
        static let dateKey = "date"
        static let leftImageKey = "leftImage"
        static let rightImageKey = "rightImage"
        static let leftImageAreaDataKey = "leftImageAreaData"
        static let rightImageAreaDataKey = "rightImageAreaData"
    }

    // MARK: Initialization
    init?(date: NSDate?, leftImage: UIImage?, rightImage: UIImage?, leftImageAreaData: [String: Double]?, rightImageAreaData: [String: Double]?) {

        // Initalize stored properties.
        self.date = date
        self.leftImage = leftImage
        self.rightImage = rightImage
        self.leftImageAreaData = leftImageAreaData
        self.rightImageAreaData = rightImageAreaData

        super.init()

        // Initialization should fail if there is no date.
        if date == nil {
            return nil
        }
    }


    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
        aCoder.encodeObject(leftImage, forKey: PropertyKey.leftImageKey)
        aCoder.encodeObject(rightImage, forKey: PropertyKey.rightImageKey)
        aCoder.encodeObject(leftImageAreaData, forKey: PropertyKey.leftImageAreaDataKey)
        aCoder.encodeObject(rightImageAreaData, forKey: PropertyKey.rightImageAreaDataKey)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as? NSDate
        let leftImage = aDecoder.decodeObjectForKey(PropertyKey.leftImageKey) as? UIImage
        let rightImage = aDecoder.decodeObjectForKey(PropertyKey.rightImageKey) as? UIImage
        let leftImageAreaData = aDecoder.decodeObjectForKey(PropertyKey.leftImageAreaDataKey) as? [String: Double]
        let rightImageAreaData = aDecoder.decodeObjectForKey(PropertyKey.rightImageAreaDataKey) as? [String: Double]

        // Must call designated initializer.
        self.init(date: date, leftImage: leftImage, rightImage: rightImage, leftImageAreaData: leftImageAreaData, rightImageAreaData: rightImageAreaData)
    }

}
