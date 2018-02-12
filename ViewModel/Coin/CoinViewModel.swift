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
  
  public var coins: Property<(defaultCoinsInt: Int? ,all:[Coin]?)> {
    return Property(_coins)
  }

  public var searchResult: Property<[Coin]?> {
    return Property(_searchResult)
  }
  
  public var cellModels: Property<[CoinTableViewCellModeling]> {
    return Property(_cellModels)
  }
  
  public var bitcoin: Property<[String:AnyObject]> {
    return Property(_bitcoin)
  }
  
  private let _cellModels = MutableProperty<[CoinTableViewCellModeling]>([])
  private let _coins = MutableProperty<(defaultCoinsInt: Int?, all:[Coin]?)>((nil,[]))
  private let _searchResult = MutableProperty<[Coin]?>([])
  private let _bitcoin = MutableProperty<[String:AnyObject]>([:])
  private let coinModeling: CoinModeling
  public var coinDetailModifiable: CoinDetailModifiable?
  
  
  public init(coinModeling: CoinModeling){
    self.coinModeling = coinModeling
    self.getAllCoins()
  }
  
  public func getCoins(_ searchString: String?) {
    let emptySearch = {
      _searchResult.value?.removeAll()
      setCellModels(coins: _coins.value.all!)
    }()
    searchString?.isEmpty ?? true ? emptySearch : search(searchString!)
  }
  
  public func navigateToCoinDetail(_ index: Int) {
    let coin = _searchResult.value?.count == 0 ? _coins.value.all![index] : _searchResult.value![index]
    coinDetailModifiable?.getCoin(coin)
  }
  
  private func getAllCoins(){
    if self._coins.value.defaultCoinsInt == nil {
      coinModeling.getList()
        .start({ event in
      switch event {
      case .value(let listCoins):
        self._coins.value = listCoins
        self.setCellModels(coins: listCoins.all!)
        self.getBitcoinDetailForiWatch()
      default:
        print("default")
      }
      })
    }
  }
  
  private func getBitcoinDetailForiWatch(){
    let bitcoin = (_coins.value.all?.filter { $0.coinFullName.lowercased().contains("BTC".lowercased()) })?[1]
    WatchCommunicationHelper.singleton.initCommunication(bitcoin!, coinModeling: coinModeling)
  }
  
  private func setCellModels(coins: [Coin]) {
    _cellModels.value = coins.map { CoinTableViewCellModel(coin: $0) }
  }
  
  private func search(_ text: String){
    _searchResult.value = (_coins.value.all?.filter { $0.coinFullName.lowercased().contains(text.lowercased()) })
    self.setCellModels(coins: _searchResult.value!)
  }
}
