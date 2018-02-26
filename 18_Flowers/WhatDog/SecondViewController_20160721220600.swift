//
//  SecondViewController.swift
//  WhatDog
//
//  Created by RADIOHEAD on 16/6/18.
//  Copyright © 2016年 iradiohead. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SecondViewController: UIViewController, UMSocialUIDelegate {
    @IBOutlet weak var certifyImgHeight2: NSLayoutConstraint!
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
        shareButton.addTarget(self,
                              action: #selector(SecondViewController.shareIsPressed(_:)), forControlEvents: .TouchDown)
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
            UIView.animateWithDuration(1, animations: {
                self.exampleImage.alpha = 1.0
                self.itemName.alpha = 1.0
                self.itemDes.alpha = 1.0
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            })
            if itemClass.itemName != NOMATCH {
                self.certiyImg.hidden = false
                UIView.animateWithDuration(1, animations: {
                    self.certifyImgHeight.active = false
                    self.certifyImgBottom.active = false
                    self.certifyImgSpace.active = false
                    self.certifyImgCenter.active = true
                    self.certifyImgTrail.active = true
                    self.certifyImgHeight2.active = true
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
            })
            }
            self.shareButton.hidden = false
            UIView.animateWithDuration(1, animations: {
                self.shareButtonBottom.constant = self.shareButton.frame.size.height
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            })
            
        }
    }
    func shareFB(){
        let fbPlatform:UMSocialSnsPlatform = UMSocialSnsPlatformManager.getSocialPlatformWithName(UMShareToFacebook)
        fbPlatform.needLogin = false
        fbPlatform.snsClickHandler = {(presentingController:UIViewController!, socialControllerService:UMSocialControllerService!, isPresentInController:Bool!) in
            /* photo share
             let photo = FBSDKSharePhoto()
             photo.image = screen
             photo.userGenerated = true
             let content = FBSDKSharePhotoContent()
             content.photos = [photo]
             
             FBSDKShareDialog.showFromViewController(self,
             withContent:content,
             delegate:nil) */
            /* URL share */
            let content = FBSDKShareLinkContent ()
            content.contentURL = NSURL(string:APPSTOREURL)
            content.contentTitle = "My Dog"
            content.contentDescription = "\(self.itemName.text)"
            
            let dialog : FBSDKShareDialog = FBSDKShareDialog()
            dialog.fromViewController = self
            dialog.shareContent = content
            dialog.mode = FBSDKShareDialogMode.Native
            // if you don't set this before canShow call, canShow would always return YES
            if !dialog.canShow() {
                // fallback presentation when there is no FB app
                dialog.mode = FBSDKShareDialogMode.FeedBrowser
            }
            dialog.show()
        }
    }
    func shareIsPressed(sender: UIButton){
        print("Need to share")
        let screen = contentView.pb_takeSnapshot()
        shareFB()
        UMSocialSnsService.presentSnsIconSheetView(
            self,
            appKey:APPKEY,
            shareText:"My Dog \(self.itemName.text)",
            shareImage:screen,
            shareToSnsNames:[UMShareToInstagram,UMShareToTwitter,UMShareToFacebook,UMShareToWechatSession,UMShareToWechatTimeline, UMShareToWechatFavorite,UMShareToWhatsapp,UMShareToLine],
            delegate:nil);
    }
    deinit {
        itemApt.removeObserver(self, forKeyPath: "itemType")
    }
}

extension UIView {
    
    func pb_takeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.mainScreen().scale)
        
        drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}