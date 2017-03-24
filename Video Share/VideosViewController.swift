//
//  VideosViewController.swift
//  Video Share
//
//  Created by Samarth Paboowal on 24/03/17.
//  Copyright © 2017 Junkie Labs. All rights reserved.
//

import UIKit
import Firebase

class VideosViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleLogout))
        
        navigationItem.title = ""
        checkIfUserIsLoggedIn()
    }
    
    func checkIfUserIsLoggedIn() {
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            
            fetchUserNameAndDisplayNavBarTitle()
        }
    }
    
    func handleLogout() {
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error {
            print(error)
        }
        
        let loginViewController = LoginViewController()
        loginViewController.videosViewController = self
        present(loginViewController, animated: true, completion: nil)
    }
    
    func fetchUserNameAndDisplayNavBarTitle() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if let dict = snapshot.value as? [String: Any] {
                
                self.navigationItem.title = dict["name"] as? String
            }
            
        }, withCancel: nil)
    }
}
