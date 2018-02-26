//
//  SecondViewController.swift
//  WhatDog
//
//  Created by RADIOHEAD on 16/6/18.
//  Copyright © 2016年 iradiohead. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SecondViewController: UIViewController {
    @IBOutlet weak var certifyImgTrail: NSLayoutConstraint!
    @IBOutlet weak var certifyImgCenter: NSLayoutConstraint!
    @IBOutlet weak var certifyImgSpace: NSLayoutConstraint!
    @IBOutlet weak var certifyImgHeight: NSLayoutConstraint!
    
    @IBOutlet weak var certifyImgBottom: NSLayoutConstraint!
    @IBOutlet weak var certiyImg: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var shareButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var exampleImage: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var itemDes: UILabel!
    
    var image:UIImage?
    let itemApt = ItemViewAdp()
    override func viewDidLoad() {
        super.viewDidLoad()
        itemApt.addObserver(self, forKeyPath: "itemType", options: NSKeyValueObservingOptions([.New]), context: nil)
        //self.contentView.initial_alianment()
        itemImage.image = itemApt.imageResize(image!, newSize: self.itemImage.bounds.size)
        itemName.alpha = 0
        itemDes.alpha = 0
        //indicator.center = self.itemImage.center
        indicator.startAnimating()
        NSNotificationCenter.defaultCenter().postNotificationName("VerifyImageNotification", object: self, userInfo: ["targetImage":image!])
        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "itemType" && itemApt.itemType != ""{
            indicator.hidden = true
            indicator.stopAnimating()
            let itemClass = itemApt.getMatchingItem()
            //self.contentView.exampleImage.image = itemClass.itemImage[0]
            itemName.text = itemClass.itemName
            itemDes.text = itemClass.itemDesc
            UIView.animateWithDuration(0.5, animations: {
                self.exampleImage.alpha = 1.0
                self.itemName.alpha = 1.0
                self.itemDes.alpha = 1.0
            })
            self.certiyImg.hidden = false
            UIView.animateWithDuration(10, animations: {
                self.certifyImgHeight.constant = 0.6
                self.certifyImgBottom.active = false
                self.certifyImgSpace.active = false
                self.certifyImgCenter.active = true
                self.certifyImgTrail.active = true
                
            })
            self.shareButton.hidden = false
            UIView.animateWithDuration(1, animations: {
                self.shareButtonBottom.constant = self.shareButton.frame.size.height
            })
            
        }
    }
    
    deinit {
        itemApt.removeObserver(self, forKeyPath: "itemType")
    }
}