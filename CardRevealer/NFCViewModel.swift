import Foundation

class NFCViewModel: ObservableObject {
    @Published var scanMessage: String = "Nothing scanned yet, quite boring..."

    private let readerDelegate = NFCReaderDelegate()

    init() {
        readerDelegate.onMessageReceived = { [weak self] message in
            self?.scanMessage = message
        }
    }

    func startScanning() {
        readerDelegate.beginScanning()
    }
}
