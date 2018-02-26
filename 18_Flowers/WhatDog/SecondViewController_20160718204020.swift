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
    
    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var itemImage: UIImageView!
    
    @IBOutlet weak var exampleImage: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var itemDes: UILabel!
    
    var shareButton: UIButton!
    
    private var indicator: UIActivityIndicatorView!

    var image:UIImage?
    let itemApt = ItemViewAdp()
    override func viewDidLoad() {
        super.viewDidLoad()
        itemApt.addObserver(self, forKeyPath: "itemType", options: NSKeyValueObservingOptions([.New]), context: nil)
        //self.contentView.initial_alianment()
        self.itemImage.image = itemApt.imageResize(image!, newSize: self.itemImage.bounds.size)
        indicator = UIActivityIndicatorView()
        indicator.center.x = UIScreen.mainScreen().bounds.width/2
        indicator.center.y = se
        //indicator.center = self.itemImage.center
        indicator.activityIndicatorViewStyle = .WhiteLarge
        indicator.startAnimating()
        self.view.addSubview(indicator)        // Do any additional setup after loading the view, typically from a nib.
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
            indicator.stopAnimating()
            let itemClass = itemApt.getMatchingItem()
            //self.contentView.exampleImage.image = itemClass.itemImage[0]
            self.itemName.text = itemClass.itemName
            self.itemDes.text = itemClass.itemDesc
            UIView.animateWithDuration(0.5, animations: {
                self.exampleImage.alpha = 1.0
                self.itemName.alpha = 1.0
                self.itemDes.alpha = 1.0
            })
        }
    }
    
    deinit {
        itemApt.removeObserver(self, forKeyPath: "itemType")
    }
}