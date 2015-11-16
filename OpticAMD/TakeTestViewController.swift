//
//  TakeTestViewController.swift
//  OpticAMD
//
//  Created by Brian on 11/5/15.
//  Copyright © 2015 Med AppJam 2015 - Team 9. All rights reserved.
//

import UIKit
import EasyImagy

@IBDesignable
class TakeTestViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var mainImageView: UIImageView! // Contains drawing except for the line currently being drawn
    @IBOutlet weak var tempImageView: UIImageView! // Contains line currently being drawn

    // MARK: Properties
    var lastPointDrawn = CGPoint.zero    // last point drawn on canvas
    var continuousStroke = false              // true if stroke is continuous
    var brushLineWidth: CGFloat = 50      // width of line to draw
    var gridLineWidth: CGFloat = 5
    var squareSize: CGFloat = 25
    var red:        CGFloat = 0.1
    var green:      CGFloat = 0.1
    var blue:       CGFloat = 0.1
    var opacity:    CGFloat = 0.50
    var saveAndContinueAlertController: UIAlertController?
    var saveAndFinishAlertController: UIAlertController?
    var leftImage: UIImage?
    var rightImage: UIImage?
    var savedTestResults = SavedTestResults()
    var isEraser = false


    // MARK: Setup
    override func viewDidLoad() {

        // 'Save & Continue' alert controller
        saveAndContinueAlertController = UIAlertController(title: "Left eye test result saved", message: nil, preferredStyle: .Alert)
        let saveAndContinueAlertAction = UIAlertAction(title: "OK", style: .Default) { (ACTION) -> Void in
            self.performSegueWithIdentifier("LeftToRightSegue", sender: self)
        }
        saveAndContinueAlertController?.addAction(saveAndContinueAlertAction)

        // 'Save & Finish' alert controller
        saveAndFinishAlertController = UIAlertController(title: "Right eye test result saved", message: nil, preferredStyle: .Alert)
        let saveAndFinishAlertControllerAction = UIAlertAction(title: "OK", style: .Default) { (ACTION) -> Void in
            self.performSegueWithIdentifier("RightToMainSegue", sender: self)
        }
        saveAndFinishAlertController?.addAction(saveAndFinishAlertControllerAction)

        drawNewGrid()
    }
    func setOrResetView() {
        mainImageView.image = nil
        tempImageView.image = nil
        drawNewGrid()
    }

    
    // Brush width slider
    @IBAction func changeBrushWidth(sender: UISlider) {
        sender.value = ceil(sender.value / 10.0) * 10.0
        brushLineWidth = CGFloat(sender.value)
    }
    

    // Color buttons
    @IBAction func changeColor(sender: UIButton) {
        let color = sender.titleLabel!.text!
        print(color)
        switch color {
        case "orange":
            red = 1.0
            green = 0.5
            blue = 0.0
            isEraser = false
        case "blue":
            red = 0.0
            green = 0.5
            blue = 1.0
            isEraser = false
        case "green":
            red = 0.0
            green = 0.5
            blue = 0.0
            isEraser = false
        case "grey":
            red = 0.1
            green = 0.1
            blue = 0.1
            isEraser = false
        case "eraser":
            isEraser = true
        default:
            break
        }

    }


    // MARK: Touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Called when one or more fingers touch down in a view or window

        // Reset continuousStroke boolean
        continuousStroke = false

        // Save touch location in lastPointDrawn
        if let touch = touches.first as UITouch! {
            print(touch.locationInView(self.view))
            lastPointDrawn = touch.locationInView(self.view)
            lastPointDrawn.x -= mainImageView.superview!.frame.origin.x
            lastPointDrawn.y -= mainImageView.superview!.frame.origin.y
        }

    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Called when one or more fingers associated with an event move within a view or window

        // 6
        continuousStroke = true
        if let touch = touches.first as UITouch! {
            var currentPoint = touch.locationInView(view)
            currentPoint.x -= mainImageView.superview!.frame.origin.x
            currentPoint.y -= mainImageView.superview!.frame.origin.y
            drawLineFrom(lastPointDrawn, toPoint: currentPoint)

            // 7
            lastPointDrawn = currentPoint
        }

    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Called when one or more fingers are raised from a view or window

        if !continuousStroke {
            // draw a single point
            drawLineFrom(lastPointDrawn, toPoint: lastPointDrawn)
        }
/*
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.superview!.frame.size)

        
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: superviewWidth(), height: superviewHeight()), blendMode: CGBlendMode.Normal, alpha: 1.0)
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: tempImageView.superview!.frame.size.width, height: tempImageView.superview!.frame.size.height), blendMode: CGBlendMode.Normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        tempImageView.image = nil*/
    }
    
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
        CGContextSetLineWidth(context, brushLineWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        if isEraser {
            CGContextSetBlendMode(context, CGBlendMode.Clear)
        } else {
            CGContextSetBlendMode(context, CGBlendMode.Normal)
        }

        // 4
        CGContextStrokePath(context)

        // Fill outside of grid with white (so you can't draw outside of grid)
        CGContextSetRGBFillColor(context, 1, 1, 1, 1.0)
        CGContextFillRect(context, CGRect(x: 0, y: 0, width: superviewWidth(), height: gridTopEdge()))
        CGContextFillRect(context, CGRect(x: 0, y: gridTopEdge() + gridSize() , width: superviewWidth(), height: gridTopEdge() ))

        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }


    // MARK: Actions
    @IBAction func reset(sender: UIBarButtonItem) {
        setOrResetView()
    }
    @IBAction func saveLeftAndContinue(sender: UIBarButtonItem) {
        // merge main and temp
        UIGraphicsBeginImageContext(mainImageView.superview!.frame.size)

        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: superviewWidth(), height: superviewHeight()), blendMode: CGBlendMode.Normal, alpha: 1.0)
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: tempImageView.superview!.frame.size.width, height: tempImageView.superview!.frame.size.height), blendMode: CGBlendMode.Normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        tempImageView.image = nil

        leftImage = createImageFromGrid()
        if leftImage == nil {
            leftImage = UIImage(named: "cat")
        }

        self.presentViewController(saveAndContinueAlertController!, animated: true, completion: nil)
    }
    @IBAction func saveRightAndFinish(sender: UIBarButtonItem) {
        // merge main and temp
        UIGraphicsBeginImageContext(mainImageView.superview!.frame.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: superviewWidth(), height: superviewHeight()), blendMode: CGBlendMode.Normal, alpha: 1.0)
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: tempImageView.superview!.frame.size.width, height: tempImageView.superview!.frame.size.height), blendMode: CGBlendMode.Normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        tempImageView.image = nil

        rightImage = createImageFromGrid()
        if leftImage == nil {
            leftImage = UIImage(named: "cat")
        }

        SwiftSpinner.show("Saving...")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {

            // Calculate areas
            let leftAreaData = self.calculateAreas(self.leftImage)
            let rightAreaData = self.calculateAreas(self.rightImage)

            print("Left Area Data\n  wavy: \(leftAreaData["wavy"]!)\n  blurry: \(leftAreaData["blurry"]!)\n  blind: \(leftAreaData["blind"]!)\n  dark: \(leftAreaData["dark"]!)\n  total: \(leftAreaData["total"]!)")
            print("\nRight Area Data\n  wavy: \(rightAreaData["wavy"]!)\n  blurry: \(rightAreaData["blurry"]!)\n  blind: \(rightAreaData["blind"]!)\n  dark: \(rightAreaData["dark"]!)\n  total: \(rightAreaData["total"]!)")

            self.savedTestResults.add(TestResult(date: NSDate(), leftImage: self.leftImage, rightImage: self.rightImage, leftImageAreaData: leftAreaData, rightImageAreaData: rightAreaData)!)
            self.savedTestResults.save()
            self.presentViewController(self.saveAndFinishAlertController!, animated: true, completion: nil)

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SwiftSpinner.hide()
            })
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "LeftToRightSegue" {
            if let destinationViewController = segue.destinationViewController as? TakeTestViewController {
                destinationViewController.leftImage = leftImage
            }
        }
    }


    // MARK: Area Calculation
    func calculateAreas(image :UIImage?) -> [String: Double] {
        // Attempting to calculate area
        let easyImage = Image(UIImage: image!)!

        // Data is stored in the follow order [white, black, orageOverLines, orange,
        // blueOverLines, blue, greenOverLines, green, greyOverLines, grey]
        var imageData: [Int: Int] = [
            255255255:  0,  // white
            0:          0,  // black
            128065000:  0,  // orange over lines
            255192127:  0,  // orange
            65128:      0,  // blue over lines
            127192255:  0,  // blue
            65000:      0,  // green over lines
            127192127:  0,  // green
            141141141:  0,  // grey over lines
            14014014:   0   // grey
        ]

        for pixel in easyImage {
            let RGB = Int(pixel.red) * 1000000 + Int(pixel.green) * 1000 + Int(pixel.blue)
            if let count = imageData[RGB] {
                imageData[RGB] = count + 1
            }
        }

        var totalPixelCount = 0.0
        for (_,v) in imageData {
            totalPixelCount += Double(v)
        }

        var areaData = [String: Double]()
        areaData["wavy"] = (Double(imageData[128065000]!) + Double(imageData[255192127]!)) / totalPixelCount // orange
        areaData["blurry"] = (Double(imageData[65128]!) + Double(imageData[127192255]!)) / totalPixelCount // blue
        areaData["blind"] = (Double(imageData[65000]!) + Double(imageData[127192127]!)) / totalPixelCount // light grey
        areaData["dark"] = (Double(imageData[141141141]!) + Double(imageData[14014014]!)) / totalPixelCount // dark grey
        areaData["total"] = areaData["wavy"]! + areaData["blurry"]! + areaData["blind"]! + areaData["dark"]!

        return areaData
    }


    // MARK: Grid
    func drawNewGrid() {
        var xPos : CGFloat
        var yPos : CGFloat
        var context: CGContext?

        // BORDER
        //        drawGridBorderForDebugging()

        // Set up for drawing
        UIGraphicsBeginImageContext(mainImageView.superview!.frame.size)
        context = UIGraphicsGetCurrentContext()
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, gridLineWidth)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: superviewWidth(), height: superviewHeight()))

        // WHITE (Background)
        CGContextSetRGBFillColor(context, 1, 1, 1, 1.0)
        CGContextFillRect(context, CGRect(x: 0, y: 0, width: mainImageView.superview!.frame.size.width, height: mainImageView.superview!.frame.size.height))

        // BLUE (Horizontal)
        xPos = gridLeftDrawingEdge()
        yPos = gridTopDrawingEdge()
        for _ in 1...gridNumLines() {
            CGContextMoveToPoint(context, xPos, yPos)
            CGContextAddLineToPoint(context, xPos, gridTopEdge() + gridSize() - (gridLineWidth / 2) )
            xPos += squareSize + gridLineWidth
        }
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0)
        CGContextStrokePath(context)

        // RED (Vertical)
        xPos = gridLeftDrawingEdge()
        yPos = gridTopDrawingEdge()
        for _ in 1...gridNumLines() {
            CGContextMoveToPoint(context, xPos, yPos)
            CGContextAddLineToPoint(context, gridLeftEdge() + gridSize() - (gridLineWidth / 2), yPos)
            yPos += squareSize + gridLineWidth
        }

        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1.0)
        CGContextStrokePath(context)

        // Finish drawing
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        mainImageView.alpha = 1.0
        UIGraphicsEndImageContext()
    }
    func superviewWidth() -> CGFloat {
        return mainImageView.superview!.frame.size.width
    }
    func superviewHeight() -> CGFloat {
        return mainImageView.superview!.frame.size.height
    }
    func gridNumSquares() -> Int {
        return Int(floor((min(superviewWidth(), superviewHeight()) - gridLineWidth) / (gridLineWidth + squareSize)))
    }
    func gridNumLines() -> Int {
        return gridNumSquares() + 1
    }
    func gridSize() -> CGFloat {
        return CGFloat(gridNumSquares()) * (squareSize + gridLineWidth) + gridLineWidth
    }
    func gridLeftEdge() -> CGFloat {
        return floor((superviewWidth() - gridSize()) / 2)
    }
    func gridTopEdge() -> CGFloat {
        return floor((superviewHeight() - gridSize()) / 2)
    }
    func gridLeftDrawingEdge() -> CGFloat {
        return gridLeftEdge() + (gridLineWidth / 2)
    }
    func gridTopDrawingEdge() -> CGFloat {
        return gridTopEdge() + (gridLineWidth / 2)
    }
    func createImageFromGrid() -> UIImage {
        // Create rectangle from middle of current image
        let cropRect = CGRectMake(gridLeftEdge() - (gridLineWidth / 2), gridTopEdge() - (gridLineWidth / 2) , gridSize() + (gridLineWidth / 2), gridSize() + (gridLineWidth / 2)) ;
        let imageRef = CGImageCreateWithImageInRect(mainImageView.image?.CGImage, cropRect)
        let croppedImage = UIImage(CGImage: imageRef!)
        return croppedImage
    }


    // MARK: Debug
    func printDebugInfo1() {
        print("tempImageView.frame.size: \(tempImageView.frame.size)")
        print("gridLineWidth: \(gridLineWidth)")
        print("squareSize:    \(squareSize)")
        print("gridNumSquares():  \(gridNumSquares())")
        print("gridNumLines():    \(gridNumLines())")
        print("gridSize():    \(gridSize())")
        print("leftTop:       \(gridLeftEdge()), \(gridTopEdge()) ")
    }
    func drawGridBorderForDebugging() {
        var context: CGContext?
        UIGraphicsBeginImageContext(mainImageView.superview!.frame.size)
        context = UIGraphicsGetCurrentContext()
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: superviewWidth(), height: superviewHeight()))
        CGContextMoveToPoint(context, 0, 0)
        CGContextAddLineToPoint(context, superviewWidth(), 0)
        CGContextAddLineToPoint(context, superviewWidth(), superviewHeight())
        CGContextAddLineToPoint(context, 0, superviewHeight())
        CGContextAddLineToPoint(context, 0, 0)
        CGContextMoveToPoint(context, mainImageView.superview!.frame.origin.x, mainImageView.superview!.frame.origin.y)
        CGContextAddLineToPoint(context, mainImageView.superview!.frame.origin.x + 100, mainImageView.superview!.frame.origin.y + 100)
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, gridLineWidth)
        CGContextSetRGBStrokeColor(context, 0, 1, 1, 1.0)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        CGContextStrokePath(context)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        mainImageView.alpha = 1.0
        UIGraphicsEndImageContext()
    }

}

