//
//  PolyAIService.swift
//
//
//  Created by James Rochabrun on 4/6/24.
//

import Foundation

public enum LLMConfiguration {
   case openAI(apiKey: String, organizationID: String? = nil, configuration: URLSessionConfiguration = .default, decoder: JSONDecoder = .init())
   case anthropic(apiKey: String, configuration: URLSessionConfiguration = .default)
}

public protocol PolyAIService {

   init(configurations: [LLMConfiguration])
   
   // MARK: Message

   func createMessage(
      _ parameter: LLMParameter)
   async throws -> LLMMessageResponse
   
   func streamMessage(
      _ parameter: LLMParameter)
   async throws -> AsyncThrowingStream<LLMMessageStreamResponse, Error>
}
