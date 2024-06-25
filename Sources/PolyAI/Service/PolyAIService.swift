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

   case openAI(OpenAI)
   
   public enum OpenAI {
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
      ///   - aiproxyDeviceCheckBypass: The bypass token that is provided in the 'API Keys' section of the AIProxy dashboard.
      ///   - configuration: The URLSession configuration to use for network requests. Defaults to `.default`.
      ///   - decoder: The JSON decoder used for decoding responses. Defaults to a new instance of `JSONDecoder`.
      case aiProxy(aiproxyPartialKey: String, aiproxyDeviceCheckBypass: String? = nil, configuration: URLSessionConfiguration = .default, decoder: JSONDecoder = .init())
   }
   
   /// Configuration for accessing Anthropic's API.
   /// - Parameters:
   ///   - apiKey: The API key for authenticating requests to Anthropic.
   ///   - configuration: The URLSession configuration to use for network requests. Defaults to `.default`.
   case anthropic(apiKey: String, configuration: URLSessionConfiguration = .default)
   
   /// Configuration for accessing Gemini's API.
   /// - Parameters:
   ///   - apiKey: The API key for authenticating requests to Gemini.
   case gemini(apiKey: String)
   
   /// Configuration for accessing Ollama models using OpenAI endpoints compatibility.
   /// - Parameters:
   ///   - url: The local host URL. e.g "http://localhost:11434"
   case ollama(url: String)
}

/// Defines the interface for a service that interacts with Large Language Models (LLMs).
public protocol PolyAIService {

   /// Initializes a new instance with the specified configurations for LLM providers.
   /// - Parameter configurations: An array of `LLMConfiguration` items, each specifying settings for a different LLM provider.
   init(configurations: [LLMConfiguration])
   
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
