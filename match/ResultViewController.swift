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
    
    @IBOutlet weak var imageBlur: UIImageView!
    
    var result: Bool?
    var roomid:String?
    var memberid:String?
    var image_url:String!
    var name:String!
    
    //var match: String = "https://s3-us-west-2.amazonaws.com/face.match.spajam2017/member001_regist.jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image:UIImage = #imageLiteral(resourceName: "navbar")
        self.navigationItem.titleView = UIImageView(image:image)
        self.navigationItem.hidesBackButton = true
        
        if self.result! {
            self.resultLabel.text = "成立"
            
            if let url = NSURL(string: self.image_url) as URL? {
                
                do {
                    let imageData :NSData = try NSData(contentsOf: url)
                    let img = UIImage(data:imageData as Data);
                    self.faceImage.image = img
                    
                    
                    
                    let currentFilter = CIFilter(name: "CIGaussianBlur")
                    let beginImage = CIImage(image: img!)
                    currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
                    currentFilter!.setValue(10, forKey: kCIInputRadiusKey)
                    
                    let cropFilter = CIFilter(name: "CICrop")
                    cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
                    cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
                    
                    let output = cropFilter!.outputImage
                    let cgimg = context.createCGImage(output!, from: output!.extent)
                    let processedImage = UIImage(cgImage: cgimg!)

                    imageBlur.image = processedImage
                    
                } catch {
                    self.displayErrorAlert(message:"メンバーの画像の取得に失敗しました。")
                }
            }
        
            
            
            
        } else {
            self.resultLabel.text = "不成立"
            
            self.faceImage.image = #imageLiteral(resourceName: "cover_img_03")
            
        }
        
        
        self.faceImage.layer.cornerRadius = self.faceImage.frame.size.width * CGFloat(0.5)
        self.faceImage.clipsToBounds = true

        // Do any additional setup after loading the view.
    }

    
    var context = CIContext(options: nil)
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goNext(_ sender: Any) {
        let next:PaymentViewController = storyboard!.instantiateViewController(withIdentifier: "paymentView") as! PaymentViewController
        
        next.result = self.result
        next.roomid = self.roomid
        next.memberid = self.memberid
        
        
        //let navi = UINavigationController(rootViewController: next)
        
        //self.present(navi,animated: true, completion: nil)
        
        self.navigationController?.pushViewController(next, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func displayErrorAlert(message:String)
    {
        let alertController = UIAlertController(title: "エラー！", message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil)
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
}
