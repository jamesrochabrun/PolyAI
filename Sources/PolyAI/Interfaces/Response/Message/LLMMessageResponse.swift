//
//  LLMMessageResponse.swift
//
//
//  Created by James Rochabrun on 4/6/24.
//

import Foundation

// MARK: LLMMessageResponse

/// A protocol defining the required properties for a response from an LLM service.
public protocol LLMMessageResponse {
   /// A unique identifier for the message.
   var id: String { get }
   
   /// The model of the LLM that processed the message.
   var model: String { get }
   
   /// The role associated with the message, such as "user" or "assistant".
   var role: String { get }
   
   /// The creation time of the message as an epoch timestamp, optional.
   var createdAt: Int? { get }
   
   /// A description of the message's content.
   var contentDescription: String { get }
   
   /// Metrics detailing the usage of the LLM in terms of tokens.
   var usageMetrics: UsageMetrics { get }
   
   /// Tools to be used for function calling.
   var tools: [ToolUsage] { get }
}

/// A protocol defining metrics related to token usage by an LLM.
public protocol UsageMetrics {
   /// The number of input tokens provided to the LLM.
   var inputTokens: Int { get }
   
   /// The number of output tokens produced by the LLM.
   var outputTokens: Int { get }
   
   /// The total number of tokens used, optional.
   var totalTokens: Int? { get }
}

/// A structure implementing the UsageMetrics protocol for chat applications.
struct ChatUsageMetrics: UsageMetrics {
   let inputTokens: Int
   let outputTokens: Int
   let totalTokens: Int?
}

/// A protocol defining the properties required for tracking the usage of tools within an LLM service.
public protocol ToolUsage {
   /// An optional unique identifier for the tool.
   var toolId: String? { get }
   
   /// The name of the tool used.
   var toolName: String { get }
   
   /// A dictionary containing inputs provided to the tool, if applicable.
   var toolInput: [String: String]? { get }
}
