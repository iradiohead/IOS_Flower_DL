//
//  itemClass.swift
//  WhatDog
//
//  Created by RADIOHEAD on 16/6/19.
//  Copyright © 2016年 iradiohead. All rights reserved.
//

import UIKit

class ItemClass {
    let itemName:String
    let itemDesc:String
    var itemImage:[UIImage] = []
    
    init(name:String, desc:String) {
        self.itemName = name
        self.itemDesc = desc
    }
    
    func addItemImage(_ image:UIImage) {
        itemImage.append(image)
    }
    
}
