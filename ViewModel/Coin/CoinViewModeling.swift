//
//  CoinViewModeling.swift
//  ViewModel
//
//  Created by Matheus Orth on 06/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import MModel

public protocol CoinViewModeling{
  
  var coins: Property<[Coin]> { get }
  
  func getCoins()
  
}

