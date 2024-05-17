import Foundation
import Combine

public enum WebSocketError: Swift.Error {
    case alreadyConnectedOrConnecting
    case notConnected
    case cannotParseMessage(String)
}

public extension WebSocket {
    enum State {
        case notConnected, connecting, connected, disconnected
    }
}

public class WebSocket {
    private(set) var state: State = .notConnected
    let messages: AsyncThrowingStream<Data, Error>
    private let urlRequest: URLRequest
    private let urlSession: URLSession
    private var socketTask: URLSessionWebSocketTask?
    private var socketTaskDelegate: SocketTaskDelegate?
    private var messagesContinuation: AsyncThrowingStream<Data, Error>.Continuation!
    
    public init(request: URLRequest, urlSession: URLSession = URLSession.shared) {
        self.urlRequest = request
        self.urlSession = urlSession
        let (stream, continuation) = AsyncThrowingStream.makeStream(of: Data.self, throwing: Error.self)
        self.messages = stream
        self.messagesContinuation = continuation
    }
    
    deinit {
        try? disconnect()
        messagesContinuation.finish()
    }

    public func connect() async throws {
        guard state == .notConnected else {
            throw WebSocketError.alreadyConnectedOrConnecting
        }
        state = .connecting
        await withCheckedContinuation { continuation in
            let delegate = SocketTaskDelegate { _ in
                self.state = .connected
                continuation.resume()
                self.receive()
                print("connected")
            } onWebSocketTaskDidClose: { _, _ in
                self.handleDisconnect(withError: nil)
            } onWebSocketTaskDidCompleteWithError: { error in
                self.handleDisconnect(withError: error)
            }
            self.socketTaskDelegate = delegate
            socketTask = urlSession.webSocketTask(with: urlRequest)
            socketTask?.delegate = delegate
            socketTask?.resume()
        }
    }
    
    func disconnect() throws {
        guard state == .connected else {
            throw WebSocketError.notConnected
        }
        socketTask?.cancel(with: .normalClosure, reason: nil)
        socketTask = nil
        socketTaskDelegate = nil
    }
    
    private func receive() {
        socketTask?.receive { [weak self] result in
            switch result {
            case .success(.data(let data)):
                print("success: \(data)")
                self?.messagesContinuation.yield(data)
                self?.receive()
                
            case .success(.string(let string)):
                print("success: \(string)")
                guard let data = string.data(using: .utf8) else {
                    self?.messagesContinuation.finish(throwing: WebSocketError.cannotParseMessage(string))
                    return
                }
                self?.messagesContinuation.yield(data)
                self?.receive()
              
            case .failure(let error):
                print("failure: data")
                self?.messagesContinuation.finish(throwing: error)
            default:
                break
            }
        }
    }
    
    private func handleDisconnect(withError error: Error?) {
        state = .disconnected
        messagesContinuation.finish(throwing: error)
        socketTask = nil
        socketTaskDelegate = nil
    }
}

private class SocketTaskDelegate: NSObject, URLSessionWebSocketDelegate {
    private let onWebSocketTaskDidOpen: (_ protocol: String?) -> Void
    private let onWebSocketTaskDidClose: (_ code: URLSessionWebSocketTask.CloseCode, _ reason: Data?) -> Void
    private let onWebSocketTaskDidCompleteWithError: (_ error: Error?) -> Void
    init(
        onWebSocketTaskDidOpen: @escaping (_: String?) -> Void,
        onWebSocketTaskDidClose: @escaping (_: URLSessionWebSocketTask.CloseCode, _: Data?) -> Void,
        onWebSocketTaskDidCompleteWithError: @escaping (_: Error?) -> Void
    ) {
        self.onWebSocketTaskDidOpen = onWebSocketTaskDidOpen
        self.onWebSocketTaskDidClose = onWebSocketTaskDidClose
        self.onWebSocketTaskDidCompleteWithError = onWebSocketTaskDidCompleteWithError
    }
    public func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol proto: String?
    ) {
        onWebSocketTaskDidOpen(proto)
    }
    public func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        onWebSocketTaskDidClose(closeCode, reason)
    }
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        onWebSocketTaskDidCompleteWithError(error)
    }
}
