//
//  SocketIOManager.swift
//  LedController
//
//  Created by Philipp Wallrich on 02.09.18.
//  Copyright © 2018 Philipp Wallrich. All rights reserved.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()

    let manager: SocketManager = SocketManager(socketURL: URL(string: "http://raspberrypi:3000")!, config: [.log(false), .compress])
    let socket: SocketIOClient

    override init() {
        socket = manager.defaultSocket
        super.init()

    }

    func establishConnnection() {
        socket.connect()
    }

    func closeConnection() {
        socket.disconnect()
    }

    func setLeds(red: Int, green: Int, blue: Int) {

        socket.emit("rgbLed", with: [[
            "red": red,
            "green": green,
            "blue": blue
        ]])
    }
    
}
