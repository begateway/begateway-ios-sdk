// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let currencyJSON = try? newJSONDecoder().decode(CurrencyJSON.self, from: jsonData)

import Foundation

// MARK: - CurrencyJSONValue
struct CurrencyJSONValue: Codable {
    let priority: Int
    let isoCode, name, symbol: String
    let alternateSymbols: [String]?
    let subunit: String?
    let subunitToUnit: Int
    let symbolFirst: Bool
    let format: Format?
    let htmlEntity: String
    let decimalMark, thousandsSeparator: DecimalMark
    let isoNumeric: String
    let smallestDenomination: SmallestDenomination?
    let disambiguateSymbol: String?

    enum CodingKeys: String, CodingKey {
        case priority
        case isoCode = "iso_code"
        case name, symbol
        case alternateSymbols = "alternate_symbols"
        case subunit
        case subunitToUnit = "subunit_to_unit"
        case symbolFirst = "symbol_first"
        case format
        case htmlEntity = "html_entity"
        case decimalMark = "decimal_mark"
        case thousandsSeparator = "thousands_separator"
        case isoNumeric = "iso_numeric"
        case smallestDenomination = "smallest_denomination"
        case disambiguateSymbol = "disambiguate_symbol"
    }
}

enum DecimalMark: String, Codable {
    case decimalMark = ","
    case empty = "."
    case purple = " "
}

enum Format: String, Codable {
    case nU = "%n %u"
    case uN = "%u%n"
}

enum SmallestDenomination: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(SmallestDenomination.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for SmallestDenomination"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

typealias CurrencyJSON = [String: CurrencyJSONValue]

func loadJson(filename fileName: String) -> CurrencyJSON? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(CurrencyJSON.self, from: data)
            return jsonData
        } catch {
            print("error:\(error)")
        }
    }
    return nil
}
