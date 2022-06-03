import RxSwift

let disposedBag = DisposeBag()

print("------PublishSubject------")
let publishSubject = PublishSubject<String>()

publishSubject.onNext("1안뇽하세요~")

let 구독자1 = publishSubject.subscribe(onNext: {
    print("첫번째 구독자 : \($0)")
})

publishSubject.onNext("2Do you hear me?")
publishSubject.on(.next("3Nope"))

구독자1.dispose()

let 구독자2 = publishSubject
    .subscribe(onNext: {
        print("두번째 구독자 : \($0)")
    })

publishSubject.onNext("4모시모시")
publishSubject.onCompleted()

publishSubject.onNext("5??")

구독자2.dispose()

publishSubject
    .subscribe {
        print("세번째 구독:", $0.element ?? $0)
    }
    .disposed(by: disposedBag)

publishSubject.onNext("6이거가능?")


print("----behaviorSubject----")
enum SubjectError: Error {
    case error1
}
// 반드시 초기값을 가진다.
let behaviorSubject = BehaviorSubject<String>(value: "초기값")

behaviorSubject.onNext("1. 첫번째값")

behaviorSubject.subscribe {
    print("첫번째 구독 :", $0.element ?? $0)
}
.disposed(by: disposedBag)

behaviorSubject.onError(SubjectError.error1)

behaviorSubject.subscribe {
    print("두번째 구독", $0.element ?? $0)
}
.disposed(by: disposedBag)

let value = try? behaviorSubject.value()
print(value)

print("-----ReplaySubject-----")
let replaySubject = ReplaySubject<String>.create(bufferSize: 2) // 몇개의 버퍼를 가질것인지 선언

replaySubject.onNext("1 이게")
replaySubject.onNext("2 ReplaySubject")
replaySubject.onNext("3 인가요?")

replaySubject.subscribe {
    print("첫번째 구독 :", $0.element ?? $0)
}
.disposed(by: disposedBag)

replaySubject.subscribe {
    print("두번째 구독", $0.element ?? $0)
}
.disposed(by: disposedBag)

replaySubject.onNext("4 신기하네요")
replaySubject.onError(SubjectError.error1)
replaySubject.dispose()

replaySubject.subscribe {
    print("세번째 구독자", $0.element ?? $0)
}
.disposed(by: disposedBag)
