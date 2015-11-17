// HTTPRequestResponseMiddlewareType.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Zewo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

public protocol HTTPRequestResponseMiddlewareType {
    func respond(request: HTTPRequest, response: HTTPResponse)
}

public func >>>(responder: HTTPResponderType, middleware: HTTPRequestResponseMiddlewareType) -> HTTPResponderType {
    return SimpleHTTPResponder { request in
        let response = responder.respond(request)
        middleware.respond(request, response: response)
        return response
    }
}

public func >>>(respond: HTTPRequest -> HTTPResponse, middleware: HTTPRequestResponseMiddlewareType) -> HTTPResponderType {
    return SimpleHTTPResponder { request in
        let response = respond(request)
        middleware.respond(request, response: response)
        return response
    }
}

public func >>>(responder: HTTPResponderType, respond: (HTTPRequest, response: HTTPResponse) -> Void) -> HTTPResponderType {
    return SimpleHTTPResponder { request in
        let response = responder.respond(request)
        respond(request, response: response)
        return response
    }
}

public func >>>(respond: HTTPRequest -> HTTPResponse, middlewareRespond: (HTTPRequest, response: HTTPResponse) -> Void) -> HTTPResponderType {
    return SimpleHTTPResponder { request in
        let response = respond(request)
        middlewareRespond(request, response: response)
        return response
    }
}

public func >>>(responder: HTTPFallibleResponderType, middleware: HTTPRequestResponseMiddlewareType) -> HTTPFallibleResponderType {
    return SimpleHTTPFallibleResponder { request in
        let response = try responder.respond(request)
        middleware.respond(request, response: response)
        return response
    }
}

public func >>>(respond: HTTPRequest throws -> HTTPResponse, middleware: HTTPRequestResponseMiddlewareType) -> HTTPFallibleResponderType {
    return SimpleHTTPFallibleResponder { request in
        let response = try respond(request)
        middleware.respond(request, response: response)
        return response
    }
}

public func >>>(responder: HTTPFallibleResponderType, middlewareRespond: (HTTPRequest, response: HTTPResponse) -> Void) -> HTTPFallibleResponderType {
    return SimpleHTTPFallibleResponder { request in
        let response = try responder.respond(request)
        middlewareRespond(request, response: response)
        return response
    }
}

public func >>>(respond: HTTPRequest throws -> HTTPResponse, middlewareRespond: (HTTPRequest, response: HTTPResponse) -> Void) -> HTTPFallibleResponderType {
    return SimpleHTTPFallibleResponder { request in
        let response = try respond(request)
        middlewareRespond(request, response: response)
        return response
    }
}
