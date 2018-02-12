//
//  CoinModeling.swift
//  MModel
//
//  Created by Matheus Orth on 05/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift

public protocol CoinModeling {

  func getList() -> SignalProducer<(defaultCoinsInt: Int? ,all:[Coin]?), NetworkError>
  
  func getCoinDetails(_ coin: Coin) -> SignalProducer <Coin, NetworkError>
  
  func getCoinCurrency(_ coin: Coin) -> SignalProducer <Coin, NetworkError>
}
