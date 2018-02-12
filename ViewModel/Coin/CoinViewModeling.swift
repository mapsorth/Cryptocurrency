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
  
  var coins: Property<(defaultCoinsInt: Int? ,all:[Coin]?)> { get }
  var searchResult: Property<[Coin]?> { get }
  var cellModels: Property<[CoinTableViewCellModeling]> { get }
  var bitcoin: Property<[String:AnyObject]> { get }

  
  func getCoins(_ searchString: String?)
  func navigateToCoinDetail(_ coin: Int)
}

