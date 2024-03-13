import SwiftUI
import Networking
import SYVisualKit

enum AuthEndpoint: Endpoint {

    case sendEmail

    var path: String { "/v1/send-authorization-code" }

    var method: HTTPMethod { .post }

    var header: [String : String]? {
        [:]
    }

    var body: [String : String]? { ["email": "xfiniks@gmail.com"]}

}

protocol AuthServiceable {
    func sendCode() async -> Result<EmptyResponse, RequestError>
}

struct AuthService: HTTPClient, AuthServiceable {
    func sendCode() async -> Result<EmptyResponse, RequestError> {
        return await sendRequest(endpoint: AuthEndpoint.sendEmail)
    }
}

//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//        .task {
//            let result = await AuthService().sendCode()
//            print(result)
//        }
//    }
//}

struct ContentView: View {

    @State var isDestructive = false
    @State var isFullfilled = false

    @State var text = "0000"

    var body: some View {
//        let _ = Self._printChanges()
        SYOTPTextField(isDestructive: $isDestructive, isFullfilled: $isFullfilled, text: $text)

        if isFullfilled {
            SYStrokeButton(title: text, action: { })
        }
    }
}

#Preview {
    ContentView()
}
