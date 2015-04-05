//
//  ImageLibrary.swift
//  This Or That
//
//  Created by Alasdair McCall on 05/04/2015.
//  Copyright (c) 2015 AJMCCALL. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ImageLibrary {
    
    //MARK: - Properties
    var imageIndex1 : Int = 0, imageIndex2 = 0
    var imageSet1 : [UIImage], imageSet2 : [UIImage]
    
    //MARK: - Init
    init() {
        
        let parsedResponse = ImageLibrary.imageSetFromJSON()
        imageSet1 = parsedResponse.imageSet1
        imageSet2 = parsedResponse.imageSet2
    }
    
    //MARK: - Get Image
    func nextImageFromSet1() -> UIImage {
        
        self.imageIndex1 = (self.imageIndex1 + 1) % self.imageSet1.count
        return self.imageSet1[imageIndex1]
    }
    
    func nextImageFromSet2() -> UIImage {
        
        self.imageIndex2 = (self.imageIndex2 + 1) % self.imageSet2.count
        return self.imageSet2[imageIndex2]
    }
    
    //MARK: - Parsing
    class func imageSetFromJSON() -> (imageSet1 : Array<UIImage>, imageSet2 : Array<UIImage>) {
        

        var imageSet1: [UIImage] = []
        var imageSet2: [UIImage] = []
        
        if let path = NSBundle.mainBundle().pathForResource("dogs.cats", ofType: "json") {
            if let data = NSData(contentsOfMappedFile: path) {
                let json = JSON(data: data, options: NSJSONReadingOptions.AllowFragments, error: nil)

                let imageSet1ImageNames = json["imageSets"]["set1"]
                for (index: String, subJson: JSON) in imageSet1ImageNames {

                    imageSet1.append(UIImage(named: subJson.stringValue)!)
                }
                
                let imageSet2ImageNames = json["imageSets"]["set2"]
                for (index: String, subJson: JSON) in imageSet2ImageNames {

                    imageSet2.append(UIImage(named: subJson.stringValue)!)
                }
                
            }
        }
        
        return (imageSet1, imageSet2)
    }
}