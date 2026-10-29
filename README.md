# QTech-App
A secure message application for iOS using Swift

QTech is a local-first encrypted messaging application developed using Swift and SwiftUI as part of an iOS technical assessment.

The application allows users to send and display text messages and image attachments, with content encrypted before being saved locally.

**Important:** This is a single-device messaging prototype, not a network-based or end-to-end encrypted messaging service.

## 1. How I Built the Application

I used a lightweight MVVM architecture to separate the user interface, messaging operations, encryption, and persistent storage.

I started by creating the SwiftData message model and then implemented the encryption and key-management services. After verifying encryption, I built the messaging interface and added encrypted image attachments.

### Technologies

- **Swift:** Programming language
- **SwiftUI:** User interface
- **SwiftData:** Local message persistence
- **CryptoKit:** AES-GCM authenticated encryption
- **Keychain Services:** Secure symmetric-key storage
- **PhotosUI:** Photo selection
- **FileManager:** Encrypted attachment storage

### Architecture

**Models**
- `MessageItem.swift` — Stores message information, encrypted text, timestamps, and attachment metadata.

**Views**
- `ChatView.swift` — Main conversation screen.
- `AttachmentPreviewView.swift` — Displays decrypted image attachments.

**ViewModels**
- `ChatViewModel.swift` — Handles sending messages, validation, encryption, decryption, and persistence.

**Services**
- `EncryptionService.swift` — Encrypts and decrypts data.
- `KeychainService.swift` — Generates and retrieves the encryption key.
- `AttachmentStorageService.swift` — Saves and retrieves encrypted attachment files.

## 2. Dependencies and Setup

### Requirements

- macOS with Xcode
- iOS 17+ SDK and compatible simulator
- No third-party dependencies
- No API keys or backend configuration

### Installation

1. Clone the repository:

```bash
git clone https://github.com/Mura0083/QTech-App.git
```

2. Open the `.xcodeproj` file in Xcode.
3. Select an iPhone simulator.
4. Build and run using `Cmd + R`.
5. Send a text message or select an image using the attachment button.

## 3. Application Overview

QTech provides a simple chat interface where users can compose messages, attach images, and view their locally saved conversation.

Messages are stored using SwiftData, while encrypted image files are saved separately in the application's private storage.

Messages and images remain accessible after restarting the application.

## 4. Encryption Approach

QTech uses **AES-GCM authenticated encryption** through Apple's CryptoKit framework.

### Text Encryption

1. The user writes a message.
2. The text is converted into UTF-8 data.
3. CryptoKit encrypts the data using AES-GCM.
4. The encrypted bytes are saved in SwiftData.
5. When displaying the message, the data is decrypted and converted back into text.

### Attachment Encryption

1. The user selects an image through PhotosPicker.
2. The image is converted to JPEG data.
3. The bytes are encrypted using AES-GCM.
4. The encrypted file is saved in Application Support.
5. The application decrypts the file to display its image preview.

### Key Management

The application generates a 256-bit symmetric key and stores it using Apple's Keychain Services.

The existing key is retrieved on subsequent launches so previously encrypted messages remain readable.

The key is not hardcoded in the source code or stored alongside the encrypted messages.

AES-GCM also provides authentication, allowing the app to detect invalid or modified ciphertext.

### Security Limitations

This implementation provides encryption at rest on a single device. It does not implement network communication, multi-device key exchange, user identity verification, or end-to-end encryption between participants.

Message metadata is not fully encrypted, and the application has access to decrypted content when displaying it.

The application has not undergone an independent security audit.

## 5. Features and Creativity

### Implemented Features

- Send and display text messages
- Encrypted local message storage
- Select and send image attachments
- Encrypted image file storage
- Inline decrypted image previews
- Persistent conversation history
- Message timestamps
- Incoming/outgoing bubble styling
- Empty conversation state
- Input validation
- Basic error handling

### Creative Design Decisions

I prioritized a familiar instant-messaging interface with distinct message bubbles, timestamps, a multiline message composer, and quick image selection.

I also separated the encryption and file-storage functionality into dedicated services so that the implementation remains organized and extensible.

Given the assessment's time constraints, I chose to prioritize a complete local messaging experience rather than introducing an unfinished backend.

### Known Limitations

- No real-time communication between devices
- No authentication or user accounts
- No push notifications or delivery receipts
- Image attachments only
- No multiple-conversation support
- No automated test suite or formal security audit

## Testing and Verification

The following manual checks were completed:

- [x] Text messages send and display correctly
- [x] Empty text messages are rejected
- [x] Text messages persist after application relaunch
- [x] Image attachments display correctly
- [x] Multiple images can be attached
- [x] Encrypted images persist after application relaunch
- [x] Encryption and decryption round-trip test passed
- [x] Keychain key retrieval test passed

## Conclusion

QTech demonstrates my ability to build a functional SwiftUI application using local persistence, authenticated encryption, secure key management, and a modular architecture.

The project was designed and implemented within a limited technical-assessment timeframe, emphasizing working functionality, code organization, and clearly documented security boundaries.
