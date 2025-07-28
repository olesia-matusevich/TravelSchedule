//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Alesia Matusevich on 21/07/2025.
//

import SwiftUI
import OpenAPIURLSession
import OpenAPIRuntime

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            testRequests()
        }
    }
}

func testRequests() {
    let apiKey = "a2a9afdb-17e3-48ac-82e8-402828f47084"
    
    Task {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            
            let carrierService = CarrierService(apiKey: apiKey, client: client)
            try await carrierService.getCarrierInfo(code: "680")
            
            let copyrightService = CopyrightService(apiKey: apiKey, client: client)
            try await copyrightService.getCopyrightInfo()
            
            let nearestSettlementService = NearestSettlementService(apiKey: apiKey, client: client)
            try await nearestSettlementService.getNearestCity(lat: 55.7558, lng: 37.6173)
            
            let nearestStationsService = NearestStationsService(apiKey: apiKey, client: client)
            try await nearestStationsService.getNearestStations(lat: 59.864177, lng: 30.319163, distance: 50)
            
            let scheduleService = ScheduleService(apiKey: apiKey, client: client)
            try await scheduleService.getSchedule(station: "s9628059")
            
            let searchService = SearchService(apiKey: apiKey, client: client)
            try await searchService.search(from: "s9613034", to: "s9620203")
            
            let stationsListService = StationsListService(apiKey: apiKey, client: client)
            try await stationsListService.getAllStations()
            
            let threadService = ThreadService(apiKey: apiKey, client: client)
            try await threadService.getRouteStations(uid: "479A_2_2")
            
        } catch {
            print("Error: \(error)")
        }
    }
}

//// Функция для тестового вызова API
//func testFetchStations() {
//    // Создаём Task для выполнения асинхронного кода
//    Task {
//        do {
//            // 1. Создаём экземпляр сгенерированного клиента
//            let client = Client(
//                // Используем URL сервера, также сгенерированный из openapi.yaml (если он там определён)
//                serverURL: try Servers.Server1.url(),
//                // Указываем, какой транспорт использовать для отправки запросов
//                transport: URLSessionTransport()
//            )
//            
//            // 2. Создаём экземпляр нашего сервиса, передавая ему клиент и API-ключ
//            let service = NearestStationsService(
//                client: client,
//                apikey: "a2a9afdb-17e3-48ac-82e8-402828f47084" // !!! ЗАМЕНИТЕ НА СВОЙ РЕАЛЬНЫЙ КЛЮЧ !!!
//            )
//            
//            // 3. Вызываем метод сервиса
//            print("Fetching stations...")
//            let stations = try await service.getNearestStations(
//                lat: 59.864177, // Пример координат
//                lng: 30.319163, // Пример координат
//                distance: 50    // Пример дистанции
//            )
//            
//            // 4. Если всё успешно, печатаем результат в консоль
//            print("Successfully fetched stations: \(stations)")
//        } catch {
//            // 5. Если произошла ошибка на любом из этапов (создание клиента, вызов сервиса, обработка ответа),
//            //    она будет поймана здесь, и мы выведем её в консоль
//            print("Error fetching stations: \(error)")
//            // В реальном приложении здесь должна быть логика обработки ошибок (показ алерта и т. д.)
//        }
//    }
//}

#Preview {
    ContentView()
}
