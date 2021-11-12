#  원티드 스타일의 로그인 연습 앱

### 기능
- Firebase
    - Auth
    - Firestore

### 구현
- Firebase를 이용해 로그인 구현
- 이메일/비밀번호로 로그인
- HomeViewController에서 Firestore에 있는 회원 정보를 불러와 라벨에 뿌린다

### 상세
- `Auth.auth().fetchSignInMethods`
    - 회원인지 아닌지 판단 (이걸 사용하는게 맞는지 잘 모르겠지만, 일단 구현함)
        - 이미 회원인 경우
            - 비밀번호를 입력 받고 로그인
        - 회원이 아닌 경우
            - 회원가입 뷰에서 회원가입 후 로그인
- `Auth.auth().createUser`
    - 회원가입
    - error 코드 확인
- `Auth.auth().signIn`
    - 로그인
    - error 코드 확인
- `Auth.auth().signOut()`
    - 로그아웃
    - do-catch문 사용
- Firestore
    - 회원가입시 생기는 `uid`를 문서 이름으로 db에 저장
        - 이름, 고유값(uid), 이메일
    - 문서를 불러올 때도 `currentUser`의 `uid`로 불러옴
    
