//
//  APIManager.swift
//  WeatherApp
//
//  Created by Vlad on 6/5/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

enum APIResult<T>{
    case success(T)
    case failure(Error)
}

protocol FinalURL{
    var base: URL { get }
    var path: String { get }
    var reguest: URLRequest { get }
}

protocol APIManager{
    var sessionConfiguration: URLSessionConfiguration { get }
    var session: URLSession { get }
    
    func fetchJSONTast(with request: URLRequest, completionHandler: @escaping ([String: AnyObject]?, HTTPURLResponse?, Error?)->Void) -> URLSessionDataTask
    func fetch<T>(request: URLRequest, parse:@escaping  ([String: AnyObject]) -> [T]?, completionHandler: @escaping ([APIResult<T>]) -> Void)
}

extension APIManager{
    func fetchJSONTast(with request: URLRequest, completionHandler: @escaping ([String: AnyObject]?, HTTPURLResponse?, Error?)->Void) -> URLSessionDataTask{
        let dataTask = session.dataTask(with: request) { (data, responce, error) in
            guard let HTTPResponce = responce as? HTTPURLResponse else{
                completionHandler(nil, nil, error)
                return
            }
            if data == nil{
                if let error = error{
                    completionHandler(nil, HTTPResponce, error)
                }
            }
            switch HTTPResponce.statusCode{
            case 200:
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                    completionHandler(json, HTTPResponce, nil)
                }catch let error as NSError{
                    completionHandler(nil, HTTPResponce, error)
                }
            default:
                break
            }
        }
        return dataTask
    }
    
    func fetch<T>(request: URLRequest, parse:@escaping ([String: AnyObject]) -> [T]?, completionHandler:@escaping ([APIResult<T>]) -> Void){
        let dataTask = fetchJSONTast(with: request) { (json, responce, error) in
            DispatchQueue.main.async {
                
                guard let json = json else{
                    if let error = error{
                        completionHandler([.failure(error)])
                    }
                    return
                }
                if let values = parse(json){
                    var success = [APIResult<T>]()
                    for value in values{
                        success.append(.success(value))
                    }
                    completionHandler(success)
                }else{
                    let error = NSError(domain: "error", code: 100, userInfo: nil)
                    completionHandler([.failure(error)])
                }
            }
            
        }
        dataTask.resume()
    }
}
