//
//  AppDelegate.swift
//  WhatDog
//
//  Created by RADIOHEAD on 16/6/18.
//  Copyright © 2016年 iradiohead. All rights reserved.
//

import UIKit
//import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //FIRApp.configure()
        // Override point for customization after application launch.
        UMSocialManager.default().openLog(true)
        UMSocialManager.default().umSocialAppkey = APPKEY
        if(UMSocialManager.default().isSupport(UMSocialPlatformType.wechatSession))
        {
            UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey:WECHATKey, appSecret:WECHATSECRET, redirectURL:APPSTOREURL)
            UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatFavorite, appKey:WECHATKey, appSecret:WECHATSECRET, redirectURL:APPSTOREURL)
            UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatTimeLine, appKey:WECHATKey, appSecret:WECHATSECRET, redirectURL:APPSTOREURL)

        }
        else
        {
            UMSocialManager.default().removePlatformProvider(with: UMSocialPlatformType.wechatSession)
            UMSocialManager.default().removePlatformProvider(with: UMSocialPlatformType.wechatFavorite)
            UMSocialManager.default().removePlatformProvider(with: UMSocialPlatformType.wechatTimeLine)
        }
        if(UMSocialManager.default().isInstall(UMSocialPlatformType.facebook))
        {
            UMSocialManager.default().setPlaform(UMSocialPlatformType.facebook, appKey:FACEBOOKKEY, appSecret:nil, redirectURL:APPSTOREURL)
        }
        else
        {
            UMSocialManager.default().removePlatformProvider(with: UMSocialPlatformType.facebook)
        }
        if(!UMSocialManager.default().isInstall(UMSocialPlatformType.instagram))
        {
            UMSocialManager.default().removePlatformProvider(with: UMSocialPlatformType.instagram)
        }
        UMSocialManager.default().removePlatformProvider(with: UMSocialPlatformType.twitter)
        UMSocialManager.default().removePlatformProvider(with: UMSocialPlatformType.sina)
        UMSocialManager.default().removePlatformProvider(with: UMSocialPlatformType.line)
        UMSocialManager.default().removePlatformProvider(with: UMSocialPlatformType.whatsapp)

        //    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite),@(UMSocialPlatformType_YixinTimeLine),@(UMSocialPlatformType_LaiWangTimeLine),@(UMSocialPlatformType_Qzone)]];

        //FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions:launchOptions)
        //UMSocialInstagramHandler.openInstagram(withScale: false, paddingColor:UIColor.black);
        //UMSocialWechatHandler.setWXAppId(WECHATKey, appSecret:WECHATSECRET, url:APPSTOREURL)
        //UMSocialConfig.hiddenNotInstallPlatforms([UMShareToInstagram,UMShareToFacebook,UMShareToWechatSession,UMShareToWechatTimeline, UMShareToWechatFavorite,UMShareToWhatsapp,UMShareToLine])
        // Override point for customization after application launch.
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        //UIApplicationDelegate.sharedInstance().application(application,
        //                                                      open: url,
        //                                                      sourceApplication: sourceApplication,
        //                                                      annotation:annotation)
        //let result = UMSocialSnsService.handleOpen(url);
        let result = UMSocialManager.default().handleOpen(url)
        if (result == false) {
            //调用其他SDK，例如支付宝SDK等
        }
        return result;
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

