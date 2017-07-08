//
//  ResultViewController.swift
//  match
//
//  Created by ruoan on 2017/07/08.
//  Copyright © 2017年 Hiroki Tanaka. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    var result: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title="MATCH"
        
        if(self.result)!{
            self.resultLabel.text = "成功!"
        } else {
            self.resultLabel.text = "残念;;"
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goNext(_ sender: Any) {
        let next:PaymentViewController = storyboard!.instantiateViewController(withIdentifier: "paymentView") as! PaymentViewController
        
        next.result = self.result
        next.pay = 7000
        next.total = 21000
        
        let navi = UINavigationController(rootViewController: next)
        
        self.present(navi,animated: true, completion: nil)
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
