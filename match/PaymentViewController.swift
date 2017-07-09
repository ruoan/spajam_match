//
//  PaymentViewController.swift
//  match
//
//  Created by ruoan on 2017/07/08.
//  Copyright © 2017年 Hiroki Tanaka. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

class PaymentViewController: UIViewController {
    
    var result:Bool?
    var pay:Int?
    var total:Int?
    
    var roomid: String?
    var memberid: String?

    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image:UIImage = #imageLiteral(resourceName: "navbar")
        self.navigationItem.titleView = UIImageView(image:image)
        
        self.getPayment()

        // Do any additional setup after loading the view.
    }
    
    func getPayment(){
        
        print(roomid)
        print(memberid)
        
        var json:JSON = JSON("")
        let URL = "https://y40dae48w6.execute-api.ap-northeast-1.amazonaws.com/dev/payments"
        let parameters = [
            "room_id": roomid!,
            "member_id": memberid!] as [String : Any]
        Alamofire.request(URL, method: .get, parameters: parameters)
            .responseJSON { response in
                json = JSON(response.result.value)
                print(json)
                
                self.pay = json["body"]["payment"].intValue
                self.total = json["body"]["amount"].intValue
                
                self.payLabel.text = "¥" + (self.pay?.decimalStr)!
                self.totalLabel.text = "Total: ¥" + (self.total?.decimalStr)!
        }
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
