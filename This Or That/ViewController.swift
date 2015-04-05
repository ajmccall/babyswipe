//
//  ViewController.swift
//  This Or That
//
//  Created by Alasdair McCall on 05/04/2015.
//  Copyright (c) 2015 AJMCCALL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum Direction {
        case DirectionUP
        case DirectionDown
        case DirectionLeft
        case DirectionRight
    }

    //MARK: - Properties
    @IBOutlet weak var centerImageView: UIImageView!
    var swipingImageView: UIImageView!
    
    @IBOutlet var leftSwipeGesture: UISwipeGestureRecognizer!
    @IBOutlet var rightSwipeGesture: UISwipeGestureRecognizer!
    @IBOutlet var downSwipeGesture: UISwipeGestureRecognizer!
    @IBOutlet var upSwipGesture: UISwipeGestureRecognizer!
    
    let imageLibrary = ImageLibrary()
    
    //MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipingImageView = UIImageView(frame: CGRectZero)
        swipingImageView.hidden = true
        swipingImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(swipingImageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - Actions
    @IBAction func handleSwipe(recognizer: UISwipeGestureRecognizer) {

        let centerFrame = self.centerImageView.frame
        var swipingImageViewFrame : CGRect
        var newImage : UIImage!
        
        switch(recognizer.direction) {
        case UISwipeGestureRecognizerDirection.Up:
            swipingImageViewFrame = CGRectOffset(centerFrame, 0, centerFrame.size.height)
            newImage = self.imageLibrary.nextImageFromSet1()
        case UISwipeGestureRecognizerDirection.Down:
            swipingImageViewFrame = CGRectOffset(centerFrame, 0, -centerFrame.size.height)
            newImage = self.imageLibrary.nextImageFromSet1()
        case UISwipeGestureRecognizerDirection.Left:
            swipingImageViewFrame = CGRectOffset(centerFrame, centerFrame.size.width, 0)
            newImage = self.imageLibrary.nextImageFromSet2()
        case UISwipeGestureRecognizerDirection.Right:
            swipingImageViewFrame = CGRectOffset(centerFrame, -centerFrame.size.width, 0)
            newImage = self.imageLibrary.nextImageFromSet2()
        default:
            swipingImageViewFrame = CGRectZero
        }
        
        if(!CGRectEqualToRect(swipingImageViewFrame, CGRectZero)) {
            
            self.swipingImageView.frame = swipingImageViewFrame
            self.swipingImageView.image = newImage
            self.swipingImageView.hidden = false
        }

        UIView.animateWithDuration(0.2,
            delay: 0,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                
                self.swipingImageView.center = self.centerImageView.center
            },
            completion: { finished in

                self.centerImageView.image = newImage
                self.swipingImageView.frame = CGRectZero
                self.swipingImageView.hidden = true
            })
    }
    
}

