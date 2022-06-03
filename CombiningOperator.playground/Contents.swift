import RxSwift

let disposeBag = DisposeBag()

print("---startWith---") // 초기값을 붙일때 사용
let 노랑반 = Observable.of("잼민1", "잼민2", "잼민3")

노랑반
    .enumerated()
    .map({ index, element in
        return element + "잼민" + "\(index)"
    })
    .startWith("선생님")
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("---concat1---")
let 노랑반아이들 = Observable<String>.of("잼민1", "잼민2", "잼민3")
let 선생님 = Observable<String>.of("선생님")

let 줄서서걷기 = Observable
    .concat([선생님, 노랑반아이들])

줄서서걷기
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("---concat2---") // 시퀀스나 어떤 컬렉션의 형태로 넣어줄 수 있지만 바로 사용할 수도 있다.
선생님
    .concat(노랑반아이들)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("---concatMap---") // 각각의 시퀀스가 다음 시퀀스가 구독되기 전에 합쳐지는걸 보증한다.
let 어린이집: [String: Observable<String>] = [
    "노랑반": Observable.of("잼민1", "잼민2", "잼민3"),
    "파랑반": Observable.of("잼민4", "잼민5")
]
Observable.of("노랑반", "파랑반")
    .concatMap { 반 in
        어린이집[반] ?? .empty()
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("---merge1---") // 값을 합쳐서 방출해줌 순서는 어떤게 먼저 방출될지는 보장하지 않는다. 먼저 도착하면 방출됨
let 강북 = Observable.from(["강북구", "성북구", "동대문구", "종로구"])
let 강남 = Observable.from(["강남구", "강동구", "영등포구", "양천구"])

Observable.of(강북, 강남)
    .merge()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("---merge2---")
Observable.of(강북, 강남)
    .merge(maxConcurrent: 1) // maxConcurrent이란 한번에 받아낼 Observable에 수를 의미한다. 강북 Observable에 대한 시퀀스가 완료되기 전까지는 다른 시퀀스를 받아오지 않는다.
    .subscribe({
        print($0)
    })
    .disposed(by: disposeBag)

print("---combineLatest1---")
let 성 = PublishSubject<String>()
let 이름 = PublishSubject<String>()

let 성명 = Observable
    .combineLatest(성, 이름) { 성, 이름 in
        성 + 이름
    }
성명
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
성.onNext("박")
이름.onNext("길동")
이름.onNext("철수")
이름.onNext("영희")
성.onNext("김")
성.onNext("이")
성.onNext("죄")


print("---combineLatest2---")
let 날짜표시형식 = Observable<DateFormatter.Style>.of(.short, .long)
let 현재날짜 = Observable<Date>.of(Date())

let 현재날짜표시 = Observable
    .combineLatest(
        날짜표시형식,
        현재날짜,
        resultSelector: { 형식, 날짜 -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = 형식
            return dateFormatter.string(from: 날짜)
        }
    )

현재날짜표시
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("---combineLatest3---")
let lastName = PublishSubject<String>()
let firstName = PublishSubject<String>()

let fullName = Observable
    .combineLatest([firstName, lastName]) { name in
        name.joined(separator: " ")
    }

fullName
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

lastName.onNext("Park")
firstName.onNext("Chris")
firstName.onNext("Jimmy")
firstName.onNext("Steve")


print("---zip---")
enum 승패 {
    case 승
    case 패
}

let 승부 = Observable<승패>.of(.승, .승, .패, .승, .패)
let 선수 = Observable<String>.of("한국", "일본", "중국", "미국", "태국", "호주")

let 시합결과 = Observable
    .zip(승부, 선수) { 결과, 대표선수 in
        return 대표선수 + "선수" + " \(결과)"
    }

시합결과
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("---withLatestFrom1---") //
let 빵 = PublishSubject<Void>()
let 달리기선수 = PublishSubject<String>()

빵
    .withLatestFrom(달리기선수)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

달리기선수.onNext("선수1")
달리기선수.onNext("선수1 선수2")
달리기선수.onNext("선수1 선수2 선수3")
빵.onNext(Void())
빵.onNext(Void())


print("---sample---") // 한번만 방출해준다.
let 출바알 = PublishSubject<Void>()
let 수영선수 = PublishSubject<String>()

수영선수
    .sample(출바알)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

수영선수.onNext("1")
수영선수.onNext("1 2")
수영선수.onNext("1 2 3")
출바알.onNext(Void())
출바알.onNext(Void())
출바알.onNext(Void())


print("---amb---") // 가지고 있는 두가지 Observable을 모두 구독하지만 두개중에 먼저 방출하는애가 생기면 나머지는 더이상 구독을 하지 않는다.
let 버스1 = PublishSubject<String>()
let 버스2 = PublishSubject<String>()

let 버스정류장 = 버스1.amb(버스2)

버스정류장
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

버스2.onNext("버스2-승객0: 1")
버스1.onNext("버스1-승객0: 1")
버스1.onNext("버스1-승객1: 1")
버스2.onNext("버스2-승객1: 1")
버스1.onNext("버스1-승객1: 1")
버스1.onNext("버스1-승객2: 1")


print("---switchLatest---")
let 학생1 = PublishSubject<String>()
let 학생2 = PublishSubject<String>()
let 학생3 = PublishSubject<String>()

let 손들기 = PublishSubject<Observable<String>>()

let 손든사람만말할수있는교실 = 손들기.switchLatest()

손든사람만말할수있는교실
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

손들기.onNext(학생1)
학생1.onNext("학생1: 저는 1번 학생입니다.")
학생2.onNext("학생2: 저요 저요!!!")

손들기.onNext(학생2)
학생2.onNext("학생2: 저는 2번 학생입니다.")
학생1.onNext("학생1: 나 아직 할말 있는데")

손들기.onNext(학생3)
학생2.onNext("학생2: 잠깐만요!")
학생1.onNext("학생1: 언제 말할 수 있죠")
학생3.onNext("학생3: 저는 3번 학생입니다.")

손들기.onNext(학생1)
학생1.onNext("학생1: 아니 아니 아니!")
학생2.onNext("학생2: ㅠㅠ")
학생3.onNext("학생3: 이긴 줄 알았는데")
학생2.onNext("학생2: 아 몰랑")


print("---reduce---")
Observable.from((1...10))
//    .reduce(0, accumulator: { summary, newValue in
//        return summary + newValue
//    })
//    .reduce(0) { summary, newValue in
//        return summary + newValue
//    }
    .reduce(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("---scan---")
Observable.from((1...10))
    .scan(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
