//
//  Client.swift
//  GuessMyBreed
//
//  Created by Huong Tran on 6/5/20.
//  Copyright © 2020 RiRiStudio. All rights reserved.
//

import Foundation
import UIKit

class Client {
    enum Endpoint {
        case randomImageFromAllDogsCollection
        case randomImageForBreed(String)
        case listAllBreeds
//
        var url: URL {
            return URL(string: self.stringValue)!
        }
        var stringValue: String {
            switch self {
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .randomImageFromAllDogsCollection:
                return "https://dog.ceo/api/breeds/image/random"
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
    }
    
    class func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let imageDownloadTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                    return
            }
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage, nil)
        }
        imageDownloadTask.resume()
    }
    
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogResponse?, Error?) -> Void) {
        let randomImageEndpoint = Client.Endpoint.randomImageForBreed(breed).url
        let imageURLTask = URLSession.shared.dataTask(with: randomImageEndpoint) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            let imageData = try! decoder.decode(DogResponse.self, from: data)
            print(imageData)
            completionHandler(imageData, nil)
        }
        imageURLTask.resume()
    }
    
    class func requestAnyRandomImage(completionHandler: @escaping (DogResponse?, Error?) -> Void) {
        let randomImageEndpoint = Client.Endpoint.randomImageFromAllDogsCollection.url
        let imageURLTask = URLSession.shared.dataTask(with: randomImageEndpoint) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            let imageData = try! decoder.decode(DogResponse.self, from: data)
            print(imageData)
            completionHandler(imageData, nil)
        }
        imageURLTask.resume()
    }
    
    
    class func requestBreedsList(completionHandler: @escaping ([String]?, Error?)-> Void) {
        let breedsListEndPoint = Client.Endpoint.listAllBreeds.url
        let breedsListURLTask = URLSession.shared.dataTask(with: breedsListEndPoint) {
            (data, response, error) in
            guard let data = data else {
            completionHandler([], error)
            return
            }
        let decoder = JSONDecoder()
            let breedsListData = try! decoder.decode(BreedListResponse.self, from: data)
            let breeds = breedsListData.message.keys.map({$0})
            completionHandler(breeds, nil)
        }
        breedsListURLTask.resume()
    }
}

