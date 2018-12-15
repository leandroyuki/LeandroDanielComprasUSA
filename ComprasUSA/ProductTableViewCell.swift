//
//  ProductTableViewCell.swift
//  ComprasUSA
//
//  Created by Leandro Yukio on 08/10/2018.
//  Copyright © 2018 DanielLeandro. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var ivProduct: UIImageView!
    @IBOutlet weak var lbProductName: UILabel!
    @IBOutlet weak var lbProductValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
