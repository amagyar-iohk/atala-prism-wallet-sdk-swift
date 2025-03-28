import SwiftUI

protocol SetupEdgeAgentViewModel: ObservableObject {
    var status: String { get }
    var error: String? { get }
    var oobUrl: String { get set }
    func start() async throws
    func parseOOBMessage() async throws
    func updateKeyList() async throws
    func startMessageStream()
    func startIssueCredentialProtocol() async throws
}

struct SetupEdgeAgentView<ViewModel: SetupEdgeAgentViewModel>: View {

    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: 16) {
            if !viewModel.status.isEmpty {
                Text("Agent Status")
                Text(viewModel.status)
            }

            Button("Start Prism Agent") {
                Task {
                    try await viewModel.start()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .tint(.white)
            .clipShape(Capsule(style: .continuous))

            VStack(spacing: 16) {
                TextField(text: $viewModel.oobUrl) {
                    Text("Input URL")
                }

                Button("Create a connection") {
                    Task {
                        try await viewModel.parseOOBMessage()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .tint(.white)
                .clipShape(Capsule(style: .continuous))
                .disabled(viewModel.oobUrl.isEmpty ? true : false)
            }

            if let error = viewModel.error {
                Text("Error").foregroundColor(.red)
                Text(error)
            }

            Button("Start message stream") {
                Task {
                    try await viewModel.startMessageStream()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .tint(.white)
            .clipShape(Capsule(style: .continuous))

            Button("Start issue credential protocol") {
                Task {
                    try await viewModel.startIssueCredentialProtocol()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .tint(.white)
            .clipShape(Capsule(style: .continuous))

            if let error = viewModel.error {
                Text("Error").foregroundColor(.red)
                Text(error)
            }
        }.padding()
    }
}

struct SetupEdgeAgentView_Previews: PreviewProvider {
    static var previews: some View {
        SetupEdgeAgentView(viewModel: ViewModel())
    }
}

private class ViewModel: SetupEdgeAgentViewModel {
    func startIssueCredentialProtocol() async throws {}

    var oobUrl: String = ""
    var status: String = ""
    var error: String?
    func start() {}
    func parseOOBMessage() async throws {}
    func updateKeyList() async throws {}
    func startMessageStream() async throws {}
    func startMessageStream() {}
}
