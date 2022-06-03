import Foundation
import RxSwift
import Dispatch

print("-----Just-----")
Observable<Int>.just(1) // 하나의 Element만 방출하는 Observable 생성 Oparator입니다.
    .subscribe(onNext: {
        print($0)
    })

print("-----Of1-----")
Observable<Int>.of(1, 2, 3, 4, 5) // 다양한 형태의 이벤트들을 넣을 수 있습니다.
    .subscribe(onNext: {
        print($0)
    })

print("-----Of2-----")
Observable.of([1, 2, 3, 4, 5]) // 타입추론을 통해서 Observable Sequence를 생성
    .subscribe(onNext: {
        print($0)
    })

print("-----From-----")
Observable.from([1, 2, 3, 4, 5]) // Array형태의 값만 받는다. 자동적으로 자기가 받은 Array속에 있는 Element들을 하나씩 꺼내서 방출하게 된다.
    .subscribe(onNext: {
        print($0)
    })



print("-----Subscribe1-----")
Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }
// .subscribe만 이용하면 어떤 이벤트에 어떠한 값이 씌워져서 나오고 completed 이벤트가 발생했는지 여부를 확인해줌

print("-----Subscribe2-----")
Observable.of(1, 2, 3)
    .subscribe {
        if let element = $0.element {
            print(element)
        }
    }

print("-----Subscribe3-----")
Observable.of(1, 2, 3)
    .subscribe(onNext: {
        print($0)
    })

print("-----empty-----")
Observable.empty()
    .subscribe {
        print($0)
    }
// 요소를 하나도 가지지 않은 어떤 카운트 0인 Observable을 만들때 혹은 즉시 종료하고 싶은 Observable을 만들고 싶을때 사용한다.

print("-----never-----")
Observable.never()
    .debug("never") // 2022-05-20 02:13:39.901: never -> subscribed
    .subscribe(
        onNext: {
            print($0)
        },
        onCompleted: {
            print("완료")
        })

print("-----range-----")
Observable.range(start: 1, count: 9)
    .subscribe(onNext: {
        print("3*\($0)=\(3*$0)")
    })


// dispose : 구독 취소
Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }
    .dispose()

// disposeBag : 방출된 리턴값을 disposeBag에 호출한다. Observable에 대해서 구독을 하고 있을 때 이것을 즉시 disposeBag에 추가한다. disposeBag은 이것을 가지고 있다가 자신이 할당 해제할때 모든 구독에 대해서 dispose를 날린다.
// dispose를 사용하는 이유 Observable이 끝나지 않기 때문에 메모리 누수가 일어 날 수 있다.
let disposeBag = DisposeBag()

Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)

// create
Observable.create { observable -> Disposable in
    observable.onNext(1)
//    observable.on(.next(1)) // 같은 표현
    observable.onCompleted()
    observable.onNext(2) // onCompleted 이벤트 때문에 이벤트가 방출되지 않음
    return Disposables.create()
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)

// create2
enum MyError: Error {
    case anError
}

Observable<Int>.create { observable -> Disposable in
    observable.onNext(1)
    observable.onError(MyError.anError)
    observable.onCompleted()
    observable.onNext(2)
    return Disposables.create()
}
.subscribe(
    onNext: {
        print($0)
    },
    onError: {
        print($0.localizedDescription)
    },
    onCompleted: {
        print("완료")
    },
    onDisposed: {
        print("disposed")
    }
)
.disposed(by: disposeBag)

// deffered
Observable.deferred {
    Observable.of(1, 2, 3)
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)

// deffered 2
var 뒤집기: Bool = false

let factory: Observable<String> = Observable.deferred {
    뒤집기 = !뒤집기
    
    if 뒤집기 {
        return Observable.of("👍")
    } else {
        return Observable.of("👎")
    }
}

for _ in 0...3 {
    factory.subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
}
