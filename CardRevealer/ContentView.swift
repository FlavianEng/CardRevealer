import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NFCViewModel()

    var body: some View {
        VStack {
            Spacer()
            Text(viewModel.scanMessage)

            Spacer()
            Button("Start Scanning") {
                viewModel.startScanning()
            }
            .buttonStyle(.borderedProminent)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
