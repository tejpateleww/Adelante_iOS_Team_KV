//
//  WebServices.swift
//  Virtuwoof Pet
//
//  Created by EWW80 on 01/11/19.
//  Copyright © 2019 EWW80. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit


typealias  PassProgressValue = (CGFloat)->()
typealias CompletionResponse = (JSON,Bool,Any) -> ()

class WebService{
    
    static let shared = WebService()
    
    private init() {}
    
    
    //-------------------------------------
    // MARK:- Method for Get, post..
    //-------------------------------------
    func requestMethod(api: ApiKey, httpMethod:Method, showHud : Bool = false,parameters: Any, completion: @escaping CompletionResponse){
        guard isConnected else { completion(JSON(), false, "Something went wrong"); return }
        
        var parameterString = "" // "/"
        if httpMethod == .get{
            if let param = parameters as? [String:Any]{
                let dictData = param as! [String:String]
                for value in dictData.values {
                    parameterString += String(value) //+ "/"
                }
            }
        }
        else { parameterString = "" }
        #warning("Please remove make payment api user when complete")
        guard let url = (api == .make_payment) ? URL(string: "http://3.239.174.164/api/User/" + api.rawValue + parameterString) : URL(string: APIEnvironment.baseURL + api.rawValue + parameterString) else {
            completion(JSON(),false, "")
            return
        }
        
        
        
        print("the url is \(url) and the parameters are \n \(parameters) and the headers are \(APIEnvironment.headers)")
        
        let method = Alamofire.HTTPMethod.init(rawValue: httpMethod.rawValue)
        
        var params = parameters
        
        if(method == .get)
        {
            params = [:]
        }
        
        if(showHud)
        {
            Utilities.showHud()
        }
        
        AF.request(url, method: method, parameters: params as? [String : Any], encoding: URLEncoding.httpBody, headers: APIEnvironment.headers).validate()
            .responseJSON { (response) in
                // LoaderClass.hideActivityIndicator()
                if(showHud)
                {
                    Utilities.hideHud()
                }
                print("The webservice call is for \(url) and the params are \n \(JSON(parameters))")
                
                if let json = response.value{
                    let resJson = JSON(json)
                    print("the response is \n \(resJson)")
                    let status = resJson["status"].boolValue
                    completion(resJson, status, json)
                }
                else {
                    //  LoaderClass.hideActivityIndicator()
                    if let error = response.error {
                        print("Error = \(error.localizedDescription)")
                        if error.localizedDescription == "Response status code was unacceptable: 403."{
                            Utilities.showAlertWithTitleFromWindow(title: AppName, andMessage: GlobalStrings.EndSession_Logout.rawValue, buttons: ["ok"]) { _ in
                                appDel.SetLogout()
                            }
                        }
                        else{
                            //                            utility.ShowAlert(OfMessage: error.localizedDescription)
                        }
                        completion(JSON(), false, error.localizedDescription)
                        
                    }
                }
            }
    }
    func getMethod(url: URL, httpMethod:Method, completion: @escaping CompletionResponse)
    {
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: APIEnvironment.headers)
            .validate()
            .responseJSON { (response) in
                // LoaderClass.hideActivityIndicator()
                var headers = APIEnvironment.headers
                print("The webservice call is for \(url) and the headers are \(headers)")
                if let json = response.value{
                    let resJson = JSON(json)
                    print("the response is \(resJson)")
                    
                    if "\(url)".contains("geocode/json?latlng=") {
                        let status = resJson["status"].stringValue.lowercased() == "ok"
                        completion(resJson, status, json)
                    }
                    else {
                        let status = resJson["status"].boolValue
                        completion(resJson, status,json)
                    }
                }
                else {
                    //  LoaderClass.hideActivityIndicator()
                    if let error = response.error {
                        print("Error = \(error.localizedDescription)")
                        if error.localizedDescription == "Response status code was unacceptable: 403."{
                            Utilities.showAlertWithTitleFromWindow(title: AppName, andMessage: GlobalStrings.EndSession_Logout.rawValue, buttons: ["ok"]) { _ in
                                appDel.SetLogout()
                            }
                        }
                        else{
                            //                            utility.ShowAlert(OfMessage: error.localizedDescription)
                        }
                        completion(JSON(), false,error.localizedDescription)
                        
                    }
                }
            }
    }
    func getMethod(api: ApiKey,parameterString:String, httpMethod:Method,showHud : Bool = false, completion: @escaping CompletionResponse)
    {
        guard isConnected else { completion(JSON(), false, "Something went wrong"); return }
        
        guard let url = URL(string: APIEnvironment.baseURL + api.rawValue + parameterString) else {
            completion(JSON(),false, "")
            return
        }
        
        
        var headers = APIEnvironment.headers
        
        if(api == .Init)
        {
            headers = [AppInfo.appHeaderKey: AppInfo.appStaticHeader]
        }
        
        print("the url is \(url) and the parameters are \n \(parameterString) and the headers are \(headers)")
        if(showHud)
        {
            Utilities.showHud()
        }
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: headers)
            .validate()
            .responseJSON { (response) in
                if(showHud)
                {
                    Utilities.hideHud()
                }
                if let json = response.value{
                    let resJson = JSON(json)
                    print("the response is \(resJson)")
                    
                    if "\(url)".contains("geocode/json?latlng=") {
                        let status = resJson["status"].stringValue.lowercased() == "ok"
                        completion(resJson, status, json)
                    }
                    else {
                        let status = resJson["status"].boolValue
                        completion(resJson, status,json)
                    }
                }
                else {
                    if let error = response.error {
                        print("Error = \(error.localizedDescription)")
                        if error.localizedDescription == "Response status code was unacceptable: 403."{
                            Utilities.showAlertWithTitleFromWindow(title: AppName, andMessage: GlobalStrings.EndSession_Logout.rawValue, buttons: ["ok"]) { _ in
                                appDel.SetLogout()
                            }
                        }
                        else{
                            // utility.ShowAlert(OfMessage: error.localizedDescription)
                        }
                        completion(JSON(), false,error.localizedDescription)
                        
                    }
                }
            }
    }
    
    //-------------------------------------
    // MARK:- Multiform Data
    //-------------------------------------
    
    
    func upload(image: Data, to url: Alamofire.URLRequestConvertible, params: [String: Any]) {
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in params {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            multiPart.append(image, withName: "file", fileName: "file.png", mimeType: "image/png")
        }, with: url)
        .uploadProgress(queue: .main, closure: { progress in
            //Current upload progress of file
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseJSON(completionHandler: { data in
            //Do what ever you want to do with response
        })
    }
    
    
    //    var download : AF.request?
    
    
    
    
    func postDataWithImage(api: ApiKey, isRemoveimage: Bool, showHud : Bool, parameter dictParams: [String: Any], image: UIImage?, imageParamName: String, completion: @escaping CompletionResponse) {
        
        guard isConnected else { completion(JSON(), false, "Something went wrong"); return }
        guard let url = URL(string: APIEnvironment.baseURL + api.rawValue) else { return }
        //        let request = URLRequest(url: url)
        print("the url is \(url) and the parameters are \n \(dictParams) and the headers are \(APIEnvironment.headers)")
        
        if isRemoveimage {
            
        }
        if(showHud)
        {
            Utilities.showHud()
        }
        
        AF.upload(multipartFormData: { (multiPart) in
            for (key, value) in dictParams {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                        if let num = element as? Int {
                            let value = "\(num)"
                            multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            let imageData = image?.jpegData(compressionQuality: 0.7)
            if !isRemoveimage {
                multiPart.append(imageData ?? Data(), withName: imageParamName, fileName: "\(imageParamName).jpeg", mimeType: "image/jpeg")
            }
            
        }, to: url, usingThreshold: UInt64.init(), method: .post, headers: APIEnvironment.headers, interceptor: .none, fileManager: .default)
        .responseJSON { (response) in
            
            if(showHud){
                Utilities.hideHud()
            }
            
            //Do what ever you want to do with response
            if let json = response.value{
                let resJson = JSON(json)
                
                print("the response is \(resJson)")
                
                let status = resJson["status"].boolValue
                completion(resJson, status,json)
            }
            else {
                //  LoaderClass.hideActivityIndicator()
                if let error = response.error {
                    print("Error = \(error.localizedDescription)")
                    if error.localizedDescription == "Response status code was unacceptable: 403."{
                        Utilities.showAlertWithTitleFromWindow(title: AppName, andMessage: GlobalStrings.EndSession_Logout.rawValue, buttons: ["ok"]) { _ in
                            appDel.SetLogout()
                        }
                        
                    }
                    else{
                        //                            utility.ShowAlert(OfMessage: error.localizedDescription)
                    }
                    completion(JSON(), false,error.localizedDescription)
                }
            }
            
        }.uploadProgress(queue: .main) { (progress) in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
    }
    
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
    
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any]
    }
}



extension WebService{
    var isConnected : Bool{
        guard isConnectedToInternet() else {
            //            AlertMessage.showMessageForError("Please connect to internet")
            //utility.ShowAlert(OfMessage: "kjhdfjkhd")
            //  LoaderClass.hideActivityIndicator()
            return false
        }
        return true
    }
    func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class ProgressBarView: UIView {
    var bgPath: UIBezierPath!
    var shapeLayer: CAShapeLayer!
    var progressLayer: CAShapeLayer!
    
    
    
    
    private func createCirclePath() {
        let x = self.frame.width/2
        let y = self.frame.height/2
        let center = CGPoint(x: x, y: y)
        bgPath.addArc(withCenter: center, radius: x/CGFloat(2), startAngle: CGFloat(0), endAngle: CGFloat(6.28), clockwise: true)
        bgPath.close()
    }
    
    func simpleShape() {
        createCirclePath()
        shapeLayer = CAShapeLayer()
        shapeLayer.path = bgPath.cgPath
        shapeLayer.lineWidth = 15
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        
        progressLayer = CAShapeLayer()
        progressLayer.path = bgPath.cgPath
        progressLayer.lineWidth = 15
        progressLayer.lineCap = CAShapeLayerLineCap.round
        progressLayer.fillColor = nil
        progressLayer.strokeColor = UIColor.red.cgColor
        progressLayer.strokeEnd = 0.0
        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(progressLayer)
    }
    
    var progress : CGFloat = 0 {
        willSet(newValue)
        {
            progressLayer.strokeEnd = CGFloat(newValue)
        }
    }
    
    
    
}
