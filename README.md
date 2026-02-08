# 개요

https://apps.apple.com/app/id6758393441

Binglet 앱의 코드를 담은 레포지토리입니다.

# 기술 스택

- **UI**: SwiftUI + 커스텀 화면 스택 관리자
- **비동기 처리**: Swift Concurrency (async/await)
- **이벤트 핸들링 아키텍처**: PEO (Prime Event Orchestration)

# 코드 읽기 가이드

이벤트 핸들링에 PEO 아키텍처를 사용합니다.
아키텍처에 대한 설명은 아래 글에서 확인하실 수 있습니다.

* https://velog.io/@oliver-or-not/원초-이벤트와-파생-이벤트로-이해하는-앱
* https://velog.io/@oliver-or-not/PEO-이벤트-충돌을-구조적으로-해결하기

## 모듈 설명

* Universe: 개발 일반
* Spectrum: 앱 스코프 정의 (화면의 종류, 원초 이벤트의 종류, 앱 전역에서 사용되는 구조체 등)
* Director: 앱 전반에서 사용되는 기능 담당자
* Agent: 개별 기능 담당자
* Plate: 각 화면 구현
* PrimeEvent: 원초 이벤트에 대응하는 비동기 작업 명세
* App: 메인 앱 프로젝트

## 주요 코드

* PEO 아키텍처 구현의 핵심 코드
  * `Director/Sources/EachDirector/PrimeEventDirector/PrimeEventDirector.swift`
  * `Spectrum/Sources/Designation/PrimeEventDesignation.swift`
  * `App/App/Window/Subscriber/PrimeEventSubscriber.swift`

# 실행

Xcode 26.0.1

iOS 17 이상

## 실행 방법

pod, tuist 등을 사용하지 않으므로 실행에 필요한 별도의 절차는 없습니다.
* 클론 후 workspace 파일 열기
* run
