//
//  BezahlenVC.swift
//  Druber
//
//  Created by Anton Quietzsch on 28.11.17.
//  Copyright © 2017 Anton Quietzsch. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class BezahlenVC: UIViewController {
    
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var dialogLabel2: UILabel!
    @IBOutlet weak var dialogLabel3: UILabel!
    @IBOutlet weak var applePayButton: UIButton!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var waitingItem: UIButton!
    
    override func viewDidLoad() {
        
        //Dialog
        self.dialogView.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.95)
        self.dialogLabel2.text = "Preis: "
        self.dialogLabel3.text = "Flugzeit: "
        self.dialogView.layer.cornerRadius = 15
        
        applePayButton.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.applePayButton.setTitleColor(UIColor.white, for: .normal)
        self.applePayButton.setTitle("   PAY   ", for: .normal)
        self.applePayButton.layer.cornerRadius = 13.0
        
        dismissButton.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.dismissButton.setTitleColor(UIColor.white, for: .normal)
        self.dismissButton.layer.cornerRadius = 15.0

        waitingItem.isHidden = true
        self.waitingItem.setTitle("   Drohne befindet sich im Anflug ...   ", for: .normal)
        waitingItem.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        self.waitingItem.setTitleColor(UIColor.white, for: .normal)
        self.waitingItem.layer.cornerRadius = 13.0
        
        super.viewDidLoad()
    }
    
    @IBAction func goToApplePay(_ sender: UIButton) {
        waitingItem.isHidden = false
        dialogView.isHidden = true
        dialogLabel2.isHidden = true
        dialogLabel3.isHidden = true
        applePayButton.isHidden = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func dismissToPaket(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

