//
//  CoinViewModel.swift
//  ViewModel
//
//  Created by Matheus Orth on 06/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import MModel

public final class CoinViewModel: CoinViewModeling {
  
  public var coins: Property<[Coin]> {
    return Property(_coins)
  }
  
  private let _coins = MutableProperty<[Coin]>([])
  private let coinModeling: CoinModeling
  
  public init(coinModeling: CoinModeling){
    self.coinModeling = coinModeling
    getCoins()
  }
  
  public func getCoins() {
    coinModeling.getList().start({ event in
      switch event {
      case .value(let asd ):
        self._coins.value = asd as [Coin]
      default :
        print("loko")
      }
    })
  }
  
}
