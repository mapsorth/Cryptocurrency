//
//  Networking.swift
//  Model
//
//  Created by Matheus Orth on 02/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import ReactiveSwift

public protocol Networking {

  func get(_ url: String, parameters: [String: AnyObject]?) -> SignalProducer<AnyObject, NetworkError>
  
  func getImage(_ url: String) -> SignalProducer<UIImage, NetworkError>
  
}
