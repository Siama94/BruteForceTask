//
//  ExtensionString.swift
//  Pr2503
//
//  Created by Anastasiia on 1/8/22.
//

import Foundation

extension String {
    var digits: String { return "0123456789" }
    var lowercase: String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase: String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters: String { return lowercase + uppercase }
    var printable: String { return digits + letters + punctuation }

    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }

    //  Функция рандомной генерации пароля
    static func randomString(length: Int = 2) -> String {

        let printable = String().printable.map { String($0) }
        var randomString = ""

        for _ in 0 ..< length {
            randomString.append(printable.randomElement()!)
        }
        return randomString
    }
}
