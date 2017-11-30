//
// Created by  Dylan Manitta on 11/30/17.
// Copyright (c) 2017 DMAN. All rights reserved.
//

import Foundation

class Game {
    let NetTickScale = 3; // 120 ms net tick for 40 ms local tick
    let Timestep = 40;
    let TimestepJankThreshold = 250; // Don't catch up for delays larger than 250ms

    var modData: ModData
    var settings: Settings
    var cursor: iCursor
    var worldRenderer: WorldRenderer

    var orderManager: OrderManager
    var server: Server

    //public static MersenneTwister CosmeticRandom = new MersenneTwister(); // not synced

    var Renderer: GameRenderer
    var Sound: Sound
    var HasInputFocus = false

    var BenchmarkMode = false
    var GlobalChat: GlobalChat

    var EngineVersion: String
    var renderFrame = 0;
    var stopwatch = Stopwatch()
    var discoverNat: Task
    var takeScreenshot = false;



    //Fun functions!

    func JoinServer(host: String, port: Int, password: String, record: Bool) -> OrderManager {
        let connection = NetworkConnection(host: host, port: port);

        if (record) {
            connection.StartRecording();
        }

        var om = OrderManager(host: host, port: port, pass: password, netConn: connection)

        self.JoinInner(om: om)

        return om
    }

    func TimestampedFilename(includeMilliseconds: Bool = false) -> String {
        let format = includeMilliseconds ? "yyyy-MM-ddTHHmmssfffZ" : "yyyy-MM-ddTHHmmssZ"
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return "OpenRA-" + formatter.string(for: Date())!
    }

    func JoinInner(om: OrderManager?) {
        if (om != nil) {
            self.orderManager = om!
//            lastConnectionState = ConnectionState.PreConnecting
//            ConnectionStateChanged(orderManager)
        }
    }

    func JoinReplay(replayFile: String) {
        self.JoinInner(om: OrderManager(host: "<no server>", port: -1, pass: "", netConn: ReplayConnection(file: replayFile)))
    }

    func JoinLocal() {
        JoinInner(om: OrderManager(host: "<no server>", port: -1, pass: "", netConn: EchoConnection()))
    }
}

