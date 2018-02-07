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

public class MyViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  public var viewModel: CoinViewModeling?
  private var coins: [Coin]?
  override public func viewDidLoad() {
        super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
        // Do any additional setup after loading the view.
    bindingData()
  }

  override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func bindingData(){
    if let viewModel = viewModel {
      viewModel.coins.producer.startWithValues({ coins in
        self.coins = coins
        self.tableView.reloadData()
      })
    }
  }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MyViewController: UITableViewDelegate {
  
}

extension MyViewController: UITableViewDataSource {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return coins?.count ?? 0
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath)
    if let localCoins = coins {
      cell.textLabel?.text = localCoins[indexPath.row].coinName
    }
    return cell
  }
}
