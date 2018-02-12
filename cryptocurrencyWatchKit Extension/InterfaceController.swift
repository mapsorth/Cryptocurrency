//
//  InterfaceController.swift
//  cryptocurrencyWatchKit Extension
//
//  Created by Matheus Orth on 10/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
  @IBOutlet var coinNameLabel: WKInterfaceLabel!
  @IBOutlet var coinCurrentCurrencyLabel: WKInterfaceLabel!
  @IBOutlet var tableView: WKInterfaceTable!
  
  var watchSession : WCSession?

  var coinDetails: SimpleCoin? {
    didSet {
      setHeader()
      loadTable()
      }
  }
  
  override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
      
      if(WCSession.isSupported()){
        watchSession = WCSession.default
        // Add self as a delegate of the session so we can handle messages
        watchSession!.delegate = self
        watchSession!.activate()
      }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
  private func setHeader(){
    coinNameLabel.setText(coinDetails?.coinName)
    coinCurrentCurrencyLabel.setHidden(false)
    coinCurrentCurrencyLabel.setText("€ \(coinDetails!.currentCurrency!)")
  }
  
  private func loadTable(){
    tableView.setNumberOfRows(coinDetails?.details?.count ?? 0, withRowType: "detailRow")
    if let details = coinDetails?.details{
      var index = 0
      for detail in details.reversed() {
        let row = tableView.rowController(at: index) as? CoinDetailRowController
        row?.coinDetail = detail
        index += 1
      }
    }
  }
  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
    let details = applicationContext["coinDetails"] as! [String:AnyObject]
    var localCoin = SimpleCoin()
    localCoin.decode(details)
    coinDetails = localCoin
  }
}

extension InterfaceController: WCSessionDelegate {
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    print("activateDidComplete")
  }
}
