//
//  ViewController.swift
//  ComprasUSA
//
//  Created by Leandro Yukio on 07/10/2018.
//  Copyright © 2018 DanielLeandro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var product: Product!
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    static func buildAlert(title:String,message:String)->UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
}




