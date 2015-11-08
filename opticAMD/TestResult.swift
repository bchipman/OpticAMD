//
//  TestResult.swift
//  opticAMD
//
//  Created by Brian on 11/8/15.
//  Copyright © 2015 Med AppJam 2015 - Team 9. All rights reserved.
//

import UIKit

class TestResult {
    
    // MARK: Properties
    var name: String
    var image: UIImage?
    
    // MARK: Initialization
    init?(name: String, image: UIImage?) {
    
        // Initalize stored properties.
        self.name = name
        self.image = image
        
        // Initialization should fail if there is no name or image.
        if name.isEmpty || image == nil {
            return nil
        }
    }
    
    
    
}
