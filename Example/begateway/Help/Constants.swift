//
//  Constants.swift
//  begateway_Example
//
//  Created by FEDAR TRUKHAN on 9/11/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//


enum Constants {
    static let testCheckoutJSON = """
{
"token": "efcbcdeb45cf6a625bbec66a92a55c1ad8d1872d53be8db881a39850b1333dcc",
"redirect_url": "https://checkout.bepaid.by/checkout?token=4e67bfe907e52c1392a417b5e50b00d3cf92683af4743c127ea27612bd1faa75",
"brands": [
{
"alternative": false,
"name": "visa"
},
{
"alternative": false,
"name": "master"
},
{
"alternative": false,
"name": "belkart"
},
{
"alternative": false,
"name": "visa"
},
{
"alternative": false,
"name": "master"
},
{
"alternative": false,
"name": "maestro"
}
],
"company": {
"name": "bePaid",
"site": "https://bepaid.by"
},
"description": "Payment description",
"card_info": {}
}
"""
    
    static let testCheckoutJSON3DSecure = """
{
"token": "9bc88220a7897b3c742407b68601dd25b85e6ac8af859ec2d97974551ff91769",
"redirect_url": "https://checkout.bepaid.by/checkout?token=4e67bfe907e52c1392a417b5e50b00d3cf92683af4743c127ea27612bd1faa75",
"brands": [
{
"alternative": false,
"name": "visa"
},
{
"alternative": false,
"name": "master"
},
{
"alternative": false,
"name": "belkart"
},
{
"alternative": false,
"name": "visa"
},
{
"alternative": false,
"name": "master"
},
{
"alternative": false,
"name": "maestro"
}
],
"company": {
"name": "bePaid",
"site": "https://bepaid.by"
},
"description": "Payment description",
"card_info": {}
}
"""
    
    static let publicKey = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvextn45qf3NiNzqBYXMvcaSFlgoYE/LDuDDHtNNM4iWJP7BvjBkPcZu9zAfo5IiMxl660r+1E4PYWwr0iKSQ8+7C/WcSYwP8WlQVZH+2KtPmJgkPcBovz3/aZrQpj6krcKLklihg3Vs++TtXAbpCCbhIq0DJ3T+khttBqTGD+2x2vOC68xPgMwvnwQinfhaHEQNbtEcWWXPw9LYuOTuCwKlqijAEds4LgKSisubqrkRw/HbAKVfa659l5DJ8QuXctjp3Ic+7P2TC+d+rcfylxKw9c61ykHS1ggI/N+/KmEDVJv1wHvdy7dnT0D/PhArnCB37ZDAYErv/NMADz2/LuQIDAQAB"
    
    static let publicKeyWith3DSecure = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxiq93sRjfWUiS/OE2ZPfMSAeRZFGpVVetqkwQveG0reIiGnCl4RPJGMH1ng3y3ekhTxO1Ze+ln3sCK0LJ/MPrR1lzKN9QbY4F3l/gmj/XLUseOPFtayxvQaC+lrYcnZbTFhqxB6I1MSF/3oeTqbjJvUE9KEDmGsZ57y0+ivbRo9QJs63zoKaUDpQSKexibSMu07nm78DOORvd0AJa/b5ZF+6zWFolVBmzuIgGDpCWG+Gt4+LSw9yiH0/43gieFr2rDKbb7e7JQpnyGEDT+IRP9uKCmlRoV1kHcVyHoNbC0Q9kV8jPW2K5rKuj80auV3I2dgjJEsvxMuHQOr4aoMAgQIDAQAB"
}
