//
//  MessageDemoObservabble.swift
//  PolyAIExample
//
//  Created by James Rochabrun on 4/14/24.
//

import Foundation
import PolyAI
import SwiftUI

@MainActor
@Observable class MessageDemoObservable {
   
   let service: PolyAIService
   var message: String = ""
   var errorMessage: String = ""
   var isLoading = false
   
   init(service: PolyAIService) {
      self.service = service
   }
   
   func createMessage(
      parameters: LLMParameter) async throws
   {
      task = Task {
         do {
            isLoading = true
            let message = try await service.createMessage(parameters)
            isLoading = false
            self.message = message.contentDescription
         } catch {
            self.errorMessage = "\(error)"
         }
      }
   }
   
   func streamMessage(
      parameters: LLMParameter) async throws
   {
      task = Task {
         do {
            isLoading = true
            let stream = try await service.streamMessage(parameters)
            isLoading = false
            for try await result in stream {
               self.message += result.content ?? ""
            }
         } catch {
            self.errorMessage = "\(error)"
         }
      }
   }
   
   func cancelStream() {
      task?.cancel()
   }
   
   func clearMessage() {
      message = ""
   }
   
   // MARK: Private
   
   private var task: Task<Void, Never>? = nil
   
}
