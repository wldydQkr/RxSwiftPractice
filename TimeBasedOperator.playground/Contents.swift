import RxSwift
import RxCocoa
import UIKit
import PlaygroundSupport

let disposedBag = DisposeBag()

// 버퍼링 연산자들은 과거에 요소들을 subscirber에게 다시 전송하거나 잠시 버퍼링을 두고 줄 수 있다.

print("---replay---") //
let 인사말 = PublishSubject<String>()
let 반복하는기계 = 인사말.replay(1) // 버퍼의 개수만큼 최신순서대로 값을 받을 수 있다.

반복하는기계.connect()

인사말.onNext("1. 안녕")
인사말.onNext("2. 아니")

반복하는기계
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposedBag)


print("---replayAll---")
let 닥터스트레인지 = PublishSubject<String>()
let 타임스톤 = 닥터스트레인지.replayAll() // 지나간 값들도 모두 표시해준다.
타임스톤.connect()

닥터스트레인지.onNext("도르마무")
닥터스트레인지.onNext("거래를 하러왔다")

타임스톤
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposedBag)


//print("---buffer---") // count
//let source = PublishSubject<String>()
//
//var count = 0
//let timer = DispatchSource.makeTimerSource()
//
//timer.schedule(deadline: .now() + 2, repeating: .seconds(1))
//timer.setEventHandler {
//    count += 1
//    source.onNext("\(count)")
//}
//timer.resume()
//
//source
//    .buffer(
//        timeSpan: .seconds(2),
//        count: 2,
//        scheduler: MainScheduler.instance
//    )
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposedBag)

//print("---window---") // buffer와 유사함, buffer는 array를 방출하고 window는 Observable을 방출한다.
//let 만들어낼최대Observable수 = 1
//let 만들시간 = RxTimeInterval.seconds(2)
//
//let window = PublishSubject<String>()
//
//var windowCount = 0
//let windowTimeSource = DispatchSource.makeTimerSource()
//windowTimeSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
//windowTimeSource.setEventHandler {
//    windowCount += 1
//    window.onNext("\(windowCount)")
//}
//windowTimeSource.resume()
//
//window.window(
//    timeSpan: 만들시간,
//    count: 만들어낼최대Observable수,
//    scheduler: MainScheduler.instance
//)
//.flatMap { windowObservable -> Observable<(index: Int, element: String)> in
//    return windowObservable.enumerated()
//}
//.subscribe(onNext: {
//    print("\($0.index)번째 Observable의 요소\($0.element)")
//})
//.disposed(by: disposedBag)

//print("---delaySubscription---") // 구독을 지연시켜준다.
//let delaySource = PublishSubject<String>()
//
//var delayCount = 0
//let delayTimeSource = DispatchSource.makeTimerSource()
//delayTimeSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
//delayTimeSource.setEventHandler {
//    delayCount += 1
//    delaySource.onNext("\(delayCount)")
//}
//delayTimeSource.resume()
//
//delaySource
//    .delaySubscription(.seconds(2), scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposedBag)


//print("---delay---")
//let delaySubject = PublishSubject<Int>()
//
//var delayCount = 0
//let delayTimeSource = DispatchSource.makeTimerSource()
//delayTimeSource.schedule(deadline: .now(), repeating: .seconds(1))
//delayTimeSource.setEventHandler {
//    delayCount += 1
//    delaySubject.onNext(delayCount)
//}
//delayTimeSource.resume()
//
//delaySubject
//    .delay(.seconds(3), scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposedBag)


//print("---interval---") // 임의로 만들었던 Timer를 Rx로 바로 구현을 시켜준다.
//Observable<Int>
//    .interval(.seconds(3), scheduler: MainScheduler.instance)
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposedBag)


//print("---timer---") // 첫번째값과 구독한 후 첫번째값을 방출하는 사이에 마감일을 설정할 수 있다.
//Observable<Int>
//    .timer(
//        .seconds(5),
//        period: .seconds(2),
//        scheduler: MainScheduler.instance
//    )
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposedBag)

print("---timeout---")
let 누르지않으면에러 = UIButton(type: .system)
누르지않으면에러.setTitle("눌러!", for: .normal)
누르지않으면에러.sizeToFit()

PlaygroundPage.current.liveView = 누르지않으면에러

누르지않으면에러.rx.tap
    .do(onNext: {
        print("tap")
    })
    .timeout(.seconds(5), scheduler: MainScheduler.instance)
    .subscribe {
        print($0)
    }
    .disposed(by: disposedBag)
