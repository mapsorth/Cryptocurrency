//
//  CoinTableViewCellModel.swift
//  ViewModel
//
//  Created by Matheus Orth on 07/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import MModel

public final class CoinTableViewCellModel: CoinTableViewCellModeling {
  
  public let name: String
  public let symbol: String
  
  internal init(coin: Coin){
    name = coin.coinName
    symbol = coin.symbol
  }
}
