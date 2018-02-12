//
//  CoinDetailViewController.swift
//  VView
//
//  Created by Matheus Orth on 09/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import UIKit
import ViewModel
import MModel
import ReactiveSwift

public class CoinDetailViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  public var viewModel: CoinDetailViewModeling?
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    let bundle = Bundle(for: CoinDetailsTableViewCell.self)
    tableView.register(UINib(nibName: "CoinDetailsTableViewCell", bundle: bundle), forCellReuseIdentifier: "coinDetailCell")
    tableView.delegate = self
    tableView.dataSource = self
    self.navigationItem.title = viewModel?.coin.value?.coinName
    bindingData()
  }
  
  private func bindingData() {
    if let viewModel = viewModel {
      viewModel.cellModels.producer.start({ asddas in
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      })
    }
  }
  
  public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CoinDetailViewController: UITableViewDelegate {
  
}

extension CoinDetailViewController: UITableViewDataSource {
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel?.cellModels.value.count ?? 0
  }
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "coinDetailCell", for: indexPath) as! CoinDetailsTableViewCell
    if let viewModel = viewModel {
      cell.viewModel = viewModel.cellModels.value[indexPath.row]
    }
    return cell
  }
}
