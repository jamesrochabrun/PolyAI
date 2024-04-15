//
//  LLMMessageParameter.swift
//
//
//  Created by James Rochabrun on 4/6/24.
//

import Foundation

// MARK: LLMMessageParameter

public protocol LLMMessageParameter {
   
   var role: String { get }
   var content: String { get }
}

// MARK: LLMMessage

public struct LLMMessage: LLMMessageParameter {
   
   public var role: String
   public var content: String
   
   public enum Role: String {
      case user
      case assistant
   }
   
   public init(
      role: Role,
      content: String)
   {
      self.role = role.rawValue
      self.content = content
   }
}
