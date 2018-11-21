//
//  MainViewController.swift
//  Lango
//
//  Created by  jerry on 11/14/18.
//  Copyright © 2018  jerry. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Button Action
    @IBAction func JumpConversation(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 1
    }
    
    @IBAction func JumpProun(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 2
    }
    
    @IBAction func JumpMissions(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 3
    }
    
    @IBAction func OpenMenu(_ sender: Any) {
        // TODO:
    }
    
}
