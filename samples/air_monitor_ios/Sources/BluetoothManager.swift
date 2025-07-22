import Foundation
import CoreBluetooth

struct SensorValues {
    var temperature: Double
    var humidity: Double
    var formaldehyde: Double
}

class BluetoothManager: NSObject, ObservableObject {
    @Published var sensorValues: SensorValues?
    @Published var isScanning = false

    private var central: CBCentralManager!
    private var peripheral: CBPeripheral?

    // Example UUIDs
    private let serviceUUID = CBUUID(string: "0000A001-0000-1000-8000-00805F9B34FB")
    private let tempUUID = CBUUID(string: "0000A002-0000-1000-8000-00805F9B34FB")
    private let humidityUUID = CBUUID(string: "0000A003-0000-1000-8000-00805F9B34FB")
    private let formaldehydeUUID = CBUUID(string: "0000A004-0000-1000-8000-00805F9B34FB")

    override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: nil)
    }

    func toggleScan() {
        if isScanning {
            central.stopScan()
            isScanning = false
        } else {
            sensorValues = nil
            central.scanForPeripherals(withServices: [serviceUUID], options: nil)
            isScanning = true
        }
    }
}

extension BluetoothManager: CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            print("Bluetooth not available")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.peripheral = peripheral
        central.stopScan()
        isScanning = false
        central.connect(peripheral, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices([serviceUUID])
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services where service.uuid == serviceUUID {
            peripheral.discoverCharacteristics([tempUUID, humidityUUID, formaldehydeUUID], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let chars = service.characteristics else { return }
        for char in chars {
            peripheral.readValue(for: char)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else { return }
        let value = Double(Int16(bigEndian: data.withUnsafeBytes { $0.load(as: Int16.self) }))

        switch characteristic.uuid {
        case tempUUID:
            if sensorValues == nil { sensorValues = SensorValues(temperature: value / 100, humidity: 0, formaldehyde: 0) }
            else { sensorValues?.temperature = value / 100 }
        case humidityUUID:
            if sensorValues == nil { sensorValues = SensorValues(temperature: 0, humidity: value / 100, formaldehyde: 0) }
            else { sensorValues?.humidity = value / 100 }
        case formaldehydeUUID:
            if sensorValues == nil { sensorValues = SensorValues(temperature: 0, humidity: 0, formaldehyde: value / 1000) }
            else { sensorValues?.formaldehyde = value / 1000 }
        default:
            break
        }
    }
}
