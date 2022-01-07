//
//  SocketManager.swift
//  Qwnched-Customer
//
//  Created by Hiral  J on 29/12/20.
//  Copyright © 2020 Hiral's iMac. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON

typealias CompletionBlock = ((JSON) -> ())?

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()

    let manager = SocketManager(socketURL: URL(string: SocketData.kSocketHostUrl.rawValue)!, config: [.log(true), .compress])
      lazy var socket = manager.defaultSocket
    
      var isSocketOn = false
    
    override private init() {
        super.init()
     
   }
   
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
        
    }
    func establishSocketConnection() {
        socket.on("connect") { ( dataArray, ack) -> Void in
            print("connected to external server")
        }
        self.socket.connect()
    }
    func socketCall(for key: String, completion: CompletionBlock = nil)
    {
        if SocketIOManager.shared.socket.status == .connected {
            SocketIOManager.shared.socket.on(key, callback: { (data, ack) in
                let result = self.dataSerializationToJson(data: data)
                print("Result:-",result)
                print("Result:-",result.status)
                guard result.status else { return }
                print("completion:-",completion)
                if completion != nil { completion!(result.json) }
            })
        }
        else {
            print("\n\n Socket Disconnected \n\n")
        }
        
    }
   
    func socketEmit(for key: String, with parameter: [String:Any]){
        
        socket.emit(key, with: [parameter], completion: nil)
        print ("Parameter Emitted for key - \(key) :: \(parameter)")
    }
    
    
    
    
    func dataSerializationToJson(data: [Any],_ description : String = "") -> (status: Bool, json: JSON){
        let json = JSON(data)
//        print (description, ": \(json)")

        return (true, json)
    }
   
}
