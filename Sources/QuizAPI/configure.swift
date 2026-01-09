import NIOSSL
import Fluent
import FluentMySQLDriver
import Vapor

public func configure(_ app: Application) async throws {

    let certs = try NIOSSLCertificate.fromPEMFile("cert.pem")
    let key = try NIOSSLPrivateKey(file: "key.pem", format: .pem)

    let tls = TLSConfiguration.makeServerConfiguration(
        certificateChain: certs.map { .certificate($0) },
        privateKey: .privateKey(key)
    )

    app.http.server.configuration.tlsConfiguration = tls

    app.databases.use(DatabaseConfigurationFactory.mysql(
        hostname: Environment.get("DB_HOST") ?? "localhost",
        port: Int(Environment.get("DB_PORT") ?? "3306") ?? 3306,
        username: Environment.get("DB_USER") ?? "root",
        password: Environment.get("DB_PASSWORD") ?? "",
        database: Environment.get("DB_NAME") ?? "quiz_db",
        tlsConfiguration: {
            var tls = TLSConfiguration.makeClientConfiguration()
            tls.certificateVerification = .none
            return tls
        }()
    ), as: .mysql)

    app.migrations.add(CreateQuizQuestion())
    try routes(app)
}
