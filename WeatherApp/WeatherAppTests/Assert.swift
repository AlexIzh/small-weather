//
//  Assert.swift
//  WeatherAppTests
//
//  Created by Alex Severyanov on 6/13/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import Foundation
import XCTest

struct Assert {
   static func isTrue(_ value: Bool, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
      XCTAssertTrue(value, message, file: file, line: line)
   }

   static func isFalse(_ value: Bool, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
      XCTAssertFalse(value, message, file: file, line: line)
   }

   static func equals<T: Equatable>(_ lhs: T, _ rhs: T, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
      XCTAssertEqual(lhs, rhs, message, file: file, line: line)
   }

   static func fail(_ message: String, file: StaticString = #file, line: UInt = #line) {
      XCTFail(message, file: file, line: line)
   }

   static func isNil<T>(_ value: T?, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
      if let value = value {
         let msg = message.isEmpty ? String(describing: value) : message
         XCTFail(msg, file: file, line: line)
      }
   }
}
