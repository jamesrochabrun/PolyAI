//
//  DefaultPolyAIService.swift
//
//
//  Created by James Rochabrun on 4/6/24.
//

import Foundation
import SwiftAnthropic
import SwiftOpenAI

// MARK: Error

enum PolyAIError: Error {
   case missingLLMConfiguration(String)
}

struct DefaultPolyAIService: PolyAIService {
   
   // OpenAI compatible
   private var openAIService: OpenAIService?
   private var azureOpenAIService: OpenAIService?
   private var aiProxyOpenAIService: OpenAIService?
   private var geminiService: OpenAIService?
   private var groqService: OpenAIService?
   private var deepSeekService: OpenAIService?
   private var openRouterService: OpenAIService?
   private var ollamaOpenAIServiceCompatible: OpenAIService?
   
   // Anthropic
   private var anthropicService: AnthropicService?
   
   init(configurations: [LLMConfiguration],
        debugEnabled: Bool = false)
   {
      for configuration in configurations {
         switch configuration {
         case .openAI(let configuration):
            switch configuration {
            case .api(let key, let organizationID, let configuration, let decoder):
               openAIService = OpenAIServiceFactory.service(apiKey: key, organizationID: organizationID, configuration: configuration, decoder: decoder, debugEnabled: debugEnabled)
               
            case .azure(let azureConfiguration, let urlSessionConfiguration, let decoder):
               azureOpenAIService = OpenAIServiceFactory.service(azureConfiguration: azureConfiguration, urlSessionConfiguration: urlSessionConfiguration, decoder: decoder, debugEnabled: debugEnabled)
               
            case .aiProxy(let aiproxyPartialKey, let aiproxyClientID):
               aiProxyOpenAIService = OpenAIServiceFactory.service(aiproxyPartialKey: aiproxyPartialKey, aiproxyClientID: aiproxyClientID, debugEnabled: debugEnabled)
               
            case .gemini(let apiKey, _, _):
               let baseURL = "https://generativelanguage.googleapis.com"
               let version = "v1beta"
               
               let service = OpenAIServiceFactory.service(
                  apiKey: apiKey,
                  overrideBaseURL: baseURL,
                  overrideVersion: version,
                  debugEnabled: debugEnabled)
               geminiService = service
               
            case .groq(apiKey: let apiKey, _, _):
               groqService = OpenAIServiceFactory.service(
                  apiKey: apiKey,
                  overrideBaseURL: "https://api.groq.com/",
                  proxyPath: "openai",
                  debugEnabled: debugEnabled)
               
            case .deepSeek(apiKey: let apiKey, configuration: _, decoder: _):
               deepSeekService = OpenAIServiceFactory.service(
                  apiKey: apiKey,
                  overrideBaseURL: "https://api.deepseek.com",
                  debugEnabled: debugEnabled)
               
            case .openRouter(apiKey: let apiKey, _, _, let extraHeaders):
               openRouterService = OpenAIServiceFactory.service(
                  apiKey: apiKey,
                  overrideBaseURL: "https://openrouter.ai",
                  proxyPath: "api",
                  extraHeaders: extraHeaders,
                  debugEnabled: debugEnabled)
               
            case .ollama(let url):
               ollamaOpenAIServiceCompatible = OpenAIServiceFactory.service(baseURL: url, debugEnabled: debugEnabled)
            }
            
         case .anthropic(let apiKey, let configuration, let betaHeaders):
            anthropicService = AnthropicServiceFactory.service(
               apiKey: apiKey,
               betaHeaders: betaHeaders,
               configuration: configuration,
               debugEnabled: debugEnabled)
            
         }
      }
   }
   
   // MARK: Message
   
   func createMessage(
      _ parameter: LLMParameter)
   async throws -> LLMMessageResponse
   {
      switch parameter {
      case .groq(let model, let messages, let maxTokens),
            .gemini(let model, let messages, let maxTokens),
            .deepSeek(let model, let messages, let maxTokens),
            .openRouter(let model, let messages, let maxTokens):
         
         let messageParams: [SwiftOpenAI.ChatCompletionParameters.Message] = messages.map { .init(role: .init(rawValue: $0.role) ?? .user, content: .text($0.content)) }
         let messageParameter = ChatCompletionParameters(messages: messageParams, model: .custom(model), maxTokens: maxTokens)
         let service = try openAIService(for: parameter)
         return try await service.startChat(parameters: messageParameter)
         
      case .openAI(let model, let messages, let maxTokens),
            .azure(let model, let messages, let maxTokens),
            .aiProxy(let model, let messages, let maxTokens):
         
         let messageParams: [SwiftOpenAI.ChatCompletionParameters.Message] = messages.map { .init(role: .init(rawValue: $0.role) ?? .user, content: .text($0.content)) }
         let messageParameter = ChatCompletionParameters(messages: messageParams, model: model, maxTokens: maxTokens)
         let service = try openAIService(for: parameter)
         return try await service.startChat(parameters: messageParameter)
         
      case .anthropic(let model, let messages, let maxTokens):
         
         guard let anthropicService else {
            throw PolyAIError.missingLLMConfiguration("You Must provide a valid configuration for the \(parameter.llmService) API")
         }
         // Remove all system messages as Anthropic uses the system message as a parameter and not as part of the messages array.
         let messageParams: [SwiftAnthropic.MessageParameter.Message] = messages.compactMap { message in
            guard message.role != "system" else {
               return nil  // Skip "system" roles
            }
            return MessageParameter.Message(
               role: SwiftAnthropic.MessageParameter.Message.Role(rawValue: message.role) ?? .user,
               content: .text(message.content)
            )
         }
         let systemMessage  = messages.first { $0.role == "system" }
         let messageParameter = MessageParameter(model: model, messages: messageParams, maxTokens: maxTokens, system: .text(systemMessage?.content ?? ""), stream: false)
         return try await anthropicService.createMessage(messageParameter)
         
      case .ollama(let model, let messages, let maxTokens):
         let messageParams: [SwiftOpenAI.ChatCompletionParameters.Message] = messages.map { .init(role: .init(rawValue: $0.role) ?? .user, content: .text($0.content)) }
         let messageParameter = ChatCompletionParameters(messages: messageParams, model: .custom(model), maxTokens: maxTokens)
         let service = try openAIService(for: parameter)
         return try await service.startChat(parameters: messageParameter)
      }
   }
   
   func streamMessage(
      _ parameter: LLMParameter)
   async throws -> AsyncThrowingStream<LLMMessageStreamResponse, Error>
   {
      switch parameter {
      case .groq(let model, let messages, let maxTokens),
            .gemini(let model, let messages, let maxTokens),
            .deepSeek(let model, let messages, let maxTokens),
            .openRouter(let model, let messages, let maxTokens):
         
         let messageParams: [SwiftOpenAI.ChatCompletionParameters.Message] = messages.map { .init(role: .init(rawValue: $0.role) ?? .user, content: .text($0.content)) }
         let messageParameter = ChatCompletionParameters(messages: messageParams, model: .custom(model), maxTokens: maxTokens)
         let service = try openAIService(for: parameter)
         let stream = try await service.startStreamedChat(parameters: messageParameter)
         return try mapToLLMMessageStreamResponse(stream: stream)
         
      case .openAI(let model, let messages, let maxTokens),
            .azure(let model, let messages, let maxTokens),
            .aiProxy(let model, let messages, let maxTokens):
         
         let messageParams: [SwiftOpenAI.ChatCompletionParameters.Message] = messages.map { .init(role: .init(rawValue: $0.role) ?? .user, content: .text($0.content)) }
         let messageParameter = ChatCompletionParameters(messages: messageParams, model: model, maxTokens: maxTokens)
         let service = try openAIService(for: parameter)
         let stream = try await service.startStreamedChat(parameters: messageParameter)
         return try mapToLLMMessageStreamResponse(stream: stream)
         
      case .anthropic(let model, let messages, let maxTokens):
         guard let anthropicService else {
            throw PolyAIError.missingLLMConfiguration("You Must provide a valid configuration for the \(parameter.llmService) API")
         }
         // Remove all system messages as Anthropic uses the system message as a parameter and not as part of the messages array.
         let messageParams: [SwiftAnthropic.MessageParameter.Message] = messages.compactMap { message in
            guard message.role != "system" else {
               return nil  // Skip "system" roles
            }
            return MessageParameter.Message(
               role: SwiftAnthropic.MessageParameter.Message.Role(rawValue: message.role) ?? .user,
               content: .text(message.content)
            )
         }
         let systemMessage  = messages.first { $0.role == "system" }
         let messageParameter = MessageParameter(model: model, messages: messageParams, maxTokens: maxTokens, system: .text(systemMessage?.content ?? ""))
         let stream = try await anthropicService.streamMessage(messageParameter)
         return try mapToLLMMessageStreamResponse(stream: stream)
         
      case .ollama(let model, let messages, let maxTokens):
         let messageParams: [SwiftOpenAI.ChatCompletionParameters.Message] = messages.map { .init(role: .init(rawValue: $0.role) ?? .user, content: .text($0.content)) }
         let messageParameter = ChatCompletionParameters(messages: messageParams, model: .custom(model), maxTokens: maxTokens)
         let service = try openAIService(for: parameter)
         let stream = try await service.startStreamedChat(parameters: messageParameter)
         return try mapToLLMMessageStreamResponse(stream: stream)
      }
   }
   
   private func mapToLLMMessageStreamResponse<T: LLMMessageStreamResponse>(stream: AsyncThrowingStream<T, Error>)
   throws -> AsyncThrowingStream<LLMMessageStreamResponse, Error>
   {
      let mappedStream = AsyncThrowingStream<LLMMessageStreamResponse, Error> { continuation in
         Task {
            do {
               for try await chunk in stream {
                  continuation.yield(chunk)
               }
               continuation.finish()
            } catch {
               continuation.finish(throwing: error)
            }
         }
      }
      return mappedStream
   }
}

extension DefaultPolyAIService {
   
   private func openAIService(
      for parameter: LLMParameter)
   throws -> OpenAIService
   {
      switch parameter {
      case .groq:
         guard let service = groqService else {
            throw PolyAIError.missingLLMConfiguration("You Must provide a valid configuration for the \(parameter.llmService) API")
         }
         return service
         
      case .gemini:
         guard let service = geminiService else {
            throw PolyAIError.missingLLMConfiguration("You Must provide a valid configuration for the \(parameter.llmService) API")
         }
         return service
         
      case .openAI:
         guard let service = openAIService else {
            throw PolyAIError.missingLLMConfiguration("You Must provide a valid configuration for the \(parameter.llmService) API")
         }
         return service
         
      case .azure:
         guard let service = azureOpenAIService else {
            throw PolyAIError.missingLLMConfiguration("You Must provide a valid configuration for the \(parameter.llmService) API")
         }
         return service
         
      case .aiProxy:
         guard let service = aiProxyOpenAIService else {
            throw PolyAIError.missingLLMConfiguration("You Must provide a valid configuration for the \(parameter.llmService) API")
         }
         return service
         
      case .ollama:
         guard let service = ollamaOpenAIServiceCompatible else {
            throw PolyAIError.missingLLMConfiguration("You Must provide a valid configuration for the \(parameter.llmService) API")
         }
         return service
         
      case .deepSeek(model: let model, messages: let messages, maxTokens: let maxTokens):
         guard let service = deepSeekService else {
            throw PolyAIError.missingLLMConfiguration("You Must provide a valid configuration for the \(parameter.llmService) API")
         }
         return service
      case .openRouter(model: let model, messages: let messages, maxTokens: let maxTokens):
         guard let service = openRouterService else {
            throw PolyAIError.missingLLMConfiguration("You Must provide a valid configuration for the \(parameter.llmService) API")
         }
         return service
      case .anthropic:
         throw PolyAIError.missingLLMConfiguration("Anthropic does not use OpenAIService")
      }
   }
}
