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
  
  public func getList() -> SignalProducer<[Coin], NetworkError> {
    //let url = Pixabay.apiURL
    //let parameters = Pixabay.requestParameters
    let rootURL = "https://min-api.cryptocompare.com/data/all/coinlist"

    return SignalProducer { observer, disposable in
      self.network.get(rootURL, parameters: nil).start({ event in
        switch event {
        case .value(let json):
          let list = (json as? [String:AnyObject])?["Data"]
          //_ = (try? Coin.decodeValue(list as Any) as? Coin)
          let asddsa =  (try? Coin.decodeValue((list as! [String:AnyObject]).first?.value as Any))
          observer.send(value: [asddsa!])
        default: break
        }
      
        
      })
        
//        { listCoins in
//        if let response = (try? Coin.decodeValue(json)) {
//          return Result(value: response)
//        }
//        else {
//          return Result(error: .IncorrectDataReturned)
//        }
//      }
  }
}
}
