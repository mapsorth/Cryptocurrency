//
//  NetworkSpec.swift
//  MModelTests
//
//  Created by Matheus Orth on 02/02/18.
//  Copyright © 2018 Collab. All rights reserved.
//

import Quick
import Nimble

@testable import MModel

/// Specificatios of Network.
/// As a stable network service, https://httpbin.org is used.
/// Refer to the website for its API details.
class NetworkSpec: QuickSpec {
    override func spec() {
        var network: Network!
        beforeEach {
            network = Network()
        }
        describe("JSON") {
            it("eventually gets JSON data as specified with parameters.") {
                var json: [String: Any]? = nil
                network.get("https://httpbin.org/get", parameters: ["a": "b" as AnyObject, "x": "y" as AnyObject])
                    .on(value: { json = $0 as? [String: Any] })
                    .start()
                
                expect(json).toEventuallyNot(beNil(), timeout: 5)
                expect((json?["args"] as? [String: AnyObject])?["a"] as? String).toEventually(equal("b"), timeout: 5)
                expect((json?["args"] as? [String: AnyObject])?["x"] as? String).toEventually(equal("y"), timeout: 5)
            }
            it("eventually gets an error if the network has a problem.") {
                var error: NetworkError? = nil
                network.get("https://not.existing.server.comm/get", parameters: ["a": "b" as AnyObject, "x": "y" as AnyObject])
                    .on(failed: { error = $0 })
                    .start()
                
                expect(error).toEventually(equal(NetworkError.NotReachedServer), timeout: 5)
            }
        }
      describe("Image") {
        it("eventually gets an image.") {
          var image: UIImage?
          network.getImage("https://httpbin.org/image/jpeg")
            .on(value: { image = $0 })
            .start()
          
          expect(image).toEventuallyNot(beNil(), timeout: 5)
        }
        it("eventually gets an error if incorrect data for an image is returned.") {
          var error: NetworkError?
          network.getImage("https://httpbin.org/get")
            .on(failed: { error = $0 })
            .start()
          
          expect(error).toEventually(
            equal(NetworkError.IncorrectDataReturned), timeout: 5)
        }
        it("eventually gets an error if the network has a problem.") {
          var error: NetworkError? = nil
          network.getImage("https://not.existing.server.comm/image/jpeg")
            .on(failed: { error = $0 })
            .start()
          
          expect(error).toEventually(
            equal(NetworkError.NotReachedServer), timeout: 5)
        }
      }
    }
}
