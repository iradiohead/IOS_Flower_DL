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
    
    fileprivate let dogPool:DogPool
    fileprivate let httpVerify:HTTPVerify
    fileprivate let httpURL = "http://45.79.110.55:5001/classify_upload"
    dynamic var itemType = ""
    static let sharedInstance = ItemViewAdp()
    
    override init() {
        dogPool = DogPool()
        httpVerify = HTTPVerify(url: httpURL)
        super.init()
        NotificationCenter.default.addObserver(self, selector:#selector(ItemViewAdp.verifyItemImg(_:)), name: NSNotification.Name(rawValue: "VerifyImageNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(ItemViewAdp.getImgName(_:)), name: NSNotification.Name(rawValue: "GetImageNameNotification"), object: nil)
    }
    
    func verifyItemImg(_ notification: Notification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let image = userInfo["targetImage"] as! UIImage?
        httpVerify.verifyImg(image!)
    }
    
    func getImgName(_ notification: Notification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        itemType = userInfo["imageName"] as! String
    }
    
    func getMatchingItem() -> ItemClass {
        return dogPool.getMatchingDog(itemType)!
    }
    
    func imageResize(_ img: UIImage, newSize: CGSize) -> UIImage {
        let scale = UIScreen.main.scale
    /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
    //UIGraphicsBeginImageContext(newSize);
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        img.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
