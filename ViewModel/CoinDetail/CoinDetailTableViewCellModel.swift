//
//  CoinDetailTableViewCellModel.swift
//  ViewModel
//
//  Created by Matheus Orth on 09/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import MModel

public final class CoinDetailTableViewCellModel: CoinDetailTableViewCellModeling {
  
  public let date: String
  public let closePrice: String
  
  internal init(coinDetail: CoinDetail){
    let fullDate = Date(timeIntervalSince1970: TimeInterval(coinDetail.time))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM"
    date =  dateFormatter.string(from: fullDate)
    closePrice = "€ \(coinDetail.close)"
  }
  

  
}

