import UIKit

protocol ChampProtocol: AnyObject {
    associatedtype MyType
    var champion: MyType { get set }
}

final class ApChamp: ChampProtocol {
    var champion = "sss"
}

