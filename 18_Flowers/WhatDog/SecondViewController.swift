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
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var shareButtonBottom: NSLayoutConstraint!
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
        contentView.bringSubview(toFront: indicator)
        contentView.bringSubview(toFront: itemNameLabel)
        itemApt.addObserver(self, forKeyPath: "itemType", options: NSKeyValueObservingOptions([.new]), context: nil)
        //self.contentView.initial_alianment()
        itemImage.image = itemApt.imageResize(image!, newSize: self.itemImage.bounds.size)
        itemName.alpha = 0
        itemDes.alpha = 0
        //indicator.center = self.itemImage.center
        indicator.startAnimating()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "VerifyImageNotification"), object: self, userInfo: ["targetImage":image!])
        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        bannerView.adUnitID = "ca-app-pub-2492190986050641/5498788017"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        shareButton.addTarget(self,
                              action: #selector(SecondViewController.shareIsPressed(_:)), for: .touchDown)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "itemType" && itemApt.itemType != ""{
            indicator.isHidden = true
            indicator.stopAnimating()
            let itemClass = itemApt.getMatchingItem()
            if itemClass.itemName != NOMATCH {
                exampleImage.image = itemClass.itemImage[0]
            }
            itemName.text = itemClass.itemName
            itemDes.text = itemClass.itemDesc
            itemNameLabel.text = itemClass.itemName
            //itemDes.adjustFontSizeToFitRect(itemDes.bounds)
            UIView.animate(withDuration: 1, animations: {
                self.exampleImage.alpha = 1.0
                self.itemName.alpha = 1.0
                self.itemDes.alpha = 1.0
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            })
            if itemClass.itemName != NOMATCH {
                UIView.animate(withDuration: 1, animations: {
                    self.itemNameLabel.alpha = 1.0
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                })
            }
            self.shareButton.isHidden = false
            UIView.animate(withDuration: 1, animations: {
                self.shareButtonBottom.constant = self.shareButton.frame.size.height + 10
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
    func getUserInfoForPlatform(platformType:UMSocialPlatformType){
        UMSocialManager.default().getUserInfo(with: platformType, currentViewController: self, completion: { (result:Any?, error:Error?) in
            if let userinfo  = result as? UMSocialUserInfoResponse {
                let message = " name: \(userinfo.name)\n icon: \(userinfo.iconurl)\n gender: \(userinfo.gender)\n"
                print(message)
                let alert = UIAlertView.init(title: "UserInfo", message: message, delegate: nil, cancelButtonTitle: NSLocalizedString("确定", comment: "确定"))
                alert.show()
            }
        })
    }
    func shareIsPressed(_ sender: UIButton){
        print("Need to share")
        UIView.beginAnimations("rotate", context: nil)
        UIView.setAnimationDuration(0.5)
        self.shareButton.transform = CGAffineTransform(rotationAngle: 360)
        UIView.commitAnimations()

        let screen = contentView.pb_takeSnapshot()
        //显示分享面板
        UMSocialUIManager.showShareMenuViewInWindow {[weak self] (platformType:UMSocialPlatformType, shareSelectionView) in
            let messageObject:UMSocialMessageObject = UMSocialMessageObject.init()
            messageObject.text = "My Dog"
            let shareObject:UMShareImageObject = UMShareImageObject.init()
            shareObject.title = "My Dog"
            shareObject.descr = "Share my dog"
            shareObject.thumbImage = UIImage.init(named: "Dog")
            shareObject.shareImage = screen
            messageObject.shareObject = shareObject;
            UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: self, completion: { (shareResponse, error) in
                if error != nil {
                    print("Share Fail with error ：%@", error)
                }else{
                    self?.getUserInfoForPlatform(platformType: platformType)
                    print("Share succeed")
                }
                })
        }
        /*
        UMSocialSnsService.presentSnsIconSheetView(
            self,
            appKey:APPKEY,
            shareText:"My Dog",
            shareImage:screen,
            shareToSnsNames:[UMShareToInstagram,UMShareToTwitter,UMShareToFacebook,UMShareToWechatSession,UMShareToWechatTimeline, UMShareToWechatFavorite,UMShareToWhatsapp,UMShareToLine],
            delegate:nil);
 */
    }

    deinit {
        itemApt.removeObserver(self, forKeyPath: "itemType")
    }
}

extension UIView {
    
    func pb_takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

