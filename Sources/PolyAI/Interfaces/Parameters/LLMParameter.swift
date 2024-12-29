//
//  LLMParameter.swift
//
//
//  Created by James Rochabrun on 4/6/24.
//

import Foundation
import SwiftOpenAI
import SwiftAnthropic

/// An enum representing the parameters required to interface with different LLM services.
public enum LLMParameter {
   
   /// Represents a configuration for interacting with OpenAI's models.
     /// - Parameters:
     ///   - model: The specific model of OpenAI to use.
     ///   - messages: An array of messages to send to the model.
     ///   - maxTokens: An optional maximum number of tokens to generate. Defaults to `nil`.
   case openAI(model: SwiftOpenAI.Model, messages: [LLMMessage], maxTokens: Int? = nil)
   
   /// Represents a configuration for interacting with Anthropic's models.
   /// - Parameters:
   ///   - model: The specific model of Anthropic to use.
   ///   - messages: An array of messages to send to the model.
   ///   - maxTokens: The maximum number of tokens to generate.
   case anthropic(model: SwiftAnthropic.Model, messages: [LLMMessage], maxTokens: Int)
   
   /// Represents a configuration for interacting with Gemini's models.
   /// - Parameters:
   ///   - model: The specific model of Gemini to use.
   ///   - messages: An array of messages to send to the model.
   ///   - maxTokens: The maximum number of tokens to generate.
   case gemini(model: String, messages: [LLMMessage], maxTokens: Int? = nil)
   
   /// Represents a configuration for interacting with Gemini's models.
   /// - Parameters:
   ///   - model: The specific model. e.g: "llama3"
   ///   - messages: An array of messages to send to the model.
   ///   - maxTokens: The maximum number of tokens to generate.
   case ollama(model: String, messages: [LLMMessage], maxTokens: Int)
   
   /// A computed property that returns the name of the LLM service based on the case.
   var llmService: String {
      switch self {
      case .openAI: return "OpenAI"
      case .anthropic: return "Anthropic"
      case .gemini: return "Gemini"
      case .ollama(let model, _, _): return model
      }
   }
}
