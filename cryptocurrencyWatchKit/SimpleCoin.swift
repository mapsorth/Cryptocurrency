//
//  SimpleCoin.swift
//  MModel
//
//  Created by Matheus Orth on 11/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

public struct SimpleCoin {
  public var coinName: String?
  public var currentCurrency: String?
  public var details: [[String:String]]?
}

extension SimpleCoin {
  public mutating func decode(_ dict: [String: AnyObject]){
    self.coinName         = dict["name"] as? String
    self.currentCurrency  = dict["currency"] as? String
    self.details          = dict["details"]  as? [[String:String]]
  }
}
