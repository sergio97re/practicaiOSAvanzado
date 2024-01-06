//
//  SecureDataProviderTest.swift
//  PracticaFinaliOSAvanzadoTests
//
//  Created by Sergio Reina Montes on 06/01/2024.
//

import XCTest
@testable import PracticaFinaliOSAvanzado

final class SecureDataProviderTest: XCTestCase {
    
    private let responseDataHeroes: [[String: Any]] = [
            [
                "id": "14BB8E98-6586-4EA7-B4D7-35D6A63F5AA3",
                "photo": "https://cdn.alfabetajuega.com/alfabetajuega/2020/06/Roshi.jpg?width=300",
                "name": "Maestro Roshi",
                "description": "Es un maestro de artes marciales que tiene una escuela, donde entrenará a Goku y Krilin para los Torneos de Artes Marciales. Aún en los primeros episodios había un toque de tradición y disciplina, muy bien representada por el maestro. Pero Muten Roshi es un anciano extremadamente pervertido con las chicas jóvenes, una actitud que se utilizaba en escenas divertidas en los años 80. En su faceta de experto en artes marciales, fue quien le enseñó a Goku técnicas como el Kame Hame Ha",
                "favorite": false
            ],
            [
                "id": "1985A353-157F-4C0B-A789-FD5B4F8DABDB",
                "photo": "https://cdn.alfabetajuega.com/alfabetajuega/2020/06/dragon-ball-satan.jpg?width=300",
                "name": "Mr. Satán",
                "description": "Mr. Satán es un charlatán fanfarrón, capaz de manipular a las masas. Pero en realidad es cobarde cuando se da cuenta que no puede contra su adversario como ocurrió con Androide 18 o Célula. Siempre habla más de la cuenta, pero en algún momento del combate empieza a suplicar. Androide 18 le ayuda a fingir su victoria a cambio de mucho dinero. Él acepta el trato porque no podría soportar que todo el mundo le diera la espalda por ser un fraude.",
                "favorite": false
            ]
    ]
    
    func login(for user: String, with password: String) {
        NotificationCenter.default.post(
            name: NotificationCenter.apiLoginNotification,
            object: nil,
            userInfo: [NotificationCenter.tokenKey: "rthtyhfcgtyfjhtyju45uyydrEDJKtgh541"]
        )
    }
    
    func getHeroes(_ heroName: String?, completion: ((PracticaFinaliOSAvanzado.Heroes) -> Void)?) {
        do {
            let data = try JSONSerialization.data(withJSONObject: responseDataHeroes)
            let heroes = try? JSONDecoder().decode([Hero].self, from: data)

            if let heroName {
                completion?(heroes?.filter { $0.name == heroName } ?? [])
            } else {
                completion?(heroes ?? [])
            }
        } catch {
            completion?([])
        }
    }
    
    func getLocations(by heroId: String, completion: ((PracticaFinaliOSAvanzado.HeroLocations) -> Void)?) {

    }
    
    private var sut: SecureDataProviderProtocol!

    override func setUp() {
        sut = SecureDataProvider()
    }

    func test_givenSecureDataProvide_whenLoadToken_thenGetStoredToken() throws {
        let token = "rthtyhfcgtyfjhtyju45uyydrEDJKtgh541"
        sut.save(token: token)
        let tokenLoaded = sut.getToken()

        XCTAssertEqual(token, tokenLoaded)
    }
}
