//
//  ApiKeysIntroView.swift
//  PolyAIExample
//
//  Created by James Rochabrun on 4/14/24.
//

import SwiftUI
import PolyAI

struct ApiKeyIntroView: View {
   
   @State private var anthropicAPIKey = ""
   @State private var openAIAPIKey = ""
   @State private var geminiAPIKey = ""
   @State private var ollamaLocalHostURL = ""
   @State private var anthropicConfigAdded: Bool = false
   @State private var openAIConfigAdded: Bool = false
   @State private var ollamaConfigAdded: Bool = false
   @State private var geminiConfigAdded: Bool = false

   @State private var configurations: [LLMConfiguration] = []
   
   private var canNotContinue: Bool {
      configurations.isEmpty
   }

   var body: some View {
      NavigationStack {
         VStack {
            Spacer()
            VStack(spacing: 24) {
               LLMConfigurationView(
                  provider: "Anthropic",
                  configurationAdded: $anthropicConfigAdded,
                  apiKey: $anthropicAPIKey) {
                     configurations.append(.anthropic(apiKey: anthropicAPIKey))
                  }
               LLMConfigurationView(
                  provider: "OpenAI",
                  configurationAdded: $openAIConfigAdded,
                  apiKey: $openAIAPIKey) {
                     configurations.append(.openAI(.api(key: openAIAPIKey)))
                  }
               LLMConfigurationView(
                  provider: "Gemini",
                  configurationAdded: $geminiConfigAdded,
                  apiKey: $geminiAPIKey) {
                     configurations.append(.gemini(apiKey: geminiAPIKey))
                  }
               LLMConfigurationView(
                  provider: "Ollama",
                  configurationAdded: $ollamaConfigAdded,
                  apiKey: $ollamaLocalHostURL) {
                     configurations.append(.ollama(url: ollamaLocalHostURL))
                  }
            }
            .buttonStyle(.bordered)
            .padding()
            .textFieldStyle(.roundedBorder)
            NavigationLink(destination: OptionsListView(service: PolyAIServiceFactory.serviceWith(configurations))) {
               Text("Continue")
                  .padding()
                  .padding(.horizontal, 48)
                  .foregroundColor(.white)
                  .background(
                     Capsule()
                        .foregroundColor(canNotContinue ? .gray.opacity(0.2) : .pink))
            }
            .disabled(canNotContinue)
            Spacer()
         }
         .padding()
         .navigationTitle("Enter API Keys or URL's")
      }
   }
}

struct LLMConfigurationView: View {
   
   let provider: String
   @Binding var configurationAdded: Bool
   @Binding var apiKey: String
   let addConfig: () -> Void
   
   var body: some View {
      VStack(alignment: .leading) {
         HStack {
            TextField("Enter \(provider) API Key or URL", text: $apiKey)
            Button {
               addConfig()
               configurationAdded = true
            } label: {
               Image(systemName: "plus")
            }
            .disabled(apiKey.isEmpty)
         }
         Text("\(provider) added to PolyAI 🚀")
            .opacity(configurationAdded ? 1 : 0)
      }
   }
}

#Preview {
   ApiKeyIntroView()
}
