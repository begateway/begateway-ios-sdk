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
        pattern: "^(500|50[2-9]|501[0-8]|5[6-9]|60[2-5]|6010|601[2-9]" +
        "|6060|616788|62709601|6218[368]|6219[89]|622110|6220|627[1-9]|627089" +
        "|628[0-1]|6294|6301|630490|633857|63609|6361|636392|636708|637043|637102|637118" +
        "|637187|637529|639|64[0-3]|67[0123457]|676[0-9]|679|6771)",
        //"^(5(018|0[23]|[68])|6(39|7))",
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
        pattern: "^(5[1-5]|2[3-6]|22[2-9]|222[1-9]|27[1-2])",
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
        pattern: "^(30[0-5]|36|38)",//"^3[0689]",
        format: "defaultFormat",
        length: [14],
        cvcLength: [3],
        luhn: true,
        image: "dinersclub"
    ), CardTypePattern(
        type: "discover",
        pattern: "^(30[0-5]|3095|3[689]|6011[0234789]|65|64[4-9])",//"^6([045]|22)",
        format: "defaultFormat",
        length: [16],
        cvcLength: [3],
        luhn: true,
        image: "discover"
    ), CardTypePattern(
        type: "unionpay",
        pattern: "^(620|621[0234567]|621977|62212[6-9]|6221[3-8]" +
        "|6222[0-9]|622[3-9]|62[3-6]|6270[2467]|628[2-4]|629[1-2]|632062|685800|69075)",//"^(62|88)",
        format: "defaultFormat",
        length: [16, 17, 18, 19],
        cvcLength: [3],
        luhn: false,
        image: "unionpay"
    ), CardTypePattern(
        type: "jcb",
        pattern: "^(35|1800|2131)",
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
    ), CardTypePattern(
        type: "prostir",
        pattern: "^9804",
        format: "defaultFormat",
        length: [16],
        cvcLength: [3],
        luhn: true,
        image: "prostir"
    ), CardTypePattern(
        type: "solo",
        pattern: "^(6334|6767)",
        format: "defaultFormat",
        length: [16,18,19],
        cvcLength: [3],
        luhn: true,
        image: "solo"
    ), CardTypePattern(
        type: "switch",
        pattern: "^(633110|633312|633304|633303|633301|633300)",
        format: "defaultFormat",
        length: [16,18,19],
        cvcLength: [3],
        luhn: true,
        image: "switch"
    ), CardTypePattern(
        type: "hipercard",
        pattern: "^(384|606282|637095|637568|637599|637609|637612)",
        format: "defaultFormat",
        length: [19],
        cvcLength: [3],
        luhn: true,
        image: "hipercard"
    ), CardTypePattern(
        type: "elo",
        pattern: "^(401178|401179|431274|438935|451416|457393|457631|457632|504175|506699" +
        "|5067[0-7]|5090[0-8]|636297|636368|650[04579]|651652|6550[0-4])",
        format: "defaultFormat",
        length: [16],
        cvcLength: [3],
        luhn: false,
        image: "elo"
    ), CardTypePattern(
        type: "rupay",
        pattern: "(606[1-9]|607|608|81|82|508)",
        format: "defaultFormat",
        length: [16],
        cvcLength: [3],
        luhn: false,
        image: "rupay"
    )
    
]
