//
//  ContentView.swift
//  AGVML_000
//
//  Created by Yu Ke on 19.01.26.
//

import SwiftUI
import Vision
@preconcurrency import AVFoundation

struct ContentView: View {
    @State private var scannedString: String = "Scan a QR code or barcode"

    var body: some View {
        ZStack(alignment: .bottom) {
            ScannerView(scannedString: $scannedString)
                .edgesIgnoringSafeArea(.all)

            Text(scannedString)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
        }
    }
}
