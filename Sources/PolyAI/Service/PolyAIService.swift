//
//  PolyAIService.swift
//
//
//  Created by James Rochabrun on 4/6/24.
//

import Foundation
import SwiftOpenAI

/// Represents configurations for different LLM providers.
public enum LLMConfiguration {

   case openAI(OpenAICompatible)
   
   public enum OpenAICompatible {
      /// Configuration for accessing OpenAI's API.
      /// - Parameters:
      ///   - apiKey: The API key for authenticating requests to OpenAI.
      ///   - organizationID: Optional organization ID for OpenAI usage.
      ///   - configuration: The URLSession configuration to use for network requests. Defaults to `.default`.
      ///   - decoder: The JSON decoder used for decoding responses. Defaults to a new instance of `JSONDecoder`.
      case api(key: String, organizationID: String? = nil, configuration: URLSessionConfiguration = .default, decoder: JSONDecoder = .init())
      /// Configuration for accessing OpenAI's API.
      /// - Parameters:
      ///   - configuration: The AzureOpenAIConfiguration.
      ///   - urlSessionConfiguration: The URLSession configuration to use for network requests. Defaults to `.default`.
      ///   - decoder: The JSON decoder used for decoding responses. Defaults to a new instance of `JSONDecoder`.
      case azure(configuration: AzureOpenAIConfiguration, urlSessionConfiguration: URLSessionConfiguration = .default, decoder: JSONDecoder = .init())
      /// Configuration for accessing OpenAI's API.
      /// - Parameters:
      ///   - aiproxyPartialKey: The partial key provided in the 'API Keys' section of the AIProxy dashboard.
      ///                        Please see the integration guide for acquiring your key, at https://www.aiproxy.pro/docs
      ///   - aiproxyClientID: If your app already has client or user IDs that you want to annotate AIProxy requests
      ///                      with, you can pass a clientID here. If you do not have existing client or user IDs, leave
      ///                      the `clientID` argument out, and IDs will be generated automatically for you.
      case aiProxy(aiproxyPartialKey: String, aiproxyClientID: String? = nil)
      /// Configuration for accessing Gemini's API.
      /// - Parameters:
      ///   - apiKey: The API key for authenticating requests to Gemini.
      ///   - urlSessionConfiguration: The URLSession configuration to use for network requests. Defaults to `.default`.
      ///   - decoder: The JSON decoder used for decoding responses. Defaults to a new instance of `JSONDecoder`.
      case gemini(apiKey: String, configuration: URLSessionConfiguration = .default, decoder: JSONDecoder = .init())
      /// Configuration for accessing Groq's API.
      /// - Parameters:
      ///   - apiKey: The API key for authenticating requests to Gemini.
      ///   - urlSessionConfiguration: The URLSession configuration to use for network requests. Defaults to `.default`.
      ///   - decoder: The JSON decoder used for decoding responses. Defaults to a new instance of `JSONDecoder`.
      case groq(apiKey: String, configuration: URLSessionConfiguration = .default, decoder: JSONDecoder = .init())
      /// Configuration for accessing DeepSeek''s API.
      /// - Parameters:
      ///   - apiKey: The API key for authenticating requests to Gemini.
      ///   - urlSessionConfiguration: The URLSession configuration to use for network requests. Defaults to `.default`.
      ///   - decoder: The JSON decoder used for decoding responses. Defaults to a new instance of `JSONDecoder`.
      case deepSeek(apiKey: String, configuration: URLSessionConfiguration = .default, decoder: JSONDecoder = .init())
      /// Configuration for accessing Groq's API.
      /// - Parameters:
      ///   - apiKey: The API key for authenticating requests to OpenRouter.
      ///   - urlSessionConfiguration: The URLSession configuration to use for network requests. Defaults to `.default`.
      ///   - decoder: The JSON decoder used for decoding responses. Defaults to a new instance of `JSONDecoder`.
      ///   - extraHeaders: Optional. Site URL  and title for rankings on openrouter.ai
      case openRouter(apiKey: String, configuration: URLSessionConfiguration = .default, decoder: JSONDecoder = .init(), extraHeaders: [String: String]? = nil)
      /// Configuration for accessing Ollama models using OpenAI endpoints compatibility.
      /// - Parameters:
      ///   - url: The local host URL. e.g "http://localhost:11434"
      case ollama(url: String)
   }
   
   /// Configuration for accessing Anthropic's API.
   /// - Parameters:
   ///   - apiKey: The API key for authenticating requests to Anthropic.
   ///   - configuration: The URLSession configuration to use for network requests. Defaults to `.default`.
   ///   - betaHeaders: An array of headers for Anthropic's beta features.
   case anthropic(apiKey: String, configuration: URLSessionConfiguration = .default, betaHeaders: [String]? = nil)
}

/// Defines the interface for a service that interacts with Large Language Models (LLMs).
public protocol PolyAIService {

   /// Initializes a new instance with the specified configurations for LLM providers.
   /// - Parameters:
   ///  - configurations: An array of `LLMConfiguration` items, each specifying settings for a different LLM provider.
   ///  - debugEnabled: Logs requests if `true`
   init(configurations: [LLMConfiguration], debugEnabled: Bool)
   
   // MARK: Message

   /// Creates a message to an LLM based on the provided parameters.
   ///
   /// - Parameter parameter: The LLMParameter defining the LLM request details.
   /// - Returns: A response conforming to `LLMMessageResponse`.
   /// - Throws: An error if the message creation fails.
   func createMessage(
      _ parameter: LLMParameter)
   async throws -> LLMMessageResponse
   
   /// Streams messages rom an LLM  based on the provided parameters.
   ///
   /// - Parameter parameter: The LLMParameter defining the LLM request details.
   /// - Returns: An asynchronous stream of responses conforming to `LLMMessageStreamResponse`.
   /// - Throws: An error if the streaming operation fails.
   func streamMessage(
      _ parameter: LLMParameter)
   async throws -> AsyncThrowingStream<LLMMessageStreamResponse, Error>
}

extension LLMConfiguration {
   
   public var rawValue: String {
      switch self {
      case .openAI(let openAICompatible):
         switch openAICompatible {
         case .api: "OpenAI"
         case .azure: "Azure"
         case .aiProxy: "AiProxy"
         case .gemini: "Gemini"
         case .groq: "Groq"
         case .ollama: "Ollama"
         case .openRouter: "OpenRouter"
         case .deepSeek: "DeepSeek"
         }
      case .anthropic: "Anthropic"
      }
   }
}
