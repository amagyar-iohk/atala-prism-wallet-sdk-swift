import Builders
import Domain
import Foundation
import EdgeAgent

final class DIDFuncionalitiesViewModel: ObservableObject {
    private let castor: Castor
    private let agent: DIDCommAgent

    init() {
        self.castor = CastorBuilder(
            apollo: ApolloBuilder().build()
        ).build()
        self.agent = DIDCommAgent(mediatorDID: DID(method: "peer", methodId: "123"))
    }

    @Published var createdDID: DID?
    @Published var resolvedDID: DIDDocument?

    func createPrismDID() async {
        // Creates new PRISM DID
        let did = try? await agent.createNewPrismDID(
            // Add this if you want to provide a IndexPath
            keyPathIndex: 2,
            // Add this if you want to provide an alias for this DID
            // alias: <#T##String?#>
            // Add any services available in the DID
            services: [ .init(
                id: "DemoID",
                type: ["DemoType"],
                serviceEndpoint: [.init(uri: "DemoServiceEndpoint")]
            )
       ])
        
        await MainActor.run {
            self.createdDID = did
        }
    }

    func resolveDID() async {
        guard let did = createdDID else { return }

        // Resolves a DID and returns a DIDDocument
        let document = try? await castor.resolveDID(did: did)

        await MainActor.run {
            self.resolvedDID = document
        }
    }
}

extension DIDDocument: ReflectedStringConvertible {}
