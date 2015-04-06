//
//  ViewController.swift
//  This Or That
//
//  Created by Alasdair McCall on 05/04/2015.
//  Copyright (c) 2015 AJMCCALL. All rights reserved.
//

import UIKit
import AVFoundation

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
    
    var dogAudio = AVAudioPlayer()
    var catAudio = AVAudioPlayer()
    
    //MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSwipingImageView()
        self.setupAudioFiles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    //MARK: - Setup
    
    func setupSwipingImageView() {
        
        self.swipingImageView = UIImageView(frame: CGRectZero)
        self.swipingImageView.hidden = true
        self.swipingImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(swipingImageView)
    }
    
    func setupAudioFiles() {
        
        if let audioFile = setupAudioPlayerWithFile("dog1", type: "wav") {
            self.dogAudio = audioFile
        }
        
        if let audioFile = setupAudioPlayerWithFile("cat1", type: "wav") {
            self.catAudio = audioFile
        }
    }
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {

        if let path = NSBundle.mainBundle().pathForResource(file, ofType:type) {
            var url = NSURL.fileURLWithPath(path)
        
            var error: NSError?
        
            if let audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error) {
                return audioPlayer
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
//    func createOpeningViews() {
//
//        var snapFrame = self.centerImageView.frame
//        var innerFrame = CGRect(x: snapFrame.minX + 1, y: snapFrame.minY + 1, width: snapFrame.width - 2, height: snapFrame.height - 2)
//        var maskLayer = CAShapeLayer()
//        var circlePath = UIBezierPath(roundedRect: innerFrame, cornerRadius: innerFrame.width)
//        
//    }

    //MARK: - Actions
    @IBAction func handleSwipe(recognizer: UISwipeGestureRecognizer) {

        let centerFrame = self.centerImageView.frame
        var swipingImageViewFrame : CGRect
        var newImage : UIImage!
        var audioToPay = AVAudioPlayer()
        
        switch(recognizer.direction) {
        case UISwipeGestureRecognizerDirection.Up:
            swipingImageViewFrame = CGRectOffset(centerFrame, 0, centerFrame.size.height)
            newImage = self.imageLibrary.nextImageFromSet1()
            audioToPay = self.dogAudio
        case UISwipeGestureRecognizerDirection.Down:
            swipingImageViewFrame = CGRectOffset(centerFrame, 0, -centerFrame.size.height)
            newImage = self.imageLibrary.nextImageFromSet1()
            audioToPay = self.dogAudio
        case UISwipeGestureRecognizerDirection.Left:
            swipingImageViewFrame = CGRectOffset(centerFrame, centerFrame.size.width, 0)
            newImage = self.imageLibrary.nextImageFromSet2()
            audioToPay = self.catAudio
        case UISwipeGestureRecognizerDirection.Right:
            swipingImageViewFrame = CGRectOffset(centerFrame, -centerFrame.size.width, 0)
            newImage = self.imageLibrary.nextImageFromSet2()
            audioToPay = self.catAudio
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

                audioToPay.play()
                self.centerImageView.image = newImage
                self.swipingImageView.frame = CGRectZero
                self.swipingImageView.hidden = true
            })
    }
    
}

