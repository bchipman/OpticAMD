//
//  TakeTestViewController.swift
//  opticAMD
//
//  Created by Brian on 11/5/15.
//  Copyright © 2015 Med AppJam 2015 - Team 9. All rights reserved.
//

import UIKit

@IBDesignable
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
        //        setOrResetView()
        
        // Create and configure alert controller to be used later (when save is tapped)
        alertController = UIAlertController(title: "Your test was saved", message: nil, preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "OK", style: .Default) { (ACTION) -> Void in
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
            print(touch.locationInView(self.view))
            lastPoint = touch.locationInView(self.view)
            lastPoint.x -= mainImageView.superview!.frame.origin.x
            lastPoint.y -= mainImageView.superview!.frame.origin.y
        }
        
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Called when one or more fingers associated with an event move within a view or window
        
        // 6
        swiped = true
        if let touch = touches.first as UITouch! {
            var currentPoint = touch.locationInView(view)
            currentPoint.x -= mainImageView.superview!.frame.origin.x
            currentPoint.y -= mainImageView.superview!.frame.origin.y
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
        UIGraphicsBeginImageContext(mainImageView.superview!.frame.size)
        
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: mainImageView.superview!.frame.size.width, height: mainImageView.superview!.frame.size.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: tempImageView.superview!.frame.size.width, height: tempImageView.superview!.frame.size.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }

    
    
    // MARK: Actions
    @IBAction func reset(sender: UIBarButtonItem) {
        setOrResetView()
    }

    @IBAction func save(sender: UIBarButtonItem) {

        // Create rectangle from middle of current image
//        let cropRect = CGRectMake(mainImageView.image!.size.width / 4, mainImageView.image!.size.height / 4 , (mainImageView.image!.size.width / 2), (mainImageView.image!.size.height / 2));
        let cropRect = CGRectMake(getLeftPosSoGridCentered() - (gridLineWidth / 2), getTopPosSoGridCentered() - (gridLineWidth / 2) , gridSize() + (gridLineWidth / 2), gridSize() + (gridLineWidth / 2)) ;
        let imageRef = CGImageCreateWithImageInRect(mainImageView.image?.CGImage, cropRect)
        
        let croppedImage = UIImage(CGImage: imageRef!)
        
        savedTestResults.add(TestResult(date: NSDate(), image: mainImageView.image)!)
        savedTestResults.save()
        savedTestResults.add(TestResult(date: NSDate(), image: croppedImage)!)
        savedTestResults.save()
        
        self.presentViewController(alertController!, animated: true, completion: nil)
    }
    
    @IBAction func button1(sender: UIBarButtonItem) {
    }
    
    @IBAction func button2(sender: UIBarButtonItem) {
    }
    // MARK: Helper Methods
    func drawLineFrom(fromPoint:CGPoint, toPoint:CGPoint) {
        // Called by touchesMoved to draw a line between two points
        
        // 1
        UIGraphicsBeginImageContext(tempImageView.superview!.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: tempImageView.superview!.frame.size.width, height: tempImageView.superview!.frame.size.height))
        
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
        mainImageView.image = nil
        tempImageView.image = nil
        drawNewGrid()
    }

    func drawNewGrid() {
        var xPos : CGFloat
        var yPos : CGFloat
        var context: CGContext?
        
        
        // BORDER
        UIGraphicsBeginImageContext(mainImageView.superview!.frame.size)
        context = UIGraphicsGetCurrentContext()
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: mainImageView.superview!.frame.size.width, height: mainImageView.superview!.frame.size.height))
        CGContextMoveToPoint(context, 0, 0)
        CGContextAddLineToPoint(context, mainImageView.superview!.frame.size.width, 0)
        CGContextAddLineToPoint(context, mainImageView.superview!.frame.size.width, mainImageView.superview!.frame.size.height)
        CGContextAddLineToPoint(context, 0, mainImageView.superview!.frame.size.height)
        CGContextAddLineToPoint(context, 0, 0)
        CGContextMoveToPoint(context, mainImageView.superview!.frame.origin.x, mainImageView.superview!.frame.origin.y)
        CGContextAddLineToPoint(context, mainImageView.superview!.frame.origin.x + 100, mainImageView.superview!.frame.origin.y + 100)
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, gridLineWidth)
        CGContextSetRGBStrokeColor(context, 0, 1, 1, 1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        CGContextStrokePath(context)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        mainImageView.alpha = 1
        UIGraphicsEndImageContext()
        
        
        // Set up for drawing
        UIGraphicsBeginImageContext(mainImageView.superview!.frame.size)
        context = UIGraphicsGetCurrentContext()
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, gridLineWidth)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: mainImageView.superview!.frame.size.width, height: mainImageView.superview!.frame.size.height))

        // BLUE (Horizontal)
        xPos = getLeftPosSoGridCentered() + (gridLineWidth / 2)
        yPos = getTopPosSoGridCentered() + (gridLineWidth / 2)
        for _ in 1...numLines() {
            CGContextMoveToPoint(context, xPos, yPos)
            CGContextAddLineToPoint(context, xPos, getTopPosSoGridCentered() + gridSize() - (gridLineWidth / 2) )
            xPos += squareSize + gridLineWidth
        }
        CGContextSetRGBStrokeColor(context, 0, 0, 1, 1.0)
        CGContextStrokePath(context)
        
        // RED (Vertical)
        xPos = getLeftPosSoGridCentered() + (gridLineWidth / 2)
        yPos = getTopPosSoGridCentered() + (gridLineWidth / 2)
        for _ in 1...numLines() {
            CGContextMoveToPoint(context, xPos, yPos)
            CGContextAddLineToPoint(context, getLeftPosSoGridCentered() + gridSize() - (gridLineWidth / 2), yPos)
            yPos += squareSize + gridLineWidth
        }
        CGContextSetRGBStrokeColor(context, 1, 0, 0, 1.0)
        CGContextStrokePath(context)
        
        // Finish drawing
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        mainImageView.alpha = 1
        UIGraphicsEndImageContext()
    }
    
    
    func numSquares() -> Int {
        let ans1 = (min(mainImageView.superview!.frame.size.width, mainImageView.superview!.frame.size.height) - gridLineWidth) / (gridLineWidth + squareSize)
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
        var x = (mainImageView.superview!.frame.width - gridSize()) / 2
        x = floor(x)
        return x
    }
    
    func getTopPosSoGridCentered() -> CGFloat {
        var y = (mainImageView.superview!.frame.height - gridSize()) / 2
        y = floor(y)
        return y
    }
    
    func printDebugInfo1() {
        print("tempImageView.frame.size: \(tempImageView.frame.size)")
        print("gridLineWidth: \(gridLineWidth)")
        print("squareSize:    \(squareSize)")
        print("numSquares():  \(numSquares())")
        print("numLines():    \(numLines())")
        print("gridSize():    \(gridSize())")
        print("leftTop:       \(getLeftPosSoGridCentered()), \(getTopPosSoGridCentered()) ")
    }
    
}

