//
//  TakeTestViewController.swift
//  opticAMD
//
//  Created by Brian on 11/5/15.
//  Copyright © 2015 Med AppJam 2015 - Team 9. All rights reserved.
//

import UIKit

class TakeTestViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    var lastPoint = CGPoint.zero    // last point drawn on canvas
    var lineWidth: CGFloat = 5      // width of line to draw
    var swiped = false              // true if stroke is continuous
    var red:        CGFloat = 0
    var green:      CGFloat = 0
    var blue:       CGFloat = 255
    var opacity:    CGFloat = 1
    

    // MARK: Overriden Methods
    override func viewDidLoad() {
        setOrResetView()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Called when one or more fingers touch down in a view or window
        
        // Reset swiped boolean
        swiped = false
        
        // Save touch location in lastPoint
        if let touch = touches.first as UITouch! {
            lastPoint = touch.locationInView(self.view)
            lastPoint.x -= mainImageView.frame.origin.x
            lastPoint.y -= mainImageView.frame.origin.y
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Called when one or more fingers associated with an event move within a view or window
        
        // 6
        swiped = true
        if let touch = touches.first as UITouch! {
            var currentPoint = touch.locationInView(view)
            currentPoint.x -= mainImageView.frame.origin.x
            currentPoint.y -= mainImageView.frame.origin.y
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
        }
        
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Called when one or more fingers are raised from a view or window
        
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)

        print("view")
        print(view.frame.origin)
        print(view.frame.size)
        
        print("mainImageView")
        print(mainImageView.frame.origin)
        print(mainImageView.frame.size)
        
        print("tempImageView")
        print(tempImageView.frame.origin)
        print(tempImageView.frame.size)
        
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: tempImageView.frame.size.width, height: tempImageView.frame.size.height), blendMode: CGBlendMode.Normal, alpha: opacity)
        
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }

    
    
    // MARK: Actions
    @IBAction func reset(sender: UIBarButtonItem) {
        setOrResetView()
    }

    
    // MARK: Helper Methods
    func drawLineFrom(fromPoint:CGPoint, toPoint:CGPoint) {
        // Called by touchesMoved to draw a line between two points
        // mainImageView: drawing except for the line currently being drawn
        // tempImageView: line currently drawing
        
        // 1
        UIGraphicsBeginImageContext(tempImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: tempImageView.frame.size.width, height: tempImageView.frame.size.height))
        
        // 2
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        // 3
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, lineWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        // 4
        CGContextStrokePath(context)
        
        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    func setOrResetView() {
        mainImageView.image = UIImage(named: "amslerGrid")
    }

    
    // MARK: NSCoding
    
}

