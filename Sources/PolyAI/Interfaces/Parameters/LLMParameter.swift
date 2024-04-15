//
//  LLMParameter.swift
//
//
//  Created by James Rochabrun on 4/6/24.
//

import Foundation
import SwiftOpenAI
import SwiftAnthropic

public enum LLMParameter {
   
   case openAI(model: SwiftOpenAI.Model, messages: [LLMMessage], maxTokens: Int? = nil)
   case anthropic(model: SwiftAnthropic.Model, messages: [LLMMessage], maxTokens: Int)
   
   var llmService: String {
      switch self {
      case .openAI: return "OpenAI"
      case .anthropic: return "Anthropic"
      }
   }
}
