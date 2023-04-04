import RxSwift
import RxCocoa

print(1)
enum MYERROR: Error {
    case err1
    case err2
    case err3
}

let ob = Observable<String>.create { emitter in
    emitter.onNext("1")
    emitter.onNext("2")
    emitter.onError(MYERROR.err2)
    
    return Disposables.create()
}

ob.map { element in
    print(element)
    if(element == "2") {
        throw MYERROR.err1
    }
    return element + " ::"
}

ob.subscribe(
    onNext: { print("element : \($0)") },
    onError: { print("\($0)")})
//.disposed(by: Dispo)
