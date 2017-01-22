//
//  FeedVC.swift
//  Social App
//
//  Created by Abed on 22/01/2017.
//  Copyright © 2017 Webiaturist. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func signOutPressed(_ sender: Any) {
        _ = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        do{
            try FIRAuth.auth()?.signOut()
        } catch{
            let error = error
            print("Error: - \(error)")
        }
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
}
