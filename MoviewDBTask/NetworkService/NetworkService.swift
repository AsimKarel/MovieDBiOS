//
//  NetworkService.swift
//  MoviewDBTask
//
//  Created by Asim Karel on 04/02/19.
//  Copyright © 2019 Asim. All rights reserved.
//

import Foundation
import Alamofire
class NetworkService: NSObject {
    private static var _instance:NetworkService!;
    var headers: HTTPHeaders
    let destination: DownloadRequest.DownloadFileDestination = { _, _ in
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return (documentsURL, [.removePreviousFile, .createIntermediateDirectories])
    }
    
    public override init(){
        headers = [
            "Authorization": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzYTQ4ODJkN2JhN2I5Zjg3N2Q1ZWQwZTY4MGI2N2IwNyIsInN1YiI6IjVjNTg1Y2FiMGUwYTI2MDMxYmNhZjlkYiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.vmP8NM9glZ5hZ6C68FgFY29w1VsSsX53l3b1spoNo0g",
            "Content-Type": "application/json;charset=utf-8",
            "Keep-Alive": "timeout=0, max=0",
            "Connection": "Keep-Alive"
        ]
    }
    
    
    
    public static func sharedInstance() -> NetworkService{
        if(_instance == nil){
            _instance = NetworkService();
        }
        return self._instance;
    }
    
    public func getAPI(route:String, parameters:Parameters,success_callback success: ((APIResponse) -> Void)?, failure_callback failure: ((APIResponse) -> Void)?){
        let routeWithParams = self.buildURLWithParameters(url: route, parameters: parameters)
        
        Alamofire.request(routeWithParams, method:.get, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            let APIresponse:APIResponse = APIResponse();
            APIresponse.statusCode = response.response?.statusCode;
            if response.response?.statusCode == 200{
                //Success
                if response.result.value is String{
                    APIresponse.message = (response.result.value.unsafelyUnwrapped as! String);
                    APIresponse.data = (response.result.value.unsafelyUnwrapped as! String);
                }
                else if response.result.value is Int64{
                    APIresponse.data = response.result.value as! Int64
                }
                else if response.result.value is NSArray{
                    APIresponse.data = response.result.value as! NSArray
                }
                else{
                    APIresponse.data = response.result.value as? NSDictionary
                }
                success!(APIresponse)
            }
            else{
                //Failure
                if response.response?.statusCode == 500{
                    //Internal Server Error
                    if response.result.value is String{
                        APIresponse.data = (response.result.value.unsafelyUnwrapped as! String);
                    }
                    else{
                        APIresponse.data = response.result.value as? NSDictionary;
                    }
                }
                else if response.response?.statusCode == 401{
                    //Unauthorized
                    if response.result.value is String{
                        APIresponse.data = (response.result.value.unsafelyUnwrapped as! String);
                    }
                    else{
                        APIresponse.data = response.result.value as? NSDictionary;
                    }
                }
                else{
                    if response.result.value is String{
                        APIresponse.message = (response.result.value.unsafelyUnwrapped as! String);
                    }
                    else{
                        APIresponse.data = response.result.value as? NSDictionary;
                    }
                }
                failure!(APIresponse)
            }
        }
    }
    
    
    public func downloadImage(name:String, success_callback success: ((APIResponse) -> Void)?, failure_callback failure: ((APIResponse) -> Void)?){
//        let name = params["path"] as! String;
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(name)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        let APIresponse:APIResponse = APIResponse();
        let routeWithParams = self.buildImageURL(name: name).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        Alamofire.download(routeWithParams!, headers: headers, to: destination).responseData { response in
            print(response)
            if response.response?.statusCode == 200{
                //Success
                if response.error == nil, let imagePath = response.destinationURL?.path {
                    APIresponse.image = UIImage(contentsOfFile: imagePath)
                    APIresponse.imagePath = response.destinationURL?.path
                    APIresponse.data = response.result.value!;
                    success!(APIresponse)
                }
            }
            else{
                //Failure
                APIresponse.statusCode = response.response?.statusCode;
                APIresponse.data = response.response
                if response.response?.statusCode == 401{
                    //Unauthorized
                    APIresponse.data = response.result;
                }
                failure!(APIresponse)
            }
        }
    }
    public func buildImageURL(name:String) -> String{
        return "http://image.tmdb.org/t/p/w185/"+name;
    }
    
    public func buildURLWithParameters(url:String, parameters:Parameters) -> String{
        var newUrl = url;
        newUrl = newUrl + "?api_key=3a4882d7ba7b9f877d5ed0e680b67b07"
        if parameters.count>0{
            parameters.forEach { (arg) in
                let (key, value) = arg
                newUrl = newUrl + "&" + key + "=" + (String(describing: value));
            }
        }
        return newUrl;
    }
    
    
    
    
}
