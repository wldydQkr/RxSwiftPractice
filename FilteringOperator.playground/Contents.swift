import UIKit
import RxSwift

let disposeBag = DisposeBag()
print("-----ignoreElements-----") // Next 이벤트를 무시, completed나 error같은 정지 이벤트만 허용한다.
let 취침모드 = PublishSubject<String>()

취침모드
    .ignoreElements()
    .subscribe { _ in
        print("Wake up")
    }
    .disposed(by: disposeBag)

취침모드.onNext("삐융")
취침모드.onNext("삐융")
취침모드.onNext("삐융")

취침모드.onCompleted()


print("-----elementAt-----")
let 두번울면깨는사람 = PublishSubject<String>()

두번울면깨는사람
    .element(at: 2) // Observable에 발생한 n번째 요소만 처리된다.
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

두번울면깨는사람.onNext("삐융") // index 0
두번울면깨는사람.onNext("아이쿠") // index 1
두번울면깨는사람.onNext("삐융") // index 2

print("-----filter-----")
Observable.of(1, 2, 3, 4, 5, 6, 7, 8)
    .filter { $0 % 2 == 0 }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("-----skip-----") // n개의 요소를 스킵한 뒤 그 다음에 요소를 방출한다.
Observable.of(1, 2, 3, 4, 5, 6)
    .skip(5)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-----skipWhile-----") // 어떤 요소를 스킵하지 않을때 까지 스킵하고 종료한다.
Observable.of(1, 2, 3, 4, 5, 6, 7, 8)
    .skip(while: {
        $0 != 6
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-----skipUntil-----") // 다른 Observable이 onNext 이벤트를 방출하기 전까지 현재 Observable이 발생하는 모든 이벤트들을 무시한다.
let 손님 = PublishSubject<String>()
let 문여는시간 = PublishSubject<String>()

손님 // 현재 Observable
    .skip(until: 문여는시간) // 다른 Observable
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

손님.onNext("입장")
손님.onNext("입장")
손님.onNext("입장")

문여는시간.onNext("끝!")
손님.onNext("입장")


print("-----take-----") // skip의 반대 개념, 필요한값만큼만 방출하고 그 다음값은 무시
Observable.of(1, 2, 3, 4, 5)
    .take(3)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-----takeWhile-----") // true에 해당하는 값을 방출, skipWhile과 반대
Observable.of(1, 2, 3, 4, 5)
    .take(while: {
        $0 != 3
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("-----enumerated-----") // 방출된 이벤트에 index를 참고하고 싶을 때 사용한다.
Observable.of(1, 2, 3, 4, 5)
    .enumerated()
    .take(while: {
        $0.index < 3
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("-----takeUntil-----") // skipUntil에 반대 개념, trigger가 되는 Observable이 구독되기 전까지의 이벤트 값만 받는다.
let 수강신청 = PublishSubject<String>()
let 신청마감 = PublishSubject<String>()

수강신청
    .take(until: 신청마감)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

수강신청.onNext("학생1")
수강신청.onNext("학생2")

신청마감.onNext("끝")
수강신청.onNext("학생3")


print("-----distincUntilChanged-----") // 연달아 같은 값이 반복될 때 중복값을 막아준다. 
Observable.of("저는", "저는", "강아지", "강아지", "입니다", "입니다", "저는", "강아지", "입니다")
    .distinctUntilChanged()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
