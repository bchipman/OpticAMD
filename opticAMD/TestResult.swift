//
//  TestResult.swift
//  opticAMD
//
//  Created by Brian on 11/8/15.
//  Copyright © 2015 Med AppJam 2015 - Team 9. All rights reserved.
//

import UIKit

class TestResult: NSObject, NSCoding {
    
    // MARK: Properties
    var date: NSDate?
    var image: UIImage?
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("testResults")
    
    // MARK: Types
    struct PropertyKey {
        static let dateKey = "date"
        static let imageKey = "image"
    }
    
    // MARK: Initialization
    init?(date: NSDate?, image: UIImage?) {
    
        // Initalize stored properties.
        self.date = date
        self.image = image
        
        super.init()
        
        // Initialization should fail if there is no date or image.
        if date == nil || image == nil {
            return nil
        }
    }
    
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
        aCoder.encodeObject(image, forKey: PropertyKey.imageKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as? NSDate
        let image = aDecoder.decodeObjectForKey(PropertyKey.imageKey) as? UIImage
        
        // Must call designated initializer.
        self.init(date: date, image: image)
    }

}
