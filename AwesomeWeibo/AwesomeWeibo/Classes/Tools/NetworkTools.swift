//
//  NetworkTools.swift
//  AFNetwork封装
//
//  Created by Jia Liu on 8/4/16.
//  Copyright © 2016 Jia Liu. All rights reserved.
//

import AFNetworking

enum RequestType {
    case GET
    case POST
}

class NetworkTools: AFHTTPSessionManager {
    
    //单例 Singleton
    //let is thread safe
    static let shareInstance: NetworkTools = {
        let tools = NetworkTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return tools
    }()
    
}

//MARK:- request methods
extension NetworkTools {
    func request(requestType: RequestType, urlString: String, parameters: [String: AnyObject], finished: (result: AnyObject?, error: NSError?) -> ()) {
        
        //callbacks
        let successCallBack = { (task: NSURLSessionDataTask, result: AnyObject?) -> Void in
            finished(result: result, error: nil)
        }
        
        let failureCallBack = { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            finished(result: nil, error: error)
        }
        
        
        if requestType == .GET {
            GET(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        } else {
            POST(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
    }
}

//MARK:- request access_token
extension NetworkTools {
    func getAccessToken(code: String, finished: (result: [String: AnyObject]?, error: NSError?) -> ()) {
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let parameters = ["client_id": App_Key,
                          "client_secret": App_Secret,
                          "grant_type": "authorization_code",
                          "code": code,
                          "redirect_uri": Redirect_URL]
        request(.POST, urlString: urlString, parameters: parameters) { (result, error) in
            finished(result: result as? [String: AnyObject], error: error)
        }
    }
}

//MARK:- request user info
extension NetworkTools {
    func loadUserInfo(access_token: String, uid: String, finished: (result: [String: AnyObject]?, error: NSError?) -> ()) {
        let urlString = "https://api.weibo.com/2/users/show.json"
        
        let parameters = ["access_token": access_token,
                          "uid": uid]
        
        request(.GET, urlString: urlString, parameters: parameters) { (result, error) in
            finished(result: result as? [String: AnyObject], error: error)
        }
    }
}

//MARK:- request home page info
//[[String: AnyObject]] means an array of dicts
extension NetworkTools {
    func loadStatuses(since_id: Int, max_id: Int, access_token: String, finished: (result: [[String: AnyObject]]?, error: NSError?) -> ()) {
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        let parameters = ["access_token": access_token, "since_id": "\(since_id)", "max_id": "\(max_id)"]
        
        request(.GET, urlString: urlString, parameters: parameters) { (result, error) in
            guard let statusDict = (result as? [String: AnyObject]) else {
                finished(result: nil, error: error)
                return
            }
            
            finished(result: statusDict["statuses"] as? [[String: AnyObject]], error: error)
        }
    }
}

//MARK:- sending weibo
extension NetworkTools {
    func sendStatus(access_token: String, statusText: String, isSucess: (isSucess: Bool) -> ()) {
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        let parameters = ["access_token": access_token, "status": statusText]
        
        request(.POST, urlString: urlString, parameters: parameters) { (result, error) in
            if result != nil {
                isSucess(isSucess: true)
            } else {
                print(error)
                isSucess(isSucess: false)
            }
        }
    }
}

//MARK:- sending weibo with pics
extension NetworkTools {
    func sendStatus(access_token: String, statusText: String, image: UIImage, isSucess: (isSucess: Bool) -> ()) {
        let urlString = "https://api.weibo.com/2/statuses/upload.json"
        let parameters = ["access_token": access_token, "status": statusText]
        
        POST(urlString, parameters: parameters, constructingBodyWithBlock: { (fromData) in
            if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                fromData.appendPartWithFileData(imageData, name: "pic", fileName: "1.png", mimeType: "image/png")
            }
            }, success: { (_, _) in
                isSucess(isSucess: true)
            }) { (_, error) in
                print(error)
                isSucess(isSucess: false)
        }
    }
}
