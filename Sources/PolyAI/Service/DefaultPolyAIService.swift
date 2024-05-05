//
//  DefaultPolyAIService.swift
//
//
//  Created by James Rochabrun on 4/6/24.
//

import Foundation
import GoogleGenerativeAI
import SwiftAnthropic
import SwiftOpenAI

// MARK: Error

enum PolyAIError: Error {
   case missingLLMConfiguration(String)
}

// MARK: Gemini specific

extension GenerativeModel {
   public struct Configuration {
      let apiKey: String
   }
}

struct DefaultPolyAIService: PolyAIService {
   
   private var openAIService: OpenAIService?
   private var anthropicService: AnthropicService?
   private var gemini: GenerativeModel.Configuration?
   
   init(configurations: [LLMConfiguration])
   {
      for configuration in configurations {
         switch configuration {
         case .openAI(let configuration):
            switch configuration {
            case .api(let key, let organizationID, let configuration, let decoder):
               openAIService = OpenAIServiceFactory.service(apiKey: key, organizationID: organizationID, configuration: configuration, decoder: decoder)
           
            case .azure(let azureConfiguration, let urlSessionConfiguration, let decoder):
               openAIService = OpenAIServiceFactory.service(azureConfiguration: azureConfiguration, urlSessionConfiguration: urlSessionConfiguration, decoder: decoder)
          
            case .aiProxy(let aiproxyPartialKey, let aiproxyDeviceCheckBypass, let configuration, let decoder):
               openAIService = OpenAIServiceFactory.service(aiproxyPartialKey: aiproxyPartialKey, aiproxyDeviceCheckBypass: aiproxyDeviceCheckBypass, configuration: configuration, decoder: decoder)
            }
            
         case .anthropic(let apiKey, let configuration):
            anthropicService = AnthropicServiceFactory.service(apiKey: apiKey, configuration: configuration)
            
         case .gemini(let apiKey):
            gemini = .init(apiKey: apiKey)
         }
      }
   }
   
   // MARK: Message
   
   func createMessage(
      _ parameter: LLMParameter)
      async throws -> LLMMessageResponse
   {
      switch parameter {
      case .openAI(let model, let messages, let maxTokens):
         guard let openAIService else {
            throw PolyAIError.missingLLMConfiguration("You Must provide a valid configuration for the \(parameter.llmService) API")
         }
         let messageParams: [SwiftOpenAI.ChatCompletionParameters.Message] = messages.map { .init(role: .init(rawValue: $0.role) ?? .user, content: .text($0.content)) }
         let messageParameter = ChatCompletionParameters(messages: messageParams, model: model, maxTokens: maxTokens)
         return try await openAIService.startChat(parameters: messageParameter)
         
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
         let messageParameter = MessageParameter(model: model, messages: messageParams, maxTokens: maxTokens, system: systemMessage?.content, stream: false)
         return try await anthropicService.createMessage(messageParameter)
         
      case .gemini(let model, let messages, let maxTokens):
         guard let gemini else {
            throw PolyAIError.missingLLMConfiguration("You Must provide a valid configuration for the \(parameter.llmService) API")
         }
         let systemInstruction: ModelContent?
         if let systemMessage = messages.first(where: { message in
            message.role == "system"
         })?.content {
            systemInstruction = ModelContent(parts: [.text(systemMessage)])
         } else {
            systemInstruction = nil
         }
         let generativeModel = GenerativeModel(name: model, apiKey: gemini.apiKey, generationConfig: .init(GenerationConfig(maxOutputTokens: maxTokens)), systemInstruction: systemInstruction)
         let userMessage = messages.first { message in
            message.role == "user"
         }?.content ?? ""
         return try await generativeModel.generateContent(userMessage)
      }
   }
   
   func streamMessage(
      _ parameter: LLMParameter)
      async throws -> AsyncThrowingStream<LLMMessageStreamResponse, Error>
   {
      switch parameter {
      case .openAI(let model, let messages, let maxTokens):
         guard let openAIService else {
            throw PolyAIError.missingLLMConfiguration("You Must provide a valid configuration for the \(parameter.llmService) API")
         }
         let messageParams: [SwiftOpenAI.ChatCompletionParameters.Message] = messages.map { .init(role: .init(rawValue: $0.role) ?? .user, content: .text($0.content)) }
         let messageParameter = ChatCompletionParameters(messages: messageParams, model: model, maxTokens: maxTokens)
         
         
         let stream = try await openAIService.startStreamedChat(parameters: messageParameter)
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
         let messageParameter = MessageParameter(model: model, messages: messageParams, maxTokens: maxTokens, system: systemMessage?.content)
         let stream = try await anthropicService.streamMessage(messageParameter)
         return try mapToLLMMessageStreamResponse(stream: stream)
         
      case .gemini(let model, let messages, let maxTokens):
         guard let gemini else {
            throw PolyAIError.missingLLMConfiguration("You Must provide a valid configuration for the \(parameter.llmService) API")
         }
         let systemInstruction: ModelContent?
         if let systemMessage = messages.first(where: { message in
            message.role == "system"
         })?.content {
            systemInstruction = ModelContent(parts: [.text(systemMessage)])
         } else {
            systemInstruction = nil
         }
         let generativeModel = GenerativeModel(name: model, apiKey: gemini.apiKey, generationConfig: .init(GenerationConfig(maxOutputTokens: maxTokens)), systemInstruction: systemInstruction)
         let userMessage = messages.first { message in
            message.role == "user"
         }?.content ?? ""
         let stream = generativeModel.generateContentStream(userMessage)
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
