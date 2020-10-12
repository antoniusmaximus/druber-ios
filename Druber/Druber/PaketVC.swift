//
//  PaketVC.swift
//  Druber
//
//  Created by Anton Quietzsch on 27.11.17.
//  Copyright © 2017 Anton Quietzsch. All rights reserved.
//

import Foundation
import UIKit

class PaketVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var paketCollectionView: UICollectionView!
    
    let bilder:[String] = ["1", "2", "3"]
    let icons:[String] = ["1", "2", "3"]
    let namen:[String] = ["PREMIUM", "ECO", "DOPPEL"]
    let preis:[String] = ["5€/Min", "3€/Min", "6€/Min"]
    let zeit:[String] = ["Entfernung/80km/h", "Entfernung/60km/h", "Entfernung/40km/h"]
    
    override func viewDidLoad() {
        
        let cellSize = UIScreen.main.bounds.width * 9/10
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(25, 50, 25, 50)
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        paketCollectionView.collectionViewLayout = layout

        super.viewDidLoad()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bilder.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let paketCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PaketCell
        
        paketCell.imageView.image = UIImage(named: bilder[indexPath.row] + ".jpg")
        paketCell.iconView.image = UIImage(named: icons[indexPath.row] + ".png")
        
        paketCell.dialogView.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.85)
        paketCell.goToBezahlenButton.setTitle("   \(namen[indexPath.row])   ", for: .normal)
        //paketCell.dialogLabel1.text = namen[indexPath.row]
        paketCell.dialogLabel2.text = "Preis: " + preis[indexPath.row]
        paketCell.dialogLabel3.text = "Flugzeit: " + zeit[indexPath.row]
        
        return paketCell
    }
    
}
