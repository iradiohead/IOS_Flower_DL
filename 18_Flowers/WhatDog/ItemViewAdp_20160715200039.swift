//
//  itemViewAdp.swift
//  WhatDog
//
//  Created by RADIOHEAD on 16/7/4.
//  Copyright © 2016年 iradiohead. All rights reserved.
//

import Foundation
import UIKit

class ItemViewAdp:NSObject {
    
    private let dogPool:DogPool
    private let httpVerify:HTTPVerify
    private let httpURL = "http://45.79.110.55:5000/classify_upload"
    dynamic var itemType = ""
    static let sharedInstance = ItemViewAdp()
    
    override init() {
        dogPool = DogPool()
        httpVerify = HTTPVerify(url: httpURL)
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ItemViewAdp.verifyItemImg(_:)), name: "VerifyImageNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ItemViewAdp.getImgName(_:)), name: "GetImageNameNotification", object: nil)
    }
    
    func verifyItemImg(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let image = userInfo["targetImage"] as! UIImage?
        httpVerify.verifyImg(image!)
    }
    
    func getImgName(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        itemType = userInfo["imageName"] as! String
    }
    
    func getMatchingItem() -> ItemClass {
        return dogPool.getMatchingDog(itemType)!
    }
    
    func imageResize(img: UIImage, newSize: CGSize) -> UIImage {
        let scale = UIScreen.mainScreen().scale
    /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
    //UIGraphicsBeginImageContext(newSize);
        UIGraphicsBeginImageContextWithOptions(newSize, , scale)
        img.drawInRect(CGRectMake(0,0,newSize.width,newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}