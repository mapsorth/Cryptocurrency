//
//  CoinModel.swift
//  MModel
//
//  Created by Matheus Orth on 05/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import Result
import Himotoki

public final class CoinModel: CoinModeling {

  private let network: Networking
  
  public init(network: Networking) {
    self.network = network
  }
  
  public func getList() -> SignalProducer<(defaultCoinsInt: Int? ,all:[Coin]?), NetworkError> {
    let url = rootURL + "data/all/coinlist"

    return SignalProducer { observer, disposable in
      self.network.get(url, parameters: nil).start({ event in
        switch event {
        case .value(let json):
          var coins:[Coin]?
          if let list = (json as? [String:AnyObject])?["Data"] {
            for coin in (list as! [String:AnyObject]) {
              if let coinElement = try? Coin.decodeValue(coin.value as Any) {
                coins?.append(coinElement) == nil ? { coins = [coinElement]}() : ()
              }
            }
          }
          if coins != nil {
          observer.send(value: (defaultCoinsInt: self.getDefaultCoinsWatchlist(json as! [String:AnyObject], coins: coins!), all: coins))
          }
        default: break
        }
      })
    }
  }
  
  private func getDefaultCoinsWatchlist(_ json: [String:AnyObject], coins: [Coin]) -> Int?{
    var defaultCoinsInt: Int? = nil
    if let defaultWatchList = json["DefaultWatchlist"] {
      let defaultWatchlistString = (defaultWatchList as! [String:AnyObject])["CoinIs"] as! String
      let defaultWatchlistArray = defaultWatchlistString.components(separatedBy: ",")
      defaultCoinsInt = coins.filter{ defaultWatchlistArray.contains($0.id)}.count
    }
    return defaultCoinsInt
  }
  
  public func getCoinDetails(_ coin: Coin) -> SignalProducer <Coin, NetworkError> {
    
    let url = rootURL + "data/histoday"
    let parameters = ["fsym" : coin.symbol as AnyObject, // TODO: Dynamic to any Currency
               "tsym" : "EUR" as AnyObject, // TODO: Dynamic to any Currency
               "limit" : 14 as AnyObject] // TODO: Dynamic to any limit
    
    return SignalProducer { observer, disposable in
      self.network.get(url, parameters: parameters).start({ result in
        switch result {
        case .value(let json):
          var coinLocal = coin
          var coinsDetail:[CoinDetail]?
          if let details = (json as? [String:AnyObject])?["Data"] {
            for detail in (details as! [AnyObject]) {
              if let coinElement = try? CoinDetail.decodeValue(detail as Any) {
                coinsDetail?.append(coinElement) == nil ? { coinsDetail = [coinElement]}() : ()
              }
            }
            coinLocal.details = coinsDetail
          }
          self.getCurrency(coinLocal, completionHandler: { (coin) in
            coinLocal.currency = coin.currency
            observer.send(value: coinLocal)
            observer.sendCompleted()
          })
        default: break
        }
      })
    }
  }
  
  public func getCoinCurrency(_ coin: Coin) -> SignalProducer<Coin, NetworkError> {
    return SignalProducer { observer , disposable in
      self.getCurrency(coin, completionHandler: { (resultCoin) in
        observer.send(value: resultCoin)
        observer.sendCompleted()
      })
    }
  }
  
  private func getCurrency(_ coin: Coin, completionHandler: @escaping (_ completion: Coin) -> Void)  {
    let url = rootURL + "data/price"
    let parameters = ["fsym" : coin.symbol as AnyObject, // TODO: Dynamic to any Currency
      "tsyms" : "EUR" as AnyObject] // TODO: Dynamic to any Currency
      self.network.get(url, parameters: parameters).start({ result in
        switch result {
        case .value(let json):
          var coinLocal = coin
          if let currency = (json as? [String:AnyObject])?["EUR"] {
            coinLocal.currency = currency.floatValue
          }
          completionHandler(coinLocal)
        default: break
        }
      })
  }
}
