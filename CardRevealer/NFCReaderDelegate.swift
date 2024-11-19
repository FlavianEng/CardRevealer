import SwiftUI
import CoreNFC

@available(iOS 15.0, *)
class NFCReaderDelegate: NSObject, NFCNDEFReaderSessionDelegate {
    private var session: NFCNDEFReaderSession?

    var onMessageReceived: ((String) -> Void)?

    func beginScanning() {
        guard NFCNDEFReaderSession.readingAvailable else {
            print("NFC is not available")
            return
        }

        session = NFCNDEFReaderSession(
            delegate: self,
            queue: nil,
            invalidateAfterFirstRead: true
        )

        session?.alertMessage = "Hold your tag near the reader to discover all its naughty secrets. (RRrrr)"
        session?.begin()
        print("Scanning for NDEF tags...")
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("NFC tag detected")
        var tagContent = ""

        for message in messages {
            for record in message.records {
                if let payload = String(data: record.payload, encoding: .utf8) {
                    tagContent += payload
                }
            }
        }

        DispatchQueue.main.async {
            self.onMessageReceived?(tagContent)
        }
    }

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("Session invalidated: \(error.localizedDescription)")
        if let nfcError = error as? NFCReaderError {
            switch nfcError.code {
            case .readerSessionInvalidationErrorUserCanceled:
                print("User canceled the session.")
            case .readerSessionInvalidationErrorSessionTimeout:
                print("Session timed out.")
            default:
                print("Unknown NFC error: \(nfcError.code.rawValue)")
            }
        }

        self.session?.invalidate()
        self.session = nil
    }

    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("NFC Reader Session is now active.")
    }
}
