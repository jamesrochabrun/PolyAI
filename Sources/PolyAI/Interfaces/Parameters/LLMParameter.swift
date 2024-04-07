//
//  LLMParameter.swift
//
//
//  Created by James Rochabrun on 4/6/24.
//

import Foundation

public enum LLMParameter {
   
   case openAI(model: String, messages: [LLMMessageParameter], maxTokens: Int? = nil, stream: Bool? = nil)
   case anthropic(model: String, messages: [LLMMessageParameter], maxTokens: Int, stream: Bool)
   
   var llm: String {
      switch self {
      case .openAI: return "OpenAI"
      case .anthropic: return "Anthropic"
      }
   }
}
