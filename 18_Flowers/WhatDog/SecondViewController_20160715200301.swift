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
    @IBOutlet weak var contentView: ContentView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    var shareButton: UIButton!
    
    private var indicator: UIActivityIndicatorView!

    var image:UIImage?
    let itemApt = ItemViewAdp()
    override func viewDidLoad() {
        super.viewDidLoad()
        itemApt.addObserver(self, forKeyPath: "itemType", options: NSKeyValueObservingOptions([.New]), context: nil)

        self.contentView.itemImage!.image = itemApt.imageResize(image!, newSize: self.contentView.frame.size)
        indicator = UIActivityIndicatorView()
        indicator.center = self.contentView.itemImage!.center
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
            self.contentView.itemName!.text = itemClass.itemName
            self.contentView.itemDes!.text = itemClass.itemDesc
            UIView.animateWithDuration(0.5, animations: {
                self.contentView.exampleImage!.alpha = 1.0
                self.contentView.itemName!.alpha = 1.0
                self.contentView.itemDes!.alpha = 1.0
            })
        }
    }
    
    deinit {
        itemApt.removeObserver(self, forKeyPath: "itemType")
    }
}