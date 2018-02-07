//
//  Coin.swift
//  MModel
//
//  Created by Matheus Orth on 05/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import Foundation
import Himotoki

public struct Coin {
  public let id: String
  public let overviewURL: String
  public let imageURL: String
  public let name: String
  public let symbol: String
  public let coinName: String
  public let coinFullName: String
  public let algorithm: String
  public let proofType: String
  public let fullyPremined: String
  public let totalCoinSupply: String
  public let preMinedValue: String
  public let totalCoinsFreeFloar: String
  public let sortOrder: String
  public let sponsored: Bool
}

extension Coin : Himotoki.Decodable {
  public static func decode(_ e: Extractor) throws -> Coin {
    return try Coin(
      id: e <| "Id",
      overviewURL: e <| "Url",
      imageURL: e <| "ImageUrl",
      name: e <| "Name",
      symbol: e <| "Symbol",
      coinName: e <| "CoinName",
      coinFullName: e <| "FullName",
      algorithm: e <| "Algorithm",
      proofType: e <| "ProofType",
      fullyPremined: e <| "FullyPremined",
      totalCoinSupply: e <| "TotalCoinSupply",
      preMinedValue: e <| "PreMinedValue",
      totalCoinsFreeFloar: e <| "TotalCoinsFreeFloat",
      sortOrder: e <| "SortOrder",
      sponsored: e <| "Sponsored"
    )
  }
}
