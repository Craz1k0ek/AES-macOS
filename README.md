# AES-macOS
An example project for macOS KeyChain and AES key(s)

To see this application live in action, open the `Keychain Access` application. Select `All Items` for the category and filter using "com.example.aes-key".
You can also filter for your custom string, for now, the label string is "com.example.aes-key".

Launch the application and select either the get or add button, doens't really matter. You shouldn't see any key data appear in the debug console. 
However, if you add, and then get you can see multiple things.

1. The debug console should print out the key data in the console.
2. The Keychain Access application should show an entry in the filtered list.

Feel free to delete the created key from the Keychain Access application, be careful though, deleting the wrong keys might cause harm to your computer.
