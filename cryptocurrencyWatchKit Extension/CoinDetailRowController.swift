//
//  CoinDetailRowController.swift
//  cryptocurrencyWatchKit Extension
//
//  Created by Matheus Orth on 11/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import WatchKit

class CoinDetailRowController: NSObject {
  
  @IBOutlet var dateLabel: WKInterfaceLabel!
  @IBOutlet var currencyLabel: WKInterfaceLabel!
  
  var coinDetail: [String:String]? {
    didSet {
      guard let coinDetail = coinDetail else { return }
      let date = coinDetail["time"]
      let value = coinDetail["close"] 
      dateLabel.setText(date)
      currencyLabel.setText(value)
    }
  }

}
