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
    
    var roomid:String?
    var memberid:String?
    var match:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "MATCH"
        
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
            "room_id": "spajam2017_2",
            "member_id": "member001"] as [String : Any]
        Alamofire.request(URL, method: .get, parameters: parameters)
            .responseJSON { response in
                json = JSON(response.result.value)
                print(json)
                
                //if; json["body"]["text"] == "finished"{
                    self.goNextFunc()
                //} else {
                //    self.getMatchings()
                //}
                
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func goNext(_ sender: Any) {
        self.goNextFunc()
    }
    func goNextFunc(){
        let next:ResultViewController = storyboard!.instantiateViewController(withIdentifier: "resultView") as! ResultViewController
        
        next.result = false
        
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
