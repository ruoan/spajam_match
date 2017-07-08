//
//  ViewController.swift
//  match
//
//  Created by Hiroki Tanaka on 7/8/17.
//  Copyright © 2017 Hiroki Tanaka. All rights reserved.
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
    
    // このメソッドで渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "resultView" {
            
            let resultViewController:ResultViewController = segue.destination as! ResultViewController
            
            resultViewController.result = false
        }
        
    }


}

