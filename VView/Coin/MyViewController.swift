//
//  MyViewController.swift
//  VView
//
//  Created by Matheus Orth on 02/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import UIKit
import ViewModel
import MModel
import ReactiveSwift
import WatchConnectivity

public class MyViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchTextField: UITextField!
  
  public var viewModel: CoinViewModeling?
  private var coins: (defaultCoinsInt: Int? ,all:[Coin]?)?
  private var searchResult: [Coin]?
  private var watchSession : WCSession?

  
  override public func viewDidLoad() {
        super.viewDidLoad()
    
    let bundle = Bundle(for: CoinTableViewCell.self)
    tableView.register(UINib(nibName: "CoinTableViewCell", bundle: bundle), forCellReuseIdentifier: "coinCell")
    tableView.delegate = self
    tableView.dataSource = self
    searchTextField.addTarget(self, action: #selector(MyViewController.textFieldChanged(_:)), for: .editingChanged)

    if(WCSession.isSupported()){
      watchSession = WCSession.default
      watchSession!.delegate = self
      watchSession!.activate()
    }
    
    bindingData()
  }

  override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
  func bindingData(){
    if let viewModel = viewModel {
      viewModel.cellModels.producer.start({ asddas in
        if asddas.value?.count != 0 {
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
        }
      })
      viewModel.bitcoin.producer.start({ bitcoin in
        if !(bitcoin.value?.isEmpty ?? true){
          DispatchQueue.main.async {
            self.sendToWatch(bitcoin.value!)
          }
        }
      })
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
  
  @objc fileprivate func textFieldChanged(_ textField: UITextField) {
    if let viewModel = self.viewModel {
      viewModel.getCoins(textField.text)
    }
  }
}

extension MyViewController: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let viewModel = self.viewModel {
      viewModel.navigateToCoinDetail(indexPath.row)
      self.performSegue(withIdentifier: "coinDetailSegue", sender: nil)
    }
  }

  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
}

extension MyViewController: UITableViewDataSource {
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    return 1//(coins?.defaultCoinsInt == 0) || (searchResult?.count != 0) ? 1 : 2
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.cellModels.value.count ?? 0
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell", for: indexPath) as! CoinTableViewCell
    if let viewModel = self.viewModel {
      cell.viewModel = viewModel.cellModels.value[indexPath.row + indexPath.section*(viewModel.coins.value.defaultCoinsInt ?? 0)]
    }
    return cell
  }
}

extension MyViewController: WCSessionDelegate {
  @available(iOS 9.3, *)
  public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    
  }
  
  public func sessionDidBecomeInactive(_ session: WCSession) {
    
  }
  
  public func sessionDidDeactivate(_ session: WCSession) {
    
  }
}
