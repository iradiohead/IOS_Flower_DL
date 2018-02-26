//
//  ContentView.swift
//  WhatDog
//
//  Created by RADIOHEAD on 16/7/14.
//  Copyright © 2016年 iradiohead. All rights reserved.
//

import UIKit

class ContentView: UIView {
    
    var itemImage = UIImageView()
    
    var exampleImage = UIImageView()
    
    var itemName = UILabel()
    
    var itemDes = UILabel()
    
    var certiImage = UIImageView()
    
    func initial_alianment() {
        print(self.frame.origin.x)
        print(self.frame.origin.y)
        print(self.frame.height)
        print(self.frame.width)
        let imageSize = self.frame.width * 0.8
        itemImage.frame = CGRect(x: 0,y: 0, width: imageSize, height: imageSize)
        itemImage.center = self.center
        let remainHeight = itemImage.frame.origin.y + self.frame.height - itemImage.frame.origin.y - itemImage.frame.height
        let exampleHeight = remainHeight * 0.8
    
        exampleImage = UIImageView(frame: CGRect(x: itemImage.frame.origin.x, y: itemImage.frame.origin.y + imageSize + (itemImage.frame.height-exampleHeight)/2, width: exampleHeight, height: exampleHeight))
        
        exampleImage.alpha = 0
        
        itemName = UILabel(frame: CGRect(x: itemImage.frame.origin.x + imageSize - exampleHeight, y: exampleImage.frame.origin.y, width: exampleHeight, height: exampleHeight * 0.2))
        itemName.alpha = 0

        
        itemDes = UILabel(frame: CGRect(x: itemName.frame.origin.x, y: itemName.frame.origin.y + exampleHeight * 0.1, width: exampleHeight, height: exampleHeight * 0.7))
        itemDes.alpha = 0

        let certiImageRaw = UIImage(contentsOfFile: "Certified-Stamp-PNG-Picture.png")
        certiImage = UIImageView(image: certiImageRaw)
        self.addSubview(itemImage)
        self.addSubview(exampleImage)
        self.addSubview(itemName)
        self.addSubview(itemDes)
    }
}


