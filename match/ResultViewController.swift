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
    
    @IBOutlet weak var faceImage: UIImageView!
    
    
    var result: Bool?
    var roomid:String?
    var memberid:String?
    
    var match: String = "https://s3-us-west-2.amazonaws.com/face.match.spajam2017/member001_regist.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image:UIImage = #imageLiteral(resourceName: "navbar")
        self.navigationItem.titleView = UIImageView(image:image)
        
        
        if(self.result)!{
            self.resultLabel.text = "成功!"
            
            let url = NSURL(string: match)
            var imageData = NSData(contentsOf: url as! URL)
            var img = UIImage(data:imageData as! Data);
            
            self.faceImage.image = img
            
        } else {
            self.resultLabel.text = "残念;;"
            
            self.faceImage.image = #imageLiteral(resourceName: "cover_img_03")
            
        }
        
        
        self.faceImage.layer.cornerRadius = self.faceImage.frame.size.width * CGFloat(0.5)
        self.faceImage.clipsToBounds = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goNext(_ sender: Any) {
        let next:PaymentViewController = storyboard!.instantiateViewController(withIdentifier: "paymentView") as! PaymentViewController
        
        next.result = self.result
        next.roomid = self.roomid
        next.memberid = self.memberid
        
        
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
