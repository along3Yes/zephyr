import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bluetooth: BluetoothManager

    var body: some View {
        VStack(spacing: 16) {
            Text("Air Monitor")
                .font(.title)
            if let values = bluetooth.sensorValues {
                Text(String(format: "Temperature: %.1f °C", values.temperature))
                Text(String(format: "Humidity: %.1f %%", values.humidity))
                Text(String(format: "Formaldehyde: %.2f ppm", values.formaldehyde))
            } else {
                Text("Scanning for device...")
            }
            Button(bluetooth.isScanning ? "Stop Scan" : "Start Scan") {
                bluetooth.toggleScan()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environmentObject(BluetoothManager())
}
