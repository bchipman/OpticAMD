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

    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("testResults")

    // MARK: Types
    struct PropertyKey {
        static let dateKey = "date"
        static let leftImageKey = "leftImage"
        static let rightImageKey = "rightImage"
    }

    // MARK: Initialization
    init?(date: NSDate?, leftImage: UIImage?, rightImage: UIImage?) {

        // Initalize stored properties.
        self.date = date
        self.leftImage = leftImage
        self.rightImage = rightImage

        super.init()

        // Initialization should fail if there is no date or image.
        if date == nil || leftImage == nil {
            return nil
        }
    }


    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
        aCoder.encodeObject(leftImage, forKey: PropertyKey.leftImageKey)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as? NSDate
        let leftImage = aDecoder.decodeObjectForKey(PropertyKey.leftImageKey) as? UIImage
        let rightImage = aDecoder.decodeObjectForKey(PropertyKey.rightImageKey) as? UIImage

        // Must call designated initializer.
        self.init(date: date, leftImage: leftImage, rightImage: rightImage)
    }

}
