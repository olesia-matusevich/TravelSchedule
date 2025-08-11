//
//  File.swift
//  TravelSchedule
//
//  Created by Alesia Matusevich on 30/07/2025.
//

import Foundation // Для UUID

// Расширение для Settlement
extension Components.Schemas.Settlement: Identifiable {
    // Выберите уникальное и стабильное поле. Если title всегда уникален и не nil, используйте его.
    // Если title может быть nil или неуникальным, используйте UUID.
    public var id: String {
        return self.title ?? UUID().uuidString // Запасной вариант с UUID
    }
    // Hashable должен быть автоматически сгенерирован для структур, если все их свойства Hashable.
    // Если Settlement - это class, вам нужно будет вручную реализовать hash(into:) и ==.
    // Предполагаем, что это struct и все внутренние поля Hashable.
}

// Расширение для Station
extension Components.Schemas.Station: Identifiable {
    // Поле `code` или `yandex_code` (если есть) из `codes` - лучший кандидат для ID.
    // Если codes?.yandex_code всегда уникален и не nil, используйте его.
    public var id: String {
        return self.codes?.yandex_code ?? self.code ?? UUID().uuidString
    }
    // Предполагаем, что это struct и все внутренние поля Hashable.
}
