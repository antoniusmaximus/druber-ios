//
//  TicketsTVC.swift
//  Druber
//
//  Created by Anton Quietzsch on 31.10.17.
//  Copyright © 2017 Anton Quietzsch. All rights reserved.
//

import Foundation
import UIKit

class TicketsTVC: UITableViewController {
    
    @IBOutlet weak var creditItem: UIButton!
    @IBOutlet weak var enterCreditCode: UITextField!
    @IBOutlet weak var addCreditItem: UIButton!
    
    @IBOutlet weak var insuranceCell: UITableViewCell!
    @IBOutlet weak var goldCell: UITableViewCell!
    @IBOutlet weak var diamantCell: UITableViewCell!
    @IBOutlet weak var platinCell: UITableViewCell!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var FaceIDSwitch: UISwitch!
    @IBOutlet weak var WalletSwitch: UISwitch!
    @IBOutlet weak var logoutCell: UITableViewCell!
    
    @IBOutlet weak var insuranceStatus: UIButton!
    @IBOutlet weak var goldStatus: UIButton!
    @IBOutlet weak var diamondStatus: UIButton!
    @IBOutlet weak var platinStatus: UIButton!
    
    @IBOutlet weak var logInOut: UIButton!
    
    var credit = 10
    var insurance = false
    var abonnement = false
    var profile = true
    
    @IBAction func loggedInOut(_ sender: Any) {
        profile = !profile
        if profile == true {
            loggingInOut(a: true)
            usernameLabel.text = "antonius"
            logInOut.setTitle("Abmelden", for: .normal)
            insuranceCell.accessoryType = .none
            goldCell.accessoryType = .none
            diamantCell.accessoryType = .none
            platinCell.accessoryType = .none
        } else if profile == false {
            loggingInOut(a: false)
            usernameLabel.text = "Nicht angemeldet"
            logInOut.setTitle("Anmelden", for: .normal)
        }
    }
    
    func loggingInOut(a: Bool) {
        creditItem.isHidden = !a
        FaceIDSwitch.isEnabled = a
        WalletSwitch.isEnabled = a
        enterCreditCode.isEnabled = a
        addCreditItem.isEnabled = a
        insuranceStatus.isEnabled = a
        goldStatus.isEnabled = a
        diamondStatus.isEnabled = a
        platinStatus.isEnabled = a
    }
    
    override func viewDidLoad() {
        
        //Credit
        setCreditScore()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
    
    }
    
    @objc func tap(gesture: UITapGestureRecognizer) {
        enterCreditCode.resignFirstResponder()
    }
    
    func setCreditScore() {
        creditItem.setTitle("   Guthaben: €\(credit)   ", for: .normal)
        creditItem.setTitleColor(UIColor.white, for: .normal)
        creditItem.layer.cornerRadius = 15.0
        creditItem.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func updateCredit(_ sender: UIButton) {
        credit += 5
        setCreditScore()
        self.view.endEditing(true)
        enterCreditCode.text = ""
    }
    @IBAction func buyInsurance(_ sender: Any) {
        insurance = !insurance
        if insurance == true {
            insuranceCell.accessoryType = .checkmark
            insuranceStatus.setTitle("Entfernen", for: .normal)
            insuranceStatus.setTitleColor(UIColor.red, for: .normal)
        } else if insurance == false {
            insuranceCell.accessoryType = .none
            insuranceStatus.setTitle("Buchen", for: .normal)
            insuranceStatus.setTitleColor(UIColor.blue, for: .normal)
        }
    }
    
    @IBAction func buyGold(_ sender: Any) {
        buyAbonnement(a: goldCell, b: goldStatus, c: diamondStatus, d: platinStatus)
    }
    
    @IBAction func buydiamond(_ sender: Any) {
        buyAbonnement(a: diamantCell, b: diamondStatus, c: goldStatus, d: platinStatus)
    }
    
    @IBAction func buyPlatin(_ sender: Any) {
        buyAbonnement(a: platinCell, b: platinStatus, c: goldStatus, d: diamondStatus)
    }
    
    func buyAbonnement(a: UITableViewCell!, b: UIButton!, c: UIButton!, d: UIButton!) {
        abonnement = !abonnement
        if abonnement == true {
            a.accessoryType = .checkmark
            b.setTitle("Entfernen", for: .normal)
            b.setTitleColor(UIColor.red, for: .normal)
            c.isEnabled = false
            c.setTitleColor(UIColor.gray, for: .normal)
            d.setTitleColor(UIColor.gray, for: .normal)
            d.isEnabled = false
        } else if insurance == false {
            a.accessoryType = .none
            b.setTitle("Buchen", for: .normal)
            b.setTitleColor(UIColor.blue, for: .normal)
            c.isEnabled = true
            c.setTitleColor(UIColor.blue, for: .normal)
            d.setTitleColor(UIColor.blue, for: .normal)
            d.isEnabled = true
        }
    }
}
