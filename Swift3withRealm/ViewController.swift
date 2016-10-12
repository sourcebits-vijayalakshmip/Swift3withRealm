//
//  ViewController.swift
//  Swift3withRealm
//
//  Created by Vijayalakshmi Pulivarthi on 12/10/16.
//  Copyright © 2016 sourcebits. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func button_Clicked(_ sender: AnyObject) {
        
        //let APIKEYVALUE = ["X-Mashape-Key":"xd90O4gfMdmshyLxk5cBvl44PPHlp1ONA3kjsnFFOAtbQnoshp"]
        
        NetworkManager.shared.retrieveCards(completion: { (backendError) in
            
            if let backendError = backendError {
                
                print(backendError)
                
                // Show error
                let alertController = UIAlertController(title: "Backend Error", message: "\(backendError.logDescription())", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                
            }
        })
        
        

    }

}

