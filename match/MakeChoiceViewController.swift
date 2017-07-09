//
//  MakeChoiceViewController.swift
//  match
//
//  Created by Hiroki Tanaka on 7/9/17.
//  Copyright © 2017 Hiroki Tanaka. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class MakeChoiceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    
    var refreshControl:UIRefreshControl!
    var roomId: String!
    var userId: String!
    var members: Array<Dictionary<String, String>> = []
    var order: Array<IndexPath>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableview.delegate = self
        self.tableview.dataSource = self
        // Do any additional setup after loading the view.
        self.order = []
        
        let image:UIImage = #imageLiteral(resourceName: "navbar")
        self.navigationItem.titleView = UIImageView(image:image)
        self.navigationItem.hidesBackButton = true

    }
    
    @IBAction func postChoicePressed(_ sender: Any) {
        if (self.members.count == self.order.count) {
          postChoices()
        } else {
          self.displayErrorAlert(message:"すべてのメンバーに順位をつけてください。")
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        SVProgressHUD.show()
        getMembers()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "更新")
        self.refreshControl.addTarget(self, action: Selector("refresh"), for: UIControlEvents.valueChanged)
        self.tableview.addSubview(refreshControl)
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

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.members)
        return self.members.count;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let member = members[indexPath.row]
        
        if let url = NSURL(string: member["image_url"]!) as URL? {
            
            do {
              let imageData :NSData = try NSData(contentsOf: url)
              let img = UIImage(data:imageData as Data);
              let img_profile = cell.viewWithTag(1) as! UIImageView
              img_profile.image = img

            } catch {
                self.displayErrorAlert(message:"メンバーの画像の取得に失敗しました。")
            }
        }
        
        let lbl_firstname = cell.viewWithTag(3) as! UILabel
        lbl_firstname.text = member["name"]
        
        let img_cover = cell.viewWithTag(6) as! UIImageView
        if (member["gender"] == "woman") {
          img_cover.image = UIImage(named: "Cover_Pink")
        } else {
          img_cover.image = UIImage(named: "Cover_Blue")
        }
        
        let img_medal = cell.viewWithTag(4) as! UIImageView
        let lbl_medal = cell.viewWithTag(5) as! UILabel
        img_medal.isHidden = true
        lbl_medal.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        
        
        let img_medal = cell.viewWithTag(4) as! UIImageView
        let lbl_medal = cell.viewWithTag(5) as! UILabel

        
        if let ip = self.order.last {
            
            // 2位以降を選ぶ
            if (ip.row == indexPath.row) {
                //最後尾のやつの選択を解除
                
                self.order.popLast()
                
                img_medal.isHidden = true
                lbl_medal.isHidden = true
            } else {
                if self.order.filter({ (filterIP) -> Bool in
                    return filterIP.row == indexPath.row
                }).count == 0 {
                    self.order.append(indexPath)
                    lbl_medal.text = String(self.order.count)
                    
                    if (self.order.count == 2) {
                        img_medal.image = UIImage(named: "Silver")
                    } else {
                        img_medal.image = UIImage(named: "Bronze")
                    }
                    img_medal.isHidden = false
                    lbl_medal.isHidden = false
                }
                
                
                
                
            }
        } else {
            
            // 一番最初の1位を選ぶ
           self.order.append(indexPath)
            lbl_medal.text = "1"
            img_medal.image = UIImage(named: "Gold")
            img_medal.isHidden = false
            lbl_medal.isHidden = false
        }
        
        
    }
    
    
    
    
    func getMembers(){
        
        
        var json:JSON = JSON("")
        let URL = "https://y40dae48w6.execute-api.ap-northeast-1.amazonaws.com/dev/members?room_id=\(self.roomId!)&member_id=\(self.userId!)"
        Alamofire.request(URL, method: .get)
            .responseJSON { response in
                json = JSON(response.result.value)
                print(json)
                
                
                if (json["status"] == 200) {
                    
                    self.members.removeAll()
                    print(self.members)

                    let members =  json["body"]["members"].arrayValue
                    for member in members {
                        let m = [
                        "gender": member["gender"].string,
                        "member_id" : member["member_id"].string,
                        "image_url" : member["image_url"].string,
                        "name" : member["name"].string,
                        ]
                        self.members.append(m as! [String : String])
                    }

                    print(self.members)
                    self.tableview.reloadData()
                } else {
                    self.displayErrorAlert(message:"メンバーの取得に失敗しました。")
                }
                DispatchQueue.main.async() {
                    SVProgressHUD.dismiss()
                    self.refreshControl.endRefreshing()

                }
                
        }
    }
    
    
    func postChoices(){
        SVProgressHUD.show()
        
        var memberRanking: [String] = []
        for (index, indexPath) in order.enumerated() {
            //memberRanking[String(index)] = self.members[indexPath.row]["member_id"]!
            memberRanking.append(self.members[indexPath.row]["member_id"]!)
        }
        
        
        var json:JSON = JSON("")
        let url = "https://y40dae48w6.execute-api.ap-northeast-1.amazonaws.com/dev/choices"
        let params = [
            "room_id": self.roomId,
            "member_id": self.userId,
            "choices": memberRanking,
            ] as [String : Any]


        
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                json = JSON(response.result.value)
                print(json)
                
                
                if (json["status"] == 200) {
                    self.showNextView()
                    
                } else {
                    self.displayErrorAlert(message:"投票に失敗しました。")
                }
                DispatchQueue.main.async() {
                    SVProgressHUD.dismiss()
                    
                }
                
        }


    }
    
    
    
    func displayErrorAlert(message:String)
    {
        let alertController = UIAlertController(title: "エラー！", message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil)
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func refresh()
    {
        getMembers()
    }
    
    func showNextView(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
        if let targetView = storyboard.instantiateInitialViewController() as? WaitingViewController {

            targetView.roomid = roomId
            targetView.memberid = userId

           self.navigationController?.pushViewController(targetView, animated: true)
        }
        
    }
    
    func resetView(){
       getMembers()
    }
}
