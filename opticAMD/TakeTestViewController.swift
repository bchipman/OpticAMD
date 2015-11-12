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
    @IBOutlet weak var mainImageView: UIImageView! // Contains drawing except for the line currently being drawn
    @IBOutlet weak var tempImageView: UIImageView! // Contains line currently being drawn
    var lastPoint = CGPoint.zero    // last point drawn on canvas
    var lineWidth: CGFloat = 5      // width of line to draw
    var swiped = false              // true if stroke is continuous
    var red:        CGFloat = 0
    var green:      CGFloat = 0
    var blue:       CGFloat = 255
    var opacity:    CGFloat = 1
    var savedTestResults = SavedTestResults()
    var alertController: UIAlertController?
    
    var gridLineWidth: CGFloat = 10
    var squareSize: CGFloat = 50
    var colorX: UIColor = UIColor.blueColor()
    var colorY: UIColor = UIColor.redColor()

    
    // MARK: Overriden Methods
    override func viewDidLoad() {
        setOrResetView()
        
        // Create and configure alert controller to be used later (when save is tapped)
        alertController = UIAlertController(title: "Your test was saved", message: nil, preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "OK", style: .Default) { (ACTION) -> Void in
            print("OK was pressed")
        }
        alertController?.addAction(alertAction)
        drawNewGrid()
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

    @IBAction func save(sender: UIBarButtonItem) {
        savedTestResults.add(TestResult(date: NSDate(), image: mainImageView.image)!)
        savedTestResults.save()
        self.presentViewController(alertController!, animated: true, completion: nil)
    }
    
    
    // MARK: Helper Methods
    func drawLineFrom(fromPoint:CGPoint, toPoint:CGPoint) {
        // Called by touchesMoved to draw a line between two points
        
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
        CGContextSetRGBStrokeColor(context, red, 0.5, blue, 1.0)
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

    func drawNewGrid() {
//        print("MyView's drawRect()")
        
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        mainImageView.image?.drawInRect(CGRect(x: getLeftPosSoGridCentered(), y: getTopPosSoGridCentered(), width: mainImageView.frame.size.width, height: tempImageView.frame.size.height))
        
//        let myPathX = UIBezierPath()
//        myPathX.lineWidth = gridLineWidth
//        
//        let myPathY = UIBezierPath()
//        myPathY.lineWidth = gridLineWidth
        
//        print("")
//        print("width: \(bounds.width)")
//        print("height: \(bounds.height)")
        
        
        var xPos : CGFloat
        var yPos : CGFloat
        
        
        
        // BLUE
        xPos = getLeftPosSoGridCentered() + (gridLineWidth / 2)
        yPos = getTopPosSoGridCentered()
        for _ in 1...numLines() {
//            myPathX.moveToPoint(CGPoint(x: xPos, y: yPos))
//            myPathX.addLineToPoint(CGPoint(x: xPos, y: yPos + gridSize()))
            CGContextMoveToPoint(context, xPos, yPos)
            CGContextAddLineToPoint(context, xPos, yPos + gridSize())
            xPos += squareSize + gridLineWidth
        }
        
//        colorX.set()
//        myPathX.stroke()
        
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, gridLineWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)

        CGContextStrokePath(context)

        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        mainImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
        
//        // RED
//        xPos = getLeftPosSoGridCentered()
//        yPos = getTopPosSoGridCentered() + (gridLineWidth / 2)
//        for _ in 1...numLines() {
//            myPathY.moveToPoint(CGPoint(x: xPos, y: yPos))
//            myPathY.addLineToPoint(CGPoint(x: xPos + gridSize() , y: yPos))
//            yPos += squareSize + gridLineWidth
//        }
//        colorY.set()
//        myPathY.stroke()
//        
//        
//        
//        gridSize()
//        getLeftPosSoGridCentered()
//        getTopPosSoGridCentered()
    }
    
    func numSquares() -> Int {
        let ans1 = (min(mainImageView.frame.size.width, mainImageView.frame.size.height) - gridLineWidth) / (gridLineWidth + squareSize)
        let ans2 = floor(ans1)
        return Int(ans2)
    }
    
    func numLines() -> Int {
        return numSquares() + 1
    }
    
    func gridSize() -> CGFloat {
        let ans1 = CGFloat(numSquares()) * (squareSize + gridLineWidth)
        let ans2 = ans1 + (gridLineWidth / 2)
        let ans3 = ans2 + (gridLineWidth / 2)
        return ans3
    }
    
    func getLeftPosSoGridCentered() -> CGFloat {
        var x = (mainImageView.frame.width - gridSize()) / 2
        x = floor(x)
        return x
    }
    
    func getTopPosSoGridCentered() -> CGFloat {
        var y = (mainImageView.frame.height - gridSize()) / 2
        y = floor(y)
        return y
    }
    
    
    
}

