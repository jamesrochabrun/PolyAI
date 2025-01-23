//
//  LLMMessageResponse+OpenAI.swift
//  
//
//  Created by James Rochabrun on 4/15/24.
//

import Foundation
import SwiftOpenAI

// MARK: OpenAI

extension ChatCompletionObject: LLMMessageResponse {
   
   public var createdAt: Int? {
      created
   }
   
   public var contentDescription: String {
      choices.first?.message.content ?? ""
   }
   
   public var usageMetrics: UsageMetrics {
      ChatUsageMetrics(inputTokens: usage?.promptTokens ?? 0, outputTokens: usage?.completionTokens ?? 0, totalTokens: usage?.totalTokens)
   }
   
   public var tools: [ToolUsage] {
      []
   }
   
   public var role: String {
      choices.first?.message.role ?? "unknown"
   }
}
