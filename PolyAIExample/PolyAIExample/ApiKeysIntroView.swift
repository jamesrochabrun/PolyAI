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
   @State private var anthropicConfigAdded: Bool = false
   @State private var openAIConfigAdded: Bool = false

   @State private var configurations: [LLMConfiguration] = []
   
   private var canNotContinue: Bool {
      configurations.isEmpty
   }

   var body: some View {
      NavigationStack {
         VStack {
            Spacer()
            VStack(spacing: 24) {
               VStack(alignment: .leading) {
                  HStack {
                     TextField("Enter Anthropic API Key", text: $anthropicAPIKey)
                     Button {
                        configurations.append(.anthropic(apiKey: anthropicAPIKey))
                        anthropicConfigAdded = true
                     } label: {
                        Image(systemName: "plus")
                     }
                     .disabled(anthropicAPIKey.isEmpty)
                  }
                  Text("Anthropic added to PolyAI 🚀")
                     .opacity(anthropicConfigAdded ? 1 : 0)
               }
               VStack(alignment: .leading) {
                  HStack {
                     TextField("Enter OpenAI API Key", text: $openAIAPIKey)
                     Button {
                        configurations.append(.openAI(.api(key: openAIAPIKey)))
                        openAIConfigAdded = true
                     } label: {
                        Image(systemName: "plus")
                     }
                     .disabled(openAIAPIKey.isEmpty)
                  }
                  Text("OpenAI added to PolyAI 🚀")
                     .opacity(openAIConfigAdded ? 1 : 0)
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
         .navigationTitle("Enter API Keys")
      }
   }
}

#Preview {
   ApiKeyIntroView()
}
