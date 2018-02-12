//
//  CoinDetailViewModel.swift
//  ViewModel
//
//  Created by Matheus Orth on 09/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import MModel

public final class CoinDetailViewModel: CoinDetailViewModeling {
  
  
  public var coin: Property<Coin?> {
    return Property(_coin)
  }
  
  public var cellModels: Property<[CoinDetailTableViewCellModeling]> {
    return Property(_cellModels)
  }
  
  private let _cellModels = MutableProperty<[CoinDetailTableViewCellModeling]>([])
  private let _coin = MutableProperty<Coin?>(nil)
  private let coinModeling: CoinModeling
  
  public init(coinModeling: CoinModeling){
    self.coinModeling = coinModeling
  }
  
  public func getCoinDetails() {
    coinModeling.getCoinDetails(_coin.value!).start({ event in
      switch event {
      case .value(let coinDetails):
        self._coin.value = coinDetails
        self.setCellModels(coinDetails.details ?? [])
      default:  
        print("loko")
      }
    })
  }
  private func setCellModels(_ coinDetails: [CoinDetail]){
    _cellModels.value = coinDetails.reversed().map { CoinDetailTableViewCellModel(coinDetail: $0) }
  }
}

extension CoinDetailViewModel : CoinDetailModifiable {
  public func getCoin(_ coin: Coin) {
    self._coin.value = coin
    getCoinDetails()
  }
}
