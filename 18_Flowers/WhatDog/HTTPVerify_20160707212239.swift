//
//  HTTPVerify.swift
//  WhatDog
//
//  Created by RADIOHEAD on 16/6/21.
//  Copyright © 2016年 iradiohead. All rights reserved.
//

import UIKit

class HTTPVerify {
    
    let url:String
    
    init(url:String) {
        self.url = url
    }
    
    func verifyImg(image:UIImage) -> String {
        var imageData = UIImagePNGRepresentation(image)
        var imageName = ""
        if imageData != nil {
            var request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.HTTPMethod = "POST"
            
            let boundary = "Boundary-\(NSUUID().UUIDString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            var body = NSMutableData()
            //define the data post parameter
            
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"test\"\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("hi\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            
            let fname = "imagefile"
            let mimetype = "file"
            
            body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Disposition:form-data; name=\"\(fname)\"; filename=\"\(fname)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Content-Type: \(mimetype)\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(imageData!)
            body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            
            body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            
            request.HTTPBody = body
            let task =  NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
                        (data, response, error) -> Void in
                        if let data = data {
                                                                                
                            // You can print out response object
                            print("******* response = \(response)")
                                                                                
                            print(data.length)
                            // you can use data here
                                                                                
                            // Print out reponse body
                            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                            print("****** response data = \(responseString!)")
                            let kDefaultHtmlParseOption  = ParseOption.HtmlParseUseLibxml([.RECOVER, .NOERROR, .NOWARNING])
                            if let doc = HTML(html: responseString! as String, encoding: NSUTF8StringEncoding,option: kDefaultHtmlParseOption) {
                                print(doc.title)
                                
                                // Search for nodes by XPath
                                for link in doc.xpath("//div[@id='flatpred']/ul/li/h4/a") {
                                    imageName = link.text!
                                    break
                                }
                            }
                                                                                
                            //let json =  try!NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary
                                                                                
                            //print("json value \(json)")
                            
                            dispatch_async(dispatch_get_main_queue(),{
                            });
                                                                                
                        } else if let error = error {
                            print(error.description)
                        }
            })
            task.resume()
        }
        return imageName
    }
}
