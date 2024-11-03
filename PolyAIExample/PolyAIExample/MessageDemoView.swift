//
//  MessageDemoView.swift
//  PolyAIExample
//
//  Created by James Rochabrun on 4/14/24.
//

import Foundation
import PhotosUI
import PolyAI
import SwiftUI

@MainActor
struct MessageDemoView: View {
   
   let observable: MessageDemoObservable
   @State private var prompt = ""
   @State private var selectedItems: [PhotosPickerItem] = []
   @State private var selectedImages: [Image] = []
   @State private var selectedImagesEncoded: [String] = []
   @State private var selectedSegment: LLM = .anthropic

   enum LLM: String, Identifiable, CaseIterable {
      case openAI
      case anthropic
      case gemini
      case llama3
      
      var id: String { rawValue }
   }
   
   var body: some View {
      ScrollView {
         VStack {
            picker
            Text(observable.errorMessage)
               .foregroundColor(.red)
            messageView
         }
         .padding()
      }
      .overlay(
         Group {
            if observable.isLoading {
               ProgressView()
            } else {
               EmptyView()
            }
         }
      ).safeAreaInset(edge: .bottom) {
         VStack(spacing: 0) {
            selectedImagesView
            textArea
         }
      }
   }
   
   var textArea: some View {
      HStack(spacing: 4) {
         TextField("Enter prompt", text: $prompt, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .padding()
         photoPicker
         Button {
            Task {
               let parameters: LLMParameter
               switch selectedSegment {
               case .openAI:
                  parameters = .openAI(
                     model: .o1Preview,
                     messages: [
                        .init(role: .user, content: prompt)
                     ])
               case .anthropic:
                  parameters = .anthropic(
                     model: .claude3Sonnet,
                     messages: [
                        .init(role: .user, content: prompt)
                     ],
                     maxTokens: 1024)
               case .gemini:
                  parameters = .gemini(
                     model: "gemini-1.5-pro-latest", messages: [
                        .init(role: .user, content: prompt)
                  ], maxTokens: 2000)
               case .llama3:
                  parameters = .ollama(
                     model: "llama3",
                     messages: [
                        .init(role: .user, content: prompt)
                     ],
                     maxTokens: 1000)
               }
               try await observable.streamMessage(parameters: parameters)
            }
         } label: {
            Image(systemName: "paperplane")
         }
         .buttonStyle(.bordered)
      }
      .padding()
   }
   
   var picker: some View {
      Picker("Options", selection: $selectedSegment) {
         ForEach(LLM.allCases) { llm in
            Text(llm.rawValue).tag(llm)
         }
      }
      .pickerStyle(SegmentedPickerStyle())
      .padding()
   }
   
   var messageView: some View {
      VStack(spacing: 24) {
         HStack {
            Button("Cancel") {
               observable.cancelStream()
            }
            Button("Clear Message") {
               observable.clearMessage()
            }
         }
         Text(observable.message)
      }
      .buttonStyle(.bordered)
   }
   
   var photoPicker: some View {
      PhotosPicker(selection: $selectedItems, matching: .images) {
         Image(systemName: "photo")
      }
      .onChange(of: selectedItems) {
         Task {
            selectedImages.removeAll()
            for item in selectedItems {
               
               if let data = try? await item.loadTransferable(type: Data.self) {
                  if let uiImage = UIImage(data: data), let resizedImageData = uiImage.jpegData(compressionQuality: 0.7) {
                      // Make sure the resized image is below the size limit
                     // This is needed as Claude allows a max of 5Mb size per image.
                      if resizedImageData.count < 5_242_880 { // 5 MB in bytes
                          let base64String = resizedImageData.base64EncodedString()
                          selectedImagesEncoded.append(base64String)
                          let image = Image(uiImage: UIImage(data: resizedImageData)!)
                          selectedImages.append(image)
                      } else {
                          // Handle the error - maybe resize to an even smaller size or show an error message to the user
                      }
                  }
               }
            }
         }
      }
   }
   
   var selectedImagesView: some View {
      HStack(spacing: 0) {
         ForEach(0..<selectedImages.count, id: \.self) { i in
            selectedImages[i]
               .resizable()
               .frame(width: 60, height: 60)
               .clipShape(RoundedRectangle(cornerRadius: 12))
               .padding(4)
         }
      }
   }
}
