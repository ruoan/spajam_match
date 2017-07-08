//
//  WaitingViewController.swift
//  match
//
//  Created by ruoan on 2017/07/08.
//  Copyright © 2017年 Hiroki Tanaka. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

class WaitingViewController: UIViewController {

    @IBOutlet weak var loading: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "MATCH"
        
        self.loading.startAnimating()
        
        

        // Do any additional setup after loading the view.
    }
    
    func getMatchings(){
        var json:JSON = JSON("")
        let URL = "https://y40dae48w6.execute-api.ap-northeast-1.amazonaws.com/dev/matchings"
        let parameters = [
            "param": ""] as [String : Any]
        Alamofire.request(URL, method: .get, parameters: parameters)
            .responseJSON { response in
                json = JSON(response.result.value)
                print(json)
                
                DispatchQueue.main.async() {
                    
                }
                
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func goNext(_ sender: Any) {
        let next:ResultViewController = storyboard!.instantiateViewController(withIdentifier: "resultView") as! ResultViewController
        
        next.result = true
        
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
