//
//  LoginViewController.swift
//  Hallo
//
//  Created by Dreamup on 7/19/17.
//  Copyright © 2017 Dreamup. All rights reserved.
//

import UIKit


class LoginViewController: UIViewController {

    var isConnected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func connectServer(_ sender: Any) {
        
        SocketManager.sharedInstance.connectToServerWithNickname(nickname: "tuandz", completionHandler: {
            userlist in
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        })
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
  
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return isConnected
    }
}



