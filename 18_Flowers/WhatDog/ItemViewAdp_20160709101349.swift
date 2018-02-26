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
    dynamic var itemType:String?
    static let sharedInstance = ItemViewAdp()
    
    override init() {
        dogPool = DogPool()
        httpVerify = HTTPVerify(url: httpURL)
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(ItemViewAdp.verifyItemImg(_:)), name: "VerifyImageNotification", object: nil)
    }
    
    func verifyItemImg(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let image = userInfo["targetImage"] as! UIImage?
        httpVerify.verifyImg(image!, name: &itemType!)
    }
    
    func getMatchingItem() -> ItemClass {
        return dogPool.getMatchingDog(itemType!)!
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}