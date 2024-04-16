//
//  LLMMessageParameter.swift
//
//
//  Created by James Rochabrun on 4/6/24.
//

import Foundation

// MARK: LLMMessageParameter

/// A protocol defining the basic requirements for a message parameter used with LLM services.
public protocol LLMMessageParameter {
   
   var role: String { get }
   var content: String { get }
}

// MARK: LLMMessage

public struct LLMMessage: LLMMessageParameter {
   
   /// The role of the sender in the conversation, such as "user" or "assistant".
   public var role: String
   
   /// The content of the message being sent.
   public var content: String
   
   public enum Role: String {
      case user
      case assistant
   }
   
   /// Initializes a new message with specified role and content.
   /// - Parameters:
   ///   - role: The role of the sender of the message.
   ///   - content: The content of the message.
   public init(
      role: Role,
      content: String)
   {
      self.role = role.rawValue
      self.content = content
   }
}
