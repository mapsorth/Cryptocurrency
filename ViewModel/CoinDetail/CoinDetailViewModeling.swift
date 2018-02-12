//
//  CoinDetailViewModeling.swift
//  ViewModel
//
//  Created by Matheus Orth on 09/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import MModel

public protocol CoinDetailViewModeling{
  
  var coin: Property<Coin?> { get }
  var cellModels: Property<[CoinDetailTableViewCellModeling]> { get }
  
  func getCoinDetails()
}

public protocol CoinDetailModifiable: CoinDetailViewModeling{
  
  func getCoin(_ coin: Coin)
}
