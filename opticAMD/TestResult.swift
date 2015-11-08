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
    var name: String
    var image: UIImage?
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("testResults")
    
    // MARK: Types
    struct PropertyKey {
        static let nameKey = "name"
        static let imageKey = "image"
    }
    
    // MARK: Initialization
    init?(name: String, image: UIImage?) {
    
        // Initalize stored properties.
        self.name = name
        self.image = image
        
        super.init()
        
        // Initialization should fail if there is no name or image.
        if name.isEmpty || image == nil {
            return nil
        }
    }
    
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(image, forKey: PropertyKey.imageKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let image = aDecoder.decodeObjectForKey(PropertyKey.imageKey) as? UIImage
        
        // Must call designated initializer.
        self.init(name: name, image: image)
    }

    
}
