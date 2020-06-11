//
//  APIRequest.swift
//  neblinaAR
//
//  Created by Negar on 2020-03-19.
//  Copyright © 2020 Negar. All rights reserved.
//

import Foundation

enum APIError:Error{
    case responseProblem
    case decodingProblem
    case encodingProblem
}

struct APIRequest{
    let resourceURL: URL
    
    init() {
        let resourceString = "http://quotes.rest/qod.json?category=inspire"
        guard let resourceURL = URL(string: resourceString) else{
            fatalError()
        }
        self.resourceURL = resourceURL
    }
    
    func save(completion: @escaping(Result<Message, APIError>) -> Void){
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest){
                data, response, _ in
                //print(response)
                guard let httpResponse = response as? HTTPURLResponse,  httpResponse.statusCode == 200, let jsonData = data else{
                    completion(.failure(.responseProblem))
                    return
                }
                do{
                    print(jsonData)
                    let messageData = try JSONDecoder().decode(Message.self, from: jsonData)
                    completion(.success(messageData))
                }catch{
                    completion(.failure(.decodingProblem))
                }
            }
            dataTask.resume()
    }
}
