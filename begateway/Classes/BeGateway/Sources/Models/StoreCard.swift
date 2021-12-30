// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let storeCard = try? newJSONDecoder().decode(StoreCard.self, from: jsonData)

import Foundation

// MARK: - StoreCard
struct StoreCard: Codable {
    let createdAt: Date
    let brand, icon: String?
    let last4, first1: String
    let token: String
    var isActive: Bool
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case brand, icon
        case last4 = "last_4"
        case first1 = "first_1"
        case token
        case isActive = "is_active"
    }
}

// MARK: StoreCard convenience initializers and mutators

extension StoreCard {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(StoreCard.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        createdAt: Date? = nil,
        brand: String? = nil,
        icon: String? = nil,
        last4: String? = nil,
        first1: String? = nil,
        token: String? = nil,
        isActive: Bool? = nil
    ) -> StoreCard {
        return StoreCard(
            createdAt: createdAt ?? self.createdAt,
            brand: brand ?? self.brand,
            icon: icon ?? self.icon,
            last4: last4 ?? self.last4,
            first1: first1 ?? self.first1,
            token: token ?? self.token,
            isActive: isActive ?? false
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: Sustom functions

extension StoreCard {
    func to() -> BeGatewayCard {
        return BeGatewayCard(createdAt: self.createdAt, first1: self.first1, last4: self.last4, brand: self.brand)
    }
    
    static func to(items: Array<StoreCard>) -> Array<BeGatewayCard> {
        var list: Array<BeGatewayCard> = []
        
        for item in items {
            list.append(item.to())
        }
        
        return list
    }
    
    static var keyUserDefaults = "begateway_api_cards"
    
    static func writeToUserDefaults(items: Array<StoreCard>) -> Bool {
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()
            
            // Encode Note
            let data = try encoder.encode(items)
            
            // Write/Set Data
            UserDefaults.standard.set(data, forKey: keyUserDefaults)
            
            return true
            
        } catch {
            print("Unable to Encode Array of StoreCard (\(error))")
        }
        
        return false
    }
    
    static func readFromUserDefaults() -> Array<StoreCard>? {
        if let data = UserDefaults.standard.data(forKey: keyUserDefaults) {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                let items: Array<StoreCard> = try decoder.decode([StoreCard].self, from: data)
                return items
                
            } catch {
                print("Unable to Decode Array (\(error))")
            }
        }
        
        return nil
    }
    
    static func addToUserDefaults(item: StoreCard) -> Bool {
        var items = self.readFromUserDefaults()
        
        if items == nil {
            items = []
        }
        
        if item.isActive {
            for (index, _) in (items ?? []).enumerated() {
                items?[index].isActive = false
            }
        }
        
        items?.append(item)
        
        return self.writeToUserDefaults(items: items!)
    }
    
    static func clearUserDefaults() -> Bool {
        return self.writeToUserDefaults(items: [])
    }
    
    static func getActiveCard() -> StoreCard? {
        if let data = UserDefaults.standard.data(forKey: keyUserDefaults) {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                
                // Decode Note
                let items: Array<StoreCard> = try decoder.decode([StoreCard].self, from: data)
                
                if items.count > 0 {
                    for item in items {
                        if item.isActive{
                            return item
                        }
                    }
                }
                    
                
            } catch {
                print("Unable to Decode Array (\(error))")
            }
        }
        
        return nil
    }
    
    static func setActiveState(_ index: Int, isActive: Bool) -> Bool {
        var items = self.readFromUserDefaults()
        
        if items == nil {
            items = []
        }
        
        if isActive {
            for (index_, _) in (items ?? []).enumerated() {
                items?[index_].isActive = index == index_
                
            }
        } else {
            items?[index].isActive = isActive
        }
        
        
        return self.writeToUserDefaults(items: items!)
    }
    
    static func remove(_ index: Int) -> Bool {
        var items = self.readFromUserDefaults()
        
        if items == nil {
            items = []
        }
        
        let isActive = items?[index].isActive ?? false
        items?.remove(at: index)
        
        if isActive && (items?.count ?? 0) > 0 {
            items![items?.count ?? 0].isActive = isActive
        }
        
        
        return self.writeToUserDefaults(items: items!)
    }
}


// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
