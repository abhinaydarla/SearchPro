//
//  ApiClient.swift
//
//  Created by Abhi on 5/15/17.
//  Copyright © 2017 Abhi. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class APIClient: NSObject,NSURLConnectionDataDelegate {
    

    class var sharedInstance : APIClient {
        
        struct Static {
            static let instance : APIClient = APIClient()
        }
        return Static.instance
    }
    
    var mbProgress = MBProgressHUD()
    
    let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
    let sessionManager : AFHTTPSessionManager = AFHTTPSessionManager()
    let JSONResponse : AFJSONResponseSerializer = AFJSONResponseSerializer()
    var responseData : NSMutableData!
    
    func MakeAPICallWithEndURl(_ url: NSString!, parameters: NSDictionary!, completionHandler:@escaping (NSDictionary?, NSError?)->()) ->() {
        
            manager.responseSerializer = JSONResponse
            manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let isNetworkAvailables = APIClient.isNetworkAvailable() 
        
        if isNetworkAvailables {
            manager.post(url as String, parameters: parameters, constructingBodyWith: { (formData: AFMultipartFormData!) -> Void in
                
            }, success: { (operation: AFHTTPRequestOperation!, responseData: Any!) -> Void in
                var responseDict : NSDictionary!
                
                if((responseData as AnyObject).count > 0){
                    responseDict = responseData as! NSDictionary
                }
                completionHandler(responseDict,nil)
            }, failure: { (operation,error : Error) -> Void in
                completionHandler(nil, error as NSError?)
            })
        }
        else {
            
        }
        
    }
    
    func postImageToServer(_ url: NSString, image: UIImage!, parameters: NSDictionary!, completionHandler:@escaping (NSDictionary?, NSError?)->())->(){
        
        print("Requesting \( url)")
        print("Parameters: \(parameters)")
        
        //let parameters = ["primary":primary]
        let compression = 1.0
          let imageData  = UIImagePNGRepresentation(image)
//        let imageData = UIImageJPEGRepresentation(image, CGFloat(compression))
        
        if (imageData != nil)
        {
            manager.post(url as String, parameters: parameters, constructingBodyWith: { (formData: AFMultipartFormData!) -> Void in
                formData.appendPart(withFileData: imageData!, name: "file", fileName: "photo.jpg", mimeType: "image/jpeg")
                }, success: { (operation :AFHTTPRequestOperation, responseData : Any!) -> Void in
                    var responseDict : NSDictionary!
                    if((responseData as AnyObject).count > 0) {
                        
                        responseDict = responseData as! NSDictionary
                        print(responseDict)
                        completionHandler(responseDict,nil)
                        
                    }
                },
                   failure: { (operation, error : Error) -> Void in
                    completionHandler(nil, error as NSError?)
            })
        }
        
    }
    
    class func isNetworkAvailable() -> Bool
    {
        do {
            let reachability = Reachability.init()
            let networkStatus: Int = reachability!.currentReachabilityStatus.hashValue
            return networkStatus != 0
            
        }catch ReachabilityError.FailedToCreateWithAddress(let address) {
            print("can not open \(address)")
            return false
        } catch {}
        return false
    }
    
    func showProgress(inView : UIView) {
        //var mbProgress = MBProgressHUD()
        
        mbProgress = MBProgressHUD.showAdded(to: inView, animated: true)
        mbProgress.label.text = "FILTERING"
        mbProgress.detailsLabel.text = "2-3 seconds"
        mbProgress.show(animated: true)
    }
    
    func showProgressForPeocess(inView : UIView) {
        //var mbProgress = MBProgressHUD()
    
        
//        mbProgress = MBProgressHUD.init(frame: CGRect(x: mbProgress.frame.origin.x, y: mbProgress.frame.origin.y, width: mbProgress.frame.size.width + 20, height: mbProgress.frame.size.height))
        
        mbProgress = MBProgressHUD.showAdded(to: inView, animated: true)
        mbProgress.label.text = "SAVING"
//        mbProgress.detailsLabel.text = "20-30 seconds"
        mbProgress.show(animated: true)
    }
    
    func hideProgress() {
        mbProgress.hide(animated: true)
    }
    
}
