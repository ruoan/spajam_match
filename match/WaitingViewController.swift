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

    @IBOutlet weak var imageView: UIImageView!
    
    var roomid:String!
    var memberid:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image:UIImage = #imageLiteral(resourceName: "navbar")
        self.navigationItem.titleView = UIImageView(image:image)
        self.navigationItem.hidesBackButton = true
        
        self.loading.startAnimating()
        
        self.getMatchings()
        
        //Thread.sleep(forTimeInterval: 5.0)
        
        //let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        
        // ブラーエフェクトからエフェクトビューを生成
        //var visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        // エフェクトビューのサイズを指定（オリジナル画像と同じサイズにする）
        //visualEffectView.frame = self.imageView.bounds
        
        // 画像にエフェクトビューを貼り付ける
        //self.imageView.addSubview(visualEffectView)
        

        // Do any additional setup after loading the view.
    }
    
    func getMatchings(){
        var json:JSON = JSON("")
        let URL = "https://y40dae48w6.execute-api.ap-northeast-1.amazonaws.com/dev/matchings"
        let parameters = [
            "room_id": roomid,
            "member_id": memberid] as [String : Any]
        Alamofire.request(URL, method: .get, parameters: parameters)
            .responseJSON { response in
                json = JSON(response.result.value)
                print(json)
                
                if (json["status"] == 200) {
                    if json["body"]["text"] == "finished"{
                        
                        var result = true
                        if json["body"]["text"] == "unmatched" {
                            result = false
                        }
                        //self.goNextFunc(result: result)
                        self.showNextView(result: result,
                                          memberId: json["body"]["result"]["member_id"].string!,
                                          image_url: json["body"]["result"]["image_url"].string!,
                                          name: json["body"]["result"]["name"].string!)
                        
                    } else {
                        self.getMatchings()
                    }
                } else {
                    self.displayErrorAlert(message:"マッチングの取得に失敗しました。")
                }
                
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func goNext(_ sender: Any) {
        self.goNextFunc(result:true)
    }
    func goNextFunc(result: Bool){
        let next:ResultViewController = storyboard!.instantiateViewController(withIdentifier: "resultView") as! ResultViewController
        
        next.result = result
        next.memberid = memberid
        next.roomid = roomid
        
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
    
    func showNextView(result:Bool, memberId: String, image_url:String, name:String){
        
        let next:ResultViewController = storyboard!.instantiateViewController(withIdentifier: "resultView") as! ResultViewController
        
        next.result = result
        next.memberid = memberId
        next.roomid = roomid
        next.image_url = image_url
        next.name = name
        
        self.navigationController?.pushViewController(next, animated:true)
    }

}
