//
//  CardType.swift
//  begateway.framework
//
//  Created by admin on 29.10.2021.
//

struct CardTypePattern {
    var type: String
    var pattern: String
    var format: String
    var length: Array<Int>
    var cvcLength: Array<Int>
    var luhn: Bool
    var image: String? = nil
}

var cardPatterns: Array<CardTypePattern> = [
    CardTypePattern(
        type: "visaelectron",
        pattern: "^4(026|17500|405|508|844|91[37])",
        format: "",
        length: [16, 19],
        cvcLength: [3],
        luhn: true,
        image: "VISA_ELECTRON"
    ),
    CardTypePattern(
        type: "maestro",
        pattern: "^(5(018|0[23]|[68])|6(39|7))",
        format: "defaultFormat",
        length: [12, 13, 14, 15, 16, 17, 18, 19],
        cvcLength: [0,3],
        luhn: true,
        image: "maestro"
    ), CardTypePattern(
        type: "forbrugsforeningen",
        pattern: "^600",
        format: "defaultFormat",
        length: [16],
        cvcLength: [3],
        luhn: true,
        image: "FORBRUGSFORENINGEN"
    ), CardTypePattern(
        type: "dankort",
        pattern: "^5019",
        format: "defaultFormat",
        length: [16],
        cvcLength: [3],
        luhn: true,
        image: "DANKORT"
    ), CardTypePattern(
        type: "visa",
        pattern: "^4",
        format: "defaultFormat",
        length: [13, 16, 19],
        cvcLength: [3],
        luhn: true,
        image: "visa"
    ), CardTypePattern(
        type: "master",
        pattern: "^(5[1-5]|2[3-6]|222|27[1-2])",
        format: "defaultFormat",
        length: [16],
        cvcLength: [3],
        luhn: true,
        image: "mastercard"
    ), CardTypePattern(
        type: "amex",
        pattern: "^3[47]",
        //            format: "/(\d{1,4})(\d{1,6})?(\d{1,5})?/",
        format: "",
        length: [15],
        cvcLength: [3, 4],
        luhn: true,
        image: "amex"
    ), CardTypePattern(
        type: "dinersclub",
        pattern: "^3[0689]",
        format: "defaultFormat",
        length: [14],
        cvcLength: [3],
        luhn: true,
        image: "dinersclub"
    ), CardTypePattern(
        type: "discover",
        pattern: "^6([045]|22)",
        format: "defaultFormat",
        length: [16],
        cvcLength: [3],
        luhn: true,
        image: "discover"
    ), CardTypePattern(
        type: "unionpay",
        pattern: "^(62|88)",
        format: "defaultFormat",
        length: [16, 17, 18, 19],
        cvcLength: [3],
        luhn: false,
        image: "unionpay"
    ), CardTypePattern(
        type: "jcb",
        pattern: "^35",
        format: "defaultFormat",
        length: [16],
        cvcLength: [3],
        luhn: true,
        image: "jcb"
    ), CardTypePattern(
        type: "belkart",
        pattern: "^9112",
        format: "defaultFormat",
        length: [16],
        cvcLength: [3],
        luhn: true,
        image: "belkart"
    ), CardTypePattern(
        type: "mir",
        pattern: "^220[0-4]",
        format: "defaultFormat",
        length: [16],
        cvcLength: [3],
        luhn: true,
        image: "mir"
    )
]
