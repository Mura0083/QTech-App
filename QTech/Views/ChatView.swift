//
//  ChatView.swift
//  QTech
//
//  Created by Armand on 2026-10-29.
//

import SwiftUI
import SwiftData
import PhotosUI

struct ChatView: View {
    
    @Environment(\.modelContext)
    private var modelContext
    
    @Query(sort: \MessageItem.createdAt, order: .forward)
    private var messages: [MessageItem]
    
    @State private var viewModel = ChatViewModel()
    @State private var messageText = ""
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var isSendingPhoto = false
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 10) {
                if messages.isEmpty {
                    ContentUnavailableView(
                        "No Messages",
                        systemImage: "bubble.left.and.bubble.right",
                        description: Text("Send your first secure message.")
                    )
                    .frame(maxHeight: .infinity)
                } else {
                    List(messages) {message in
                        HStack {
                            if message.isOutgoing {Spacer(minLength: 50)}
                            
                            VStack(alignment: .leading, spacing: 6) {
                                if let text = viewModel.decryptedText(for: message) {
                                    Text(text)
                                }
                                
                                if message.attachmentPath != nil {
                                    AttachmentPreviewView(
                                        message: message,
                                        viewModel: viewModel
                                    )
                                }
                                
                                Text(message.createdAt, format: .dateTime.hour().minute())
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(12)
                            .background(
                                message.isOutgoing ? Color.blue.opacity(0.18) : Color.gray.opacity(0.15),
                                in: RoundedRectangle(cornerRadius: 16)
                            )
                            
                            if !message.isOutgoing {
                                Spacer(minLength: 50)
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                }
                
                Divider()
                
                HStack(spacing: 12) {
                    
                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .images
                    ) {
                        Image(systemName: "paperclip")
                            .font(.title2)
                    }
                    .disabled(isSendingPhoto)
                    
                    TextField("Message", text: $messageText, axis: .vertical)
                        
                        .lineLimit(1...4)
                        .textFieldStyle(.roundedBorder)
                    
                    Button {
                        sendMessage()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                    }
                    .disabled(
                        messageText.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty
                    )
                }
                .padding()
            }
            .navigationTitle("QT Chat")
            .onChange(of: selectedPhoto) { _, newPhoto in
                guard let newPhoto else {
                    return
                }
                
                Task {
                    await sendSelectedPhoto(newPhoto)
                }
            }
            .alert("Message Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func sendMessage() {
        do {
            try viewModel.sendText(
                messageText,
                context: modelContext
            )

            messageText = ""
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    @MainActor
    private func sendSelectedPhoto(_ item: PhotosPickerItem) async {
        isSendingPhoto = true
        
        defer {
            isSendingPhoto = false
            selectedPhoto = nil
        }
        
        do {
            guard let data = try await item.loadTransferable(
                type: Data.self
            ),
            let image = UIImage(data: data),
            let jpegData = image.jpegData(
                compressionQuality: 0.75
            ) else {
                throw AttachmentError.invalidImage
            }

            try viewModel.sendImage(
                jpegData,
                context: modelContext
            )

        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        
    }
}
