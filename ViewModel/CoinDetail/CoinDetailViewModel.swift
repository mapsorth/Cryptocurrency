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
  private var timer = Timer()
  private var isRunningTimer = false

  public init(coinModeling: CoinModeling){
    self.coinModeling = coinModeling
  }
  
  public func updateCurrency(){
    coinModeling.getCoinCurrency(_coin.value!).start({ event in
      switch event {
      case .value(let coinCurrency):
        self._coin.value = coinCurrency
      default: break
      }
    })
  }
  
  private func setupTimer(){
    if !isRunningTimer{
    DispatchQueue.main.async {
      self.timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.timerFire), userInfo: nil, repeats: true)
    }
      isRunningTimer = true
    }
  }
  
  @objc func timerFire(){
    updateCurrency()
  }
  
  public func getCoinDetails() {
    coinModeling.getCoinDetails(_coin.value!).start({ event in
      switch event {
      case .value(let coinDetails):
        self._coin.value = coinDetails
        self.setCellModels(coinDetails.details ?? [])
        self.setupTimer()
      default: break
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
