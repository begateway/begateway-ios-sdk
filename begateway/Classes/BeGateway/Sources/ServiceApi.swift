//
//  ServiceApi.swift
//  begateway
//
//  Created by admin on 28.10.2021.
//

import Foundation

protocol ServiceApi {
    var domain: String { get set }
    var pubKey: String { get set }
}

enum ServiceApiError: Error {
    // Throw in all other cases
    case unexpected(code: Int, title: String)
}

extension ServiceApiError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unexpected(let code, let error):
            return "An unexpected error occurred. Code: \(code). Error: \(error)"
        }
    }
}

extension ServiceApi {
    func prepareMethod(with urlString: String, httpMethod: String) throws -> URLRequest {
        print("---------------------------")
        print("Url for reqquest is \"\(urlString)\"")
        print("Method is \"\(httpMethod)\"")
        
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            throw ServiceApiError.unexpected(code: 0, title: "Cannot create URL")
        }
        
        // Create the url request
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        if httpMethod == "POST" {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        request.setValue("2", forHTTPHeaderField: "X-Api-Version")
        
//        basic Authorization
//        let loginString = "\(username):\(password)"
//
//        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
//            print("Error: login data is null")
//            throw ServiceApiError.unexpected(code: 0, title: "Error: login data is null")
//        }
//
//        let base64LoginString = loginData.base64EncodedString()
//        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        request.setValue("Bearer \(self.pubKey)", forHTTPHeaderField: "Authorization")
        
        if request.allHTTPHeaderFields?.count ?? 0 > 0 {
            print("-----Headers-----")
            for (name, value) in request.allHTTPHeaderFields ?? [:] {
                print("\(name): \(value)")
            }
            print("++++++++++++++++++")
        }
        
        
        return request
    }
    
    func responseProcessing(data: Data?, response: URLResponse?, error:Error?) throws -> [String:Any]? {
        guard error == nil else {
            print("Error: error calling Method")
            print(error!)
            throw ServiceApiError.unexpected(code: 0, title: "Error calling Method")
        }
        
        guard let data = data else {
            print("Error: Did not receive data")
            throw ServiceApiError.unexpected(code: 0, title: "Did not receive data")
        }
        
//        in current api always return error as json
//        guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
//            print("Error: HTTP request failed")
//            throw ServiceApiError.unexpected(code: 0, title: "HTTP request failed")
//        }
        
        guard let response = response as? HTTPURLResponse else {
            print("Error: HTTP request failed")
            throw ServiceApiError.unexpected(code: 0, title: "HTTP request failed")
        }
        print("Response code is : \(response.statusCode)")
        
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("Error: Cannot convert data to JSON object")
                throw ServiceApiError.unexpected(code: 0, title: "Cannot convert data to JSON object")
            }
            guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                print("Error: Cannot convert JSON object to Pretty JSON data")
                throw ServiceApiError.unexpected(code: 0, title: "Cannot convert JSON object to Pretty JSON data")
            }
            guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                print("Error: Couldn't print JSON in String")
                throw ServiceApiError.unexpected(code: 0, title: "Couldn't print JSON in String")
            }
            
            print("----------------")
            print(prettyPrintedJson)
       
            
            //Processing a payment error with the error status
            
            if let responseField = jsonObject["response"] as? [String: Any] {
                    if let status = responseField["status"] as? String {
                        if status != "successful" {
                            print("Error: Response status with error")
                            throw ServiceApiError.unexpected(code: 0, title: "Status indicates an error")
                        }
                    }
                }
            
//            only for current server
            if (200 ..< 299) ~= response.statusCode {
                //
            } else {
                throw ServiceApiError.unexpected(code: 0, title: "HTTP request failed (response code is \(response.statusCode)")
            }
            
            return jsonObject
            
        } catch {
            print("Error: Trying to convert JSON data to string")
            throw ServiceApiError.unexpected(code: 0, title: "Trying to convert JSON data to string")
        }
    }
    
    func postMethod<T: Codable, R: Codable>(with url: String, uploadDataModel: T, completionHandler: ((R?) -> Void)?, failureHandler:((String) -> Void)?) {
        
        // Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
            print("Error: Trying to convert model to JSON data")
            failureHandler?("Trying to convert model to JSON data")
            return
        }
        
        do {
            var request =  try self.prepareMethod(with: url, httpMethod: "POST")
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                do {
                    _ = try self.responseProcessing(data: data, response: response, error: error)
                    
                    if completionHandler != nil {
                        DispatchQueue.main.async {
                            completionHandler?(try? newJSONDecoder().decode(R.self, from: data!))
                        }
                    }
                } catch ServiceApiError.unexpected(_, let title) {
                    failureHandler?(title)
                } catch {
                    failureHandler?("Error")
                }
            }.resume()
        }
        catch ServiceApiError.unexpected(_, let title) {
            failureHandler?(title)
        } catch {
            failureHandler?("Error")
        }
    }
    
    func postMethod<T: Codable>(with url: String, uploadDataModel: T, completionHandler: (([String:Any]?) -> Void)?, failureHandler:((String) -> Void)?) {
        
        // Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
            print("Error: Trying to convert model to JSON data")
            failureHandler?("Trying to convert model to JSON data")
            return
        }
        
        do {
            var request =  try self.prepareMethod(with: url, httpMethod: "POST")
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                do {
                    let json = try self.responseProcessing(data: data, response: response, error: error)
                    
                    if completionHandler != nil {
                        DispatchQueue.main.async {
                            completionHandler?(json)
                        }
                    }
                } catch ServiceApiError.unexpected(_, let title) {
                    failureHandler?(title)
                } catch {
                    failureHandler?("Error")
                }
            }.resume()
        }
        catch ServiceApiError.unexpected(_, let title) {
            failureHandler?(title)
        } catch {
            failureHandler?("Error")
        }
    }
    
    func postMethod(with url: String, json: String, completionHandler: (([String:Any]?) -> Void)?, failureHandler:((String) -> Void)?) {
        
        do {
            var request =  try self.prepareMethod(with: url, httpMethod: "POST")
            
            if let jsonData = json.data(using: String.Encoding.utf8){
                request.httpBody = jsonData
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                do {
                    let json = try self.responseProcessing(data: data, response: response, error: error)
                    
                    if completionHandler != nil {
                        DispatchQueue.main.async {
                            completionHandler?(json)
                        }
                    }
                } catch ServiceApiError.unexpected(_, let title) {
                    failureHandler?(title)
                } catch {
                    failureHandler?("Error")
                }
            }.resume()
        }
        catch ServiceApiError.unexpected(_, let title) {
            failureHandler?(title)
        } catch {
            failureHandler?("Error")
        }
    }
    
    func getMethod<R: Codable>(with url: String, completionHandler: ((R?) -> Void)?, failureHandler:((String) -> Void)?) {
        
        do {
            let request =  try self.prepareMethod(with: url, httpMethod: "GET")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                do {
                    _ = try self.responseProcessing(data: data, response: response, error: error)
                    
                    if completionHandler != nil {
                        DispatchQueue.main.async {
                            completionHandler?(try? newJSONDecoder().decode(R.self, from: data!))
                        }
                    }
                } catch ServiceApiError.unexpected(_, let title) {
                    failureHandler?(title)
                } catch {
                    failureHandler?("Error")
                }
            }.resume()
        }
        catch ServiceApiError.unexpected(_, let title) {
            failureHandler?(title)
        } catch {
            failureHandler?("Error")
        }
    }
    
//    func postMethod<T: Codable, R: Codable>(with urlString: String, uploadDataModel: T, completionHandler: ((R?) -> Void)?, failureHandler:((String) -> Void)?) {
//
//        guard let url = URL(string: urlString) else {
//            print("Error: cannot create URL")
//            failureHandler?("Cannot create URL")
//            return
//        }
//
//        // Convert model to JSON data
//        guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
//            print("Error: Trying to convert model to JSON data")
//            failureHandler?("Trying to convert model to JSON data")
//            return
//        }
//
//        // Create the url request
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        request.httpBody = jsonData
//
//        let loginString = "\(username):\(password)"
//
//        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
//            print("Error: login data is null")
//            failureHandler?("Login data is null")
//            return
//        }
//
//        let base64LoginString = loginData.base64EncodedString()
//        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard error == nil else {
//                print("Error: error calling POST")
//                print(error!)
//                failureHandler?("Error calling POST")
//                return
//            }
//
//            guard let data = data else {
//                print("Error: Did not receive data")
//                failureHandler?("Did not receive data")
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
//                print("Error: HTTP request failed")
//                failureHandler?("HTTP request failed")
//                return
//            }
//
//            do {
//                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
//                    print("Error: Cannot convert data to JSON object")
//                    failureHandler?("Cannot convert data to JSON object")
//                    return
//                }
//                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
//                    print("Error: Cannot convert JSON object to Pretty JSON data")
//                    failureHandler?("Cannot convert JSON object to Pretty JSON data")
//                    return
//                }
//                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
//                    print("Error: Couldn't print JSON in String")
//                    failureHandler?("Couldn't print JSON in String")
//                    return
//                }
//
//                print(prettyPrintedJson)
//
//                if completionHandler != nil {
//                    DispatchQueue.main.async {
//                        completionHandler?(try? newJSONDecoder().decode(R.self, from: data))
//                    }
//                }
//
//            } catch {
//                print("Error: Trying to convert JSON data to string")
//                failureHandler?("Trying to convert JSON data to string")
//                return
//            }
//        }.resume()
//    }
    
//    func getMethod() {
//        guard let url = URL(string: "http://dummy.restapiexample.com/api/v1/employees") else {
//            print("Error: cannot create URL")
//            return
//        }
//        // Create the url request
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard error == nil else {
//                print("Error: error calling GET")
//                print(error!)
//                return
//            }
//            guard let data = data else {
//                print("Error: Did not receive data")
//                return
//            }
//            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
//                print("Error: HTTP request failed")
//                return
//            }
//            do {
//                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
//                    print("Error: Cannot convert data to JSON object")
//                    return
//                }
//                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
//                    print("Error: Cannot convert JSON object to Pretty JSON data")
//                    return
//                }
//                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
//                    print("Error: Could print JSON in String")
//                    return
//                }
//
//                print(prettyPrintedJson)
//            } catch {
//                print("Error: Trying to convert JSON data to string")
//                return
//            }
//        }.resume()
//    }
}
