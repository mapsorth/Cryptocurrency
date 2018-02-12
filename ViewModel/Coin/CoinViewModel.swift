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
    getAllCoins()
  }
  
  public func getCoins(_ searchString: String?) {
    searchString?.isEmpty ?? true ? { _searchResult.value?.removeAll() } () : search(searchString!)
  }
  
  public func navigateToCoinDetail(_ index: Int) {
    let coin = _searchResult.value?.count == 0 ? _coins.value.all![index] : _searchResult.value![index]
    coinDetailModifiable?.getCoin(coin)
  }
  
  private func getAllCoins(){
    if self._coins.value.defaultCoinsInt == nil {
      coinModeling.getList().start({ event in
      switch event {
      case .value(let listCoins):
        self._coins.value = listCoins
        self.setCellModels(coins: listCoins.all!)
        self.getBitcoinDetailForiWatch()
      default:
        print("loko")
      }
      })
    }
  }
  
  private func getBitcoinDetailForiWatch(){
    let bitcoin = (_coins.value.all?.filter { $0.coinFullName.lowercased().contains("BTC".lowercased()) })?[1]
    coinModeling.getCoinDetails(bitcoin!).start({ event in
      switch event {
      case .value(let coinDetails):
        self._bitcoin.value = self.formatCoinToDict(coinDetails)
      default:
        print("loko")
      }
    })
  }
  
  private func formatCoinToDict(_ coin: Coin) -> [String:AnyObject]{
    let coin = ["name"      : coin.coinName as AnyObject,
                "currency"  : "$ 9999,99" as AnyObject,
                "details"   : formatDetailDict(coin.details!) as AnyObject]
    
    let parameter = ["coinDetails": coin as AnyObject]
    return parameter
  }
  
  private func formatDetailDict(_ coinDetail: [CoinDetail]) -> [[String:String]]{
    var detaildict = [[String:String]]()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM"
    for detail in coinDetail{
      let fullDate = Date(timeIntervalSince1970: TimeInterval(detail.time))
      let dictLocal = ["time": dateFormatter.string(from: fullDate), "close": "€ \(detail.close)"]
      detaildict.append(dictLocal)
    }
    return detaildict
  }
  
  private func setCellModels(coins: [Coin]){
    _cellModels.value = coins.map { CoinTableViewCellModel(coin: $0) }
  }
  
  private func search(_ text: String){
    _searchResult.value = (_coins.value.all?.filter { $0.coinFullName.lowercased().contains(text.lowercased()) })
    self.setCellModels(coins: _searchResult.value!)
  }
}
