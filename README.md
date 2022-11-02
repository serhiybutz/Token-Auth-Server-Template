## 💧 Vapor server template with token-based authentication

<p align="center">
    <a href="LICENSE">
        <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://swift.org">
        <img src="https://img.shields.io/badge/swift-5.6-brightgreen.svg" alt="Swift 5.6">
    </a>
</p>

<br/>

A Vapor server that uses token-based authentication. The client side is represented by the repository [Token-Auth-Client-Template](https://github.com/serhiybutz/Token-Auth-Client-Template.git), which is an iOS app. Since the server uses an SQLite database, no Docker installation is required.

### How to run

1. Clone the repository on the command line: `git clone https://github.com/serhiybutz/Token-Auth-Server-Template.git`.
2. Open it in Xcode (`open Package.swift`), wait for the Swift Package Manager dependencies to load, and start the server by hitting `CMD+r`.
3. Alternatively, you can build and run the server in Terminal by running the command in the server package directory: `swift run`.

### License

This project is licensed under the MIT license.
