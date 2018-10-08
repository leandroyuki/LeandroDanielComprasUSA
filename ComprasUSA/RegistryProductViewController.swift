//
//  RegistryProductViewController.swift
//  ComprasUSA
//
//  Created by Leandro Yukio on 08/10/2018.
//  Copyright © 2018 DanielLeandro. All rights reserved.
//

import UIKit

class RegistryProductViewController: UIViewController {

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var ivProductImage: UIImageView!
    @IBOutlet weak var tfProductState: UITextField!
    @IBAction func btAddState(_ sender: UIButton) {
    }
    @IBOutlet weak var tfProductValue: UITextField!
    
    @IBOutlet weak var swCreditCard: UISwitch!
    
    @IBAction func btRegistryProduct(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
}



