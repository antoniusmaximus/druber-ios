//
//  PaketCell.swift
//  Druber
//
//  Created by Anton Quietzsch on 27.11.17.
//  Copyright © 2017 Anton Quietzsch. All rights reserved.
//

import UIKit

class PaketCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var dialogLabel2: UILabel!
    @IBOutlet weak var dialogLabel3: UILabel!
    @IBOutlet weak var goToBezahlenButton: UIButton!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 25
        let gray = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25)
        self.layer.borderColor = gray.cgColor
        self.layer.borderWidth = 0.5
        self.goToBezahlenButton.layer.cornerRadius = 13.0
        self.goToBezahlenButton.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.goToBezahlenButton.setTitleColor(UIColor.white, for: .normal)
        //self.goToBezahlenButton.setTitle("   BESTELLEN   ", for: .normal)
    }
    
}
