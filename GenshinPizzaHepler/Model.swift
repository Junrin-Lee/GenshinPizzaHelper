//
//  Model.swift
//  Genshin Resin Checker
//
//  Created by 戴藏龙 on 2022/7/12.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    typealias QueryResult = (isValid: Bool, retcode: Int, data: UserData?)
    
    @Published var result: QueryResult = (false, 1, nil)
    
    func get_data(uid: String, server_id: String, cookie: String) -> (isValid: Bool, retcode: Int, data: UserData?) {
        fetch(uid: uid, server_id: server_id, cookie: cookie) {
            if $0 == nil {
                self.result = (false, 1, nil)
            } else if $0!.retcode != 0 {
                self.result = (false, $0!.retcode, nil)
            } else {
                self.result = (true, $0!.retcode, $0!.data!)
            }
        }
        return result
    }

    func fetch(uid: String, server_id: String, cookie: String, completion: @escaping ((RequestResult?) -> Void)) {
        
        func get_ds_token(uid: String, server_id: String) -> String {
            let s = "xV8v4Qu54lUKrEYFZkJhB8cuOh9Asafs"
            let t = String(Int(Date().timeIntervalSince1970))
            let r = String(Int.random(in: 100000..<200000))
            let q = "role_id=\(uid)&server=\(server_id)"
            let c = "salt=\(s)&t=\(t)&r=\(r)&b=&q=\(q)".md5
            return t + "," + r + "," + c
        }

        var url = URLComponents(string: "https://api-takumi-record.mihoyo.com/game_record/app/genshin/api/dailyNote")!
        url.queryItems = [
            URLQueryItem(name: "server", value: server_id),
            URLQueryItem(name: "role_id", value: uid)
        ]

        var request = URLRequest(url: url.url!)
        request.allHTTPHeaderFields = [
            "DS": get_ds_token(uid: uid, server_id: server_id),
            "x-rpc-app_version": "2.11.1",
            "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) miHoYoBBS/2.11.1",
            "x-rpc-client_type": "5",
            "Referer": "https://webstatic.mihoyo.com/",
            "Cookie": cookie
        ]

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
            
                let requestResult = try? decoder.decode(RequestResult.self, from: data)
                completion(requestResult)
                let dictionary = try? JSONSerialization.jsonObject(with: data)
                print(dictionary ?? "None")
                
            }
        }.resume()
    }
}
