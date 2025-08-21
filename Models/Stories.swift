import Foundation

struct Stories: Identifiable, Sendable, Hashable {
    var id = UUID()
    var previewImage: String
    var images: [String]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Stories, rhs: Stories) -> Bool {
        lhs.id == rhs.id
    }
}
