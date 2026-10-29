//
//  AttachmentPreviewsView.swift
//  QTech
//
//  Created by Armand on 2026-10-29.
//

import SwiftUI

struct AttachmentPreviewView: View {
    
    let message: MessageItem
    let viewModel: ChatViewModel
    
    @State private var image: UIImage?
    @State private var finishedLoading = false
    
    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 230, maxHeight: 260)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
            } else if finishedLoading {
                Label(
                    "Image unavailable",
                    systemImage: "exclamationmark.triangle"
                )
                .font(.caption)
            } else {
                ProgressView()
            }
        }
        .task(id: message.id) {
            image = viewModel.decryptedImage(for: message)
            finishedLoading = true
        }
    }
}
