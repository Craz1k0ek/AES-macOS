//
//  ContentView.swift
//  AES-macOS
//
//  Created by Bram Kolkman on 22/06/2020.
//  Copyright © 2020 Example. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.addSymmetricKey()
                }) {
                    Text("Add")
                }
                Button(action: {
                    self.getSymmetricKeys()
                }) {
                    Text("Get")
                }
            }
        }
        .frame(width: 250, height: 175)
        .padding()
    }
    
    private func addSymmetricKey() {
        let name    = "com.example.aes-key"
        let keyData = Data(repeating: 0xee, count: 32)
        
        let attributes = [
            kSecAttrKeyType: kSecAttrKeyTypeAES,
            kSecAttrKeySizeInBits: NSNumber(value: 256),
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked
        ] as CFDictionary

        var error: Unmanaged<CFError>?
        guard let key = SecKeyCreateFromData(attributes, keyData as CFData, &error) else {
            print("Failed to create key from data: \(error!.takeUnretainedValue()).")
            return
        }

        let addQuery = [
            kSecClass: kSecClassKey,
            kSecAttrKeyClass: kSecAttrKeyClassSymmetric,
            kSecAttrLabel: name,
            kSecValueRef: key
        ] as CFDictionary

        let status = SecItemAdd(addQuery as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            print(SecCopyErrorMessageString(status, nil)!)
            return
        }
        print("Key added to Keychain.")
    }
    
    private func getSymmetricKeys() {
        let name = "com.example.aes-key"
        
        let getQuery = [
            kSecClass: kSecClassKey,
            kSecAttrKeyClass: kSecAttrKeyClassSymmetric,
            kSecAttrLabel: name,
            kSecMatchLimit: kSecMatchLimitAll
        ] as [CFString : Any]

        var secKeys: CFTypeRef?
        let status = SecItemCopyMatching(getQuery as CFDictionary, &secKeys)

        if status == errSecSuccess {
            for symmetricKey in (secKeys as! [SecKey]) {
                guard let keyAttributes = SecKeyCopyAttributes(symmetricKey) as? [CFString: Any] else {
                    fatalError("No key attributes for symmetric key")
                }
                
                guard let keyData = keyAttributes[kSecValueData] as? Data else {
                    fatalError("No key data for symmetric key")
                }
                print("Key data retrieved: \(keyData.base64EncodedString())")
            }
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
