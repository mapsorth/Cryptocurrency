//
//  CoinDetailTableViewCellModeling.swift
//  ViewModel
//
//  Created by Matheus Orth on 09/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift

public protocol CoinDetailTableViewCellModeling {
  
  var date: String { get }
  var closePrice: String { get }
}
