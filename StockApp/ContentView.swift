//
//  ContentView.swift
//  StockApp
//
//  Created by Mohar on 15/03/25.
//

import SwiftUI
import Charts

struct ShareData: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
}

struct Company: Identifiable {
    let id = UUID()
    let name: String
    let ticker: String
    let industry: String
    let marketCap: String
}

class ShareViewModel: ObservableObject {
    @Published var sharePrices: [ShareData] = []
    @Published var companies: [Company] = []
    private var timer: Timer?
    
    init() {
        generateInitialData()
        loadCompanies()
        startUpdating()
    }
    
    private func generateInitialData() {
        let calendar = Calendar.current
        let now = Date()
        for i in 0..<30 {
            if let date = calendar.date(byAdding: .day, value: -i, to: now) {
                let price = Double.random(in: 100...300)
                sharePrices.insert(ShareData(date: date, price: price), at: 0)
            }
        }
    }
    
    private func startUpdating() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.addNewPrice()
        }
    }
    
    private func addNewPrice() {
        let newPrice = Double.random(in: 100...300)
        let newData = ShareData(date: Date(), price: newPrice)
        sharePrices.append(newData)
        if sharePrices.count > 30 {
            sharePrices.removeFirst()
        }
    }
    
    private func loadCompanies() {
        companies = [
            Company(name: "Apple Inc.", ticker: "AAPL", industry: "Technology", marketCap: "$2.5T"),
            Company(name: "Microsoft Corp.", ticker: "MSFT", industry: "Technology", marketCap: "$2.4T"),
            Company(name: "Tesla Inc.", ticker: "TSLA", industry: "Automotive", marketCap: "$800B"),
            Company(name: "Amazon.com Inc.", ticker: "AMZN", industry: "E-commerce", marketCap: "$1.6T"),
            Company(name: "Google (Alphabet)", ticker: "GOOGL", industry: "Technology", marketCap: "$1.8T")
        ]
    }
    
    deinit {
        timer?.invalidate()
    }
}

struct ShareGraphView: View {
    @ObservedObject var viewModel = ShareViewModel()
    
    var body: some View {
        VStack {
            Text("Stock Price Trend").font(.title).padding()
            
            Chart(viewModel.sharePrices) { data in
                LineMark(
                    x: .value("Date", data.date),
                    y: .value("Price", data.price)
                )
                .foregroundStyle(.blue)
                .lineStyle(StrokeStyle(lineWidth: 2))
            }
            .frame(height: 300)
            .padding()
            
            Text("Latest Price: $\(viewModel.sharePrices.last?.price ?? 0, specifier: "%.2f")")
                .font(.headline)
                .padding()
            
            List(viewModel.companies) { company in
                VStack(alignment: .leading) {
                    Text(company.name).font(.headline)
                    Text("Ticker: \(company.ticker)").font(.subheadline)
                    Text("Industry: \(company.industry)").font(.subheadline)
                    Text("Market Cap: \(company.marketCap)").font(.subheadline)
                }
                .padding()
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            ShareGraphView()
                .navigationTitle("Share Market")
        }
    }
}

@main
struct StockApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


#Preview {
    ContentView()
}
