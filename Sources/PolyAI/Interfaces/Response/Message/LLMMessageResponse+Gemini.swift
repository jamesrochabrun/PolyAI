//
//  LLMMessageResponse+Gemini.swift
//
//
//  Created by James Rochabrun on 5/3/24.
//

import Foundation
import GoogleGenerativeAI

// MARK: Gemini

extension GenerateContentResponse: LLMMessageResponse {
  
   public var id: String {
      UUID().uuidString
   }
   
   public var model: String {
      ""
   }
   
   public var role: String {
      candidates.first?.content.role ?? "user"
   }
   
   public var createdAt: Int? {
      nil
   }
   
   public var contentDescription: String {
      text ?? ""
   }
   
   public var usageMetrics: UsageMetrics {
      ChatUsageMetrics(
         inputTokens: usageMetadata?.promptTokenCount ?? 0,
         outputTokens: usageMetadata?.candidatesTokenCount ?? 0,
         totalTokens: usageMetadata?.totalTokenCount ?? 0)
   }
   
   public var tools: [ToolUsage] {
      []
   }   
}
