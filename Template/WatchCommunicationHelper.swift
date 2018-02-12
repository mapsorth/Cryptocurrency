//
//  WatchCommunicationHelper.swift
//  MModel
//
//  Created by Matheus Orth on 12/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import UIKit
import MModel
import WatchConnectivity

class WatchCommunicationHelper: NSObject {
  
  static let singleton = WatchCommunicationHelper()
  var coinModeling: CoinModeling?
  private var timer = Timer()
  private var isRunningTimer = false
  private var watchSession : WCSession?
  private var bitcoin: Coin?

  func initCommunication(_ bitcoin: Coin, coinModeling: CoinModeling) {
    self.bitcoin = bitcoin
    self.coinModeling = coinModeling
    setupWCSession()
    if !isRunningTimer {
      DispatchQueue.main.async {
        self.timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.timerFire), userInfo: nil, repeats: true)
      }
    }
  }
  func stopTimer() {
    timer.invalidate()
  }
  
  @objc func timerFire(){
    if let bitcoin = bitcoin { self.getBitcoinDetailForiWatch(bitcoin) }
  }
  
  func setupWCSession(){
    if(WCSession.isSupported()){
      watchSession = WCSession.default
      watchSession!.delegate = self
      watchSession!.activate()
    }
  }
  
  fileprivate func sendToWatch(_ dict: [String:AnyObject]){
    do {
      try watchSession?.updateApplicationContext(
        dict
      )
    } catch let error as NSError {
      NSLog("Updating the context failed: " + error.localizedDescription)
    }
  }
  
  private func getBitcoinDetailForiWatch(_ bitcoin: Coin){
    coinModeling?.getCoinDetails(bitcoin).start({ event in
      switch event {
      case .value(let coinDetails):
        self.sendToWatch(self.formatCoinToDict(coinDetails))
      default:
        print("default")
      }
    })
  }
  
  private func formatCoinToDict(_ coin: Coin) -> [String:AnyObject]{
    let coin = ["name"      : coin.coinName as AnyObject,
                "currency"  : "\(coin.currency ?? 0)" as AnyObject,
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
}

extension WatchCommunicationHelper: WCSessionDelegate {
  
  @available(iOS 9.3, *)
  func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
  }
  
  func sessionDidBecomeInactive(_ session: WCSession) {
    
  }
  func sessionDidDeactivate(_ session: WCSession) {
    
  }
}
