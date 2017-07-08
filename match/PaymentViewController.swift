//
//  PaymentViewController.swift
//  match
//
//  Created by ruoan on 2017/07/08.
//  Copyright © 2017年 Hiroki Tanaka. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    
    var result:Bool?
    var pay:Int?
    var total:Int?

    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "MATCH"
        
        self.payLabel.text = "¥" + (pay?.decimalStr)!
        self.totalLabel.text = "Total: ¥" + (total?.decimalStr)!

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
