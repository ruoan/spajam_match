//
//  EnterRoomViewController.swift
//  match
//
//  Created by Hiroki Tanaka on 7/8/17.
//  Copyright © 2017 Hiroki Tanaka. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AWSS3
import Photos
import SVProgressHUD


class EnterRoomViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var txt_roomId: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    
    @IBAction func selectImage(_ sender: Any) {
        let alertController = UIAlertController(title: "画像を選択", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラを起動", style: .default) { (UIAlertAction) -> Void in
            self.selectFromCamera()
        }
        let libraryAction = UIAlertAction(title: "カメラロールから選択", style: .default) { (UIAlertAction) -> Void in
            self.selectFromLibrary()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    private func selectFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラ許可をしていない時の処理")
        }
    }
    
    private func selectFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラロール許可をしていない時の処理")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        selectedImageUrl = nil;
        localIdentifier = nil;
        
        if let imageUrl = info[UIImagePickerControllerReferenceURL] as? NSURL {
            selectedImageUrl = imageUrl
            myImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            myImageView.backgroundColor = UIColor.clear
            myImageView.contentMode = UIViewContentMode.scaleAspectFit
            
            startUploadingImage()
        } else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            myImageView.image = image
            myImageView.backgroundColor = UIColor.clear
            myImageView.contentMode = UIViewContentMode.scaleAspectFit
            
            var imageAssetPlaceholder:PHObjectPlaceholder!
            PHPhotoLibrary.shared().performChanges({
                
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                imageAssetPlaceholder = request.placeholderForCreatedAsset
            }, completionHandler: { success, error in
                if success {
                    // Saved successfully!
                    print("success")
                    self.localIdentifier = imageAssetPlaceholder.localIdentifier
                    /*
                     let assetID =
                     localID.replacingOccurrences(
                     of: "/.*", with: "",
                     options: NSString.CompareOptions.regularExpression, range: nil)
                     print(assetID)
                     self.selectedImageUrl = NSURL(fileURLWithPath: "assets-library://asset/asset.JPG?id=" + assetID + "&ext=JPG")
                     */
                    
                    self.startUploadingImage()
                }
                else if let error = error {
                    // Save photo failed with error
                    print(error)
                }
                else {
                    // Save photo failed with no error
                }
            })
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    var showImagePickerButton: UIButton!
    var myImageView: UIImageView!
    var selectedImageUrl: NSURL?
    var localIdentifier:String?
    var myActivityIndicator: UIActivityIndicatorView!
    
    func startUploadingImage()
    {
        var localFileName:String?
        if let imageToUploadUrl = selectedImageUrl {
            let phResult = PHAsset.fetchAssets(withALAssetURLs: [imageToUploadUrl as URL], options: nil)
            localFileName = phResult.firstObject!.originalFilename
        } else if let localId = localIdentifier {
            let phResult = PHAsset.fetchAssets(withLocalIdentifiers: [localId], options: nil)
            localFileName = phResult.firstObject!.originalFilename
        }
        
        
        
        if localFileName == nil
        {
            print("5")
            return
        }
        
        SVProgressHUD.show()
        
        
        // Configure AWS Cognito Credentials
        let myIdentityPoolId = "ap-northeast-1:544001e3-88dd-4502-8b07-221141f313c4"
        
        let credentialsProvider:AWSCognitoCredentialsProvider = AWSCognitoCredentialsProvider(regionType:AWSRegionType.APNortheast1, identityPoolId: myIdentityPoolId)
        
        
        
        let configuration = AWSServiceConfiguration(region:AWSRegionType.APNortheast1, credentialsProvider:credentialsProvider)
        
        
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        
        // Set up AWS Transfer Manager Request
        let S3BucketName = "face.match.spajam"
        
        let remoteName = localFileName!
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()!
        
        uploadRequest.body = generateImageUrl(fileName: remoteName) as URL
        uploadRequest.key = remoteName
        uploadRequest.bucket = S3BucketName
        uploadRequest.contentType = "image/jpeg"
        
        print(remoteName)
        
        let transferManager = AWSS3TransferManager.default()
        // Perform file upload
        
        transferManager.upload(uploadRequest).continueWith { (task) -> AnyObject! in
            
            
            if let error = task.error {
                print("Upload failed with error: (\(error.localizedDescription))")
            }
            
            if task.result != nil {
                
                let s3URL = NSURL(string: "https://s3.amazonaws.com/\(S3BucketName)/\(uploadRequest.key!)")!
                print("Uploaded to:\n\(s3URL)")
                // Remove locally stored file
                self.removeImageWithUrl(fileName: uploadRequest.key!)
                
                
                if let roomId = self.txt_roomId.text {
                  self.loginWithFaceRecognition(roomId: roomId, url: "https://s3.amazonaws.com/\(S3BucketName)/\(uploadRequest.key!)");
                } else {
                    self.displayErrorAlert(message:"ルーム No. を入力してください。")

                }
                
            } else {
                print("Unexpected empty result.")
            }
            return nil
        }
        
    }
    
    
    func generateImageUrl(fileName: String) -> NSURL
    {
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory().appending(fileName))
        let data = UIImageJPEGRepresentation(myImageView.image!, 0.6)
        do {
            try data!.write(to: fileURL as URL, options: .atomic)
        } catch {
            print(error)
        }
        return fileURL
    }
    
    func removeImageWithUrl(fileName: String)
    {
        let fileURL = NSURL(fileURLWithPath: NSTemporaryDirectory().appending(fileName))
        do {
            try FileManager.default.removeItem(at: fileURL as URL)
        } catch
        {
            print(error)
        }
    }

    func loginWithFaceRecognition(roomId: String, url: String){
        var json:JSON = JSON("")
        let URL = "https://y40dae48w6.execute-api.ap-northeast-1.amazonaws.com/dev/login"
        let parameters = [
            "roomId": roomId,
            "url": url
            ] as [String : Any]
        Alamofire.request(URL, method: .get, parameters: parameters)
            .responseJSON { response in
                json = JSON(response.result.value)
                print(json)
                
                DispatchQueue.main.async() {
                    SVProgressHUD.dismiss()
                    
                    //__self.myActivityIndicator.stopAnimating()
                    //self.displayAlertMessage(message: "\(menu) は \(calorie) kcal でした。")
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

}
