//
//  HTTPVerify.swift
//  WhatDog
//
//  Created by RADIOHEAD on 16/6/21.
//  Copyright © 2016年 iradiohead. All rights reserved.
//

import UIKit
import Kanna

let NOVALUE = "NoValue"

class HTTPVerify {
    
    let url:String
    
    init(url:String) {
        self.url = url
    }
    func compressImage(_ sourceImage:UIImage) -> UIImage {
        let imageSize = sourceImage.size
        let width = imageSize.width
        let height = imageSize.height
        let targetWidth:CGFloat = 256.0
        let targetHeight = (targetWidth / width) * height
        if width > targetWidth {
            UIGraphicsBeginImageContext(CGSize(width: targetWidth, height: targetHeight))
            sourceImage.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
        }
        else {
            return sourceImage
        }
    }
    
    func verifyImg(_ image:UIImage) {
        let compressedImage = self.compressImage(image)
        let imageData = UIImagePNGRepresentation(compressedImage)
        var imageName = NOVALUE
        if imageData != nil {
            let request = NSMutableURLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
            
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            let body = NSMutableData()
            //define the data post parameter
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"test\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("hi\r\n".data(using: String.Encoding.utf8)!)
            
            
            let fname = "imagefile"
            let mimetype = "file"
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"\(fname)\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(imageData!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            
            
            body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
            
            request.httpBody = body as Data
            
            let task =  URLSession.shared.dataTask(with: request as URLRequest) {data, response, error in
                        if let data = data {
                                                                                
                            // You can print out response object
                            print("******* response = \(response)")
                                                                                
                            print(data.count)
                            // you can use data here
                                                                                
                            // Print out reponse body
                            let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                            print("****** response data = \(responseString!)")
                            let kDefaultHtmlParseOption  = ParseOption.htmlParseUseLibxml([.RECOVER, .NOERROR, .NOWARNING])
                            if let doc = HTML(html: responseString! as String, encoding: String.Encoding.utf8,option: kDefaultHtmlParseOption) {
                                print(doc.title!)
                                
                                // Search for nodes by XPath
                                for link in doc.xpath("//div[@id='flatpred']/ul/li/h4/a") { //TODO: doc.xpath may be NULL
                                    imageName = link.text!
                                    break
                                }
                            }
                        
                            
                            //let json =  try!NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary
                                                                                
                            //print("json value \(json)")
                            
                            DispatchQueue.main.async(execute: { () -> Void in                               NotificationCenter.default.post(name: Notification.Name(rawValue: "GetImageNameNotification"), object: self, userInfo: ["imageName":imageName])
                            });
                            
                        } else if let error = error {
                            print(error)
                            DispatchQueue.main.async(execute: { () -> Void in
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "GetImageNameNotification"), object: self, userInfo: ["imageName":imageName])
                            })
                        }
            }
            task.resume()
        }
    }
}
