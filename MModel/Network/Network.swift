//
//  Network.swift
//  Model
//
//  Created by Matheus Orth on 02/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import ReactiveSwift
import Alamofire

public final class Network: Networking {
  private let queue = DispatchQueue(label: "Tamplete.Model.Network.Queue", attributes: [])

  public init() { }
  
  public func get(_ url: String, parameters: [String: AnyObject]?) -> SignalProducer<AnyObject, NetworkError> {
    return SignalProducer { observer, disposable in
      Alamofire.request(url, method: .get, parameters: parameters)
        .response(queue: self.queue, responseSerializer: Alamofire.DataRequest.jsonResponseSerializer()) { response in
          switch response.result {
          case .success(let value):
            
      
            observer.send(value: value as AnyObject)
          case .failure(let error):
            observer.send(error: NetworkError(error: error as NSError))
          }
      }
    }
  }

  public func getImage(_ url: String) -> SignalProducer<UIImage, NetworkError> {
    return SignalProducer { observer, disposable in
      let finalUrl = "\(mediaRoottURL)\(url)"
      Alamofire.request(finalUrl, method: .get, parameters: nil)
        .response(queue: self.queue, responseSerializer: Alamofire.DataRequest.dataResponseSerializer()) {
          response in
          switch response.result {
          case .success(let data):
            guard let image = UIImage(data: data) else {
              observer.send(error: .IncorrectDataReturned)
              return
            }
            observer.send(value: image)
            observer.sendCompleted()
          case .failure(let error):
            observer.send(error: NetworkError(error: error as NSError))
          }
      }
    }
  }

}
