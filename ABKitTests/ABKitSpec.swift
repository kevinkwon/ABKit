//
//  ABKitSpec.swift
//  ABKit
//
//  Created by Masato OSHIMA on 2016/02/12.
//  Copyright © 2016年 Recruit Marketing Partners Co.,Ltd. All rights reserved.
//

import Quick
import Nimble
@testable import ABKit

class ABKitSpec: QuickSpec {
    
    override func spec() {
        
        describe("ABKit") {
            
            context("SprintTest Initialization") {
                
                it("create SplitTest by convinience") {
                    let defaultVersion = Version(name: "name", behavior: {})
                    let splitTest = SplitTest(name: "name", defaultVersion: defaultVersion)
                    expect(splitTest.versionWeights).to(beEmpty())
                }
                
                it("create SplitTest") {
                    let randomNumberRepository = TestRandomNumberRepository()
                    let defaultVersion = Version(name: "name", behavior: {})
                    let splitTest = SplitTest(name: "name", defaultVersion: defaultVersion, randomNumberRepository: randomNumberRepository)
                    expect(splitTest.versionWeights).to(beEmpty())
                }
            }
            
            context("SprintTest Add Version") {
                
                it("creates version weights") {
                    let defaultVersion = Version(name: "name", behavior: {})
                    let version1 = Version(name: "version1", behavior: {})
                    let version2 = Version(name: "version2", behavior: {})
                    let splitTest = SplitTest(name: "name", defaultVersion: defaultVersion)
                    splitTest.addVersion(version1, weight: 0.2)
                    splitTest.addVersion(version2, weight: 0.4)
                    expect(splitTest.versionWeights.count).to(equal(2))
                    expect(splitTest.versionWeights[0].version.name).to(equal(version1.name))
                    expect(splitTest.versionWeights[0].weight).to(equal(20))
                    expect(splitTest.versionWeights[0].weightRange).to(equal(0..<100))
                    expect(splitTest.versionWeights[1].version.name).to(equal(version2.name))
                    expect(splitTest.versionWeights[1].weight).to(equal(40))
                    expect(splitTest.versionWeights[1].weightRange).to(equal(0..<100))
                }
            }
            
            context("SprintTest Run") {
                
                it("calcurates version weights") {
                    let defaultVersion = Version(name: "name", behavior: {})
                    let version1 = Version(name: "version1", behavior: {})
                    let version2 = Version(name: "version2", behavior: {})
                    let splitTest = SplitTest(name: "name", defaultVersion: defaultVersion)
                    splitTest.addVersion(version1, weight: 0.2)
                    splitTest.addVersion(version2, weight: 0.4)
                    splitTest.run()
                    expect(splitTest.versionWeights.count).to(equal(2))
                    expect(splitTest.versionWeights[0].version.name).to(equal(version1.name))
                    expect(splitTest.versionWeights[0].weight).to(equal(20))
                    expect(splitTest.versionWeights[0].weightRange).to(equal(0..<20))
                    expect(splitTest.versionWeights[1].version.name).to(equal(version2.name))
                    expect(splitTest.versionWeights[1].weight).to(equal(40))
                    expect(splitTest.versionWeights[1].weightRange).to(equal(20..<60))
                }
            }

        }
    }
}

class TestRandomNumberRepository: RandomNumberRepository {
    
    func ab_getRandomNumberWithKey(key: String) -> Int {
        return 1
    }
}
