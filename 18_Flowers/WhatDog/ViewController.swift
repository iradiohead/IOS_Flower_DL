//
//  ViewController.swift
//  WhatDog
//
//  Created by RADIOHEAD on 16/6/18.
//  Copyright © 2016年 iradiohead. All rights reserved.
//

import UIKit
import ALCameraViewController

class ViewController: UIViewController {

    @IBOutlet weak var photoButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func TakePhoto(_ sender: AnyObject) {
        let cameraViewController = CameraViewController(croppingEnabled: true) { [weak self] image, asset in
            self?.dismiss(animated: true, completion: nil)
            if image != nil {
                let secondView = self!.storyboard!.instantiateViewController(withIdentifier: "secondView") as! SecondViewController
                secondView.image = image
                self!.navigationController?.pushViewController(secondView, animated: true)
            }
        }
        present(cameraViewController, animated: true, completion: nil)
        

    }

}

