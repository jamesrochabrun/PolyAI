//
//  LLMMessageResponse.swift
//
//
//  Created by James Rochabrun on 4/6/24.
//

import Foundation
import SwiftAnthropic
import SwiftOpenAI

// MARK: Interface

public protocol LLMMessageResponse {
   var id: String { get }
   var model: String { get }
   var role: String { get }
   var createdAt: Int? { get }
   var contentDescription: String { get }
   var usageMetrics: UsageMetrics { get }
   var tools: [ToolUsage] { get }
}

public protocol UsageMetrics {
   var inputTokens: Int { get }
   var outputTokens: Int { get }
   var totalTokens: Int? { get }
}

struct ChatUsageMetrics: UsageMetrics {
   let inputTokens: Int
   let outputTokens: Int
   let totalTokens: Int?
}

public protocol ToolUsage {
   var toolId: String? { get }
   var toolName: String { get }
   var toolInput: [String: String]? { get } // Assuming tools might have inputs. Adjust as necessary.
}

// MARK: OpenAI

extension ChatCompletionObject: LLMMessageResponse {
   public var tools: [ToolUsage] {
      []
   }
   
   public var role: String {
      choices.first?.message.role ?? "unknown"
   }
   
   public var createdAt: Int? {
      created
   }
   
   public var contentDescription: String {
      choices.first?.message.content ?? ""
   }
   
   public var usageMetrics: UsageMetrics {
      ChatUsageMetrics(inputTokens: usage.promptTokens, outputTokens: usage.completionTokens, totalTokens: usage.totalTokens)
   }
}

// MARK: Anthropic

extension MessageResponse: LLMMessageResponse {
   public var createdAt: Int? {
      nil
   }
   
   public var contentDescription: String {
      content.map { contentItem in
         switch contentItem {
         case .text(let text):
            return text
         case .toolUse(_, let name, _):
            return "Tool: \(name)"
         }
      }.first ?? ""
   }
   
   public var usageMetrics: UsageMetrics {
      ChatUsageMetrics(inputTokens: usage.inputTokens, outputTokens: usage.outputTokens, totalTokens: nil)
   }
   
   public var tools: [ToolUsage] {
      []
   }
}
