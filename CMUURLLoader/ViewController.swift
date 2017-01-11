//
//  ViewController.swift
//  CMUImageLoader
//
//  Created by Camo_u on 2017. 1. 11..
//  Copyright © 2017년 Camo_u. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let start1 = Date(); // <<<<<<<<<< Start time
        load(fromURL: "http://cms.ipressroom.com.s3.amazonaws.com/240/files/20162/largetest.jpg").progress { progress in
            if progress.fractionCompleted == 1.0
            {
                let end = Date();   // <<<<<<<<<<   end time
                let timeInterval: Double = end.timeIntervalSince(start1); // <<<<< Difference in seconds (double)
                
                print("CMULoader1: \(timeInterval)");
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

