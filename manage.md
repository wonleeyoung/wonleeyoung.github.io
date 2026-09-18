---
layout: default
title: 홈페이지 관리 안내
description: YAML 내용 편집, 사진 및 PDF 업로드, 배포 확인과 복구 방법
lang: ko
permalink: /manage/
noindex: true
---

# 홈페이지 관리 안내

[홈페이지로 돌아가기]({{ '/' | relative_url }})

평소 CV 내용은 **`_data/cv.yml` 하나**에서 수정합니다. 화면 구조는 `index.html`과 `_layouts/default.html`, 디자인은 `style.css`에 분리되어 있습니다. GitHub Pages가 Jekyll과 Liquid로 HTML을 미리 생성하므로 JavaScript 없이도 본문이 보입니다.

이 페이지는 **사용 설명과 GitHub 편집 바로가기**입니다. 로그인해서 여기서 직접 저장하는 CMS가 아닙니다. 누구나 읽을 수 있는 공개 페이지이므로 비밀정보를 넣지 마세요. `noindex`는 검색 제외 요청이며 접근 통제가 아닙니다.

**홈페이지 내용 수정과 `cv.pdf` 갱신은 별개입니다. PDF는 자동 생성되지 않습니다.** 기존 README는 수정하지 않았으므로 이전 HTML 편집·`.nojekyll`·강제 push 안내 대신 이 페이지를 따르세요.

## 바로가기

- [CV 내용 편집](https://github.com/wonleeyoung/wonleeyoung.github.io/edit/main/_data/cv.yml)
- [프로필 사진·CV PDF 업로드 (저장소 루트)](https://github.com/wonleeyoung/wonleeyoung.github.io/upload/main)
- [논문 그림 업로드 (images)](https://github.com/wonleeyoung/wonleeyoung.github.io/upload/main/images)
- [논문 PDF·발표자료 업로드 (files)](https://github.com/wonleeyoung/wonleeyoung.github.io/upload/main/files)
- [빌드·배포 상태 (Actions)](https://github.com/wonleeyoung/wonleeyoung.github.io/actions)
- [Pages 설정](https://github.com/wonleeyoung/wonleeyoung.github.io/settings/pages)
- [변경 이력](https://github.com/wonleeyoung/wonleeyoung.github.io/commits/main/)

## 무엇을 어디서 바꾸나요?

| 바꿀 내용 | `_data/cv.yml`의 항목 |
| --- | --- |
| 이름·직함·소속·주소·이메일 | `profile.name`, `title`, `affiliation`, `address`, `email` |
| 프로필 사진·CV PDF 경로 | `profile.photo`, `profile.cv` |
| CV 버튼 이름 | `profile.cv_label` |
| Scholar 등 소셜 링크 | `profile.social_links`의 `label`, `url` |
| Paper Deadlines 등 기타 링크 | `profile.links`의 `label`, `url` |
| 검색·공유 설명 | `seo.description`, `seo.social_description` |
| 자기소개 | `about` (Markdown) |
| 학력·연구 관심사 | `education`, `interests` |
| 논문 | `publications` |
| 수상·장학금·조교 경력 | `awards`, `teaching` |
| 새 섹션 | `extra_sections`의 `title`, `body` (Markdown) |

## GitHub 웹에서 수정하고 저장하기

1. 위의 **CV 내용 편집**을 엽니다. GitHub에 로그인하고 이 저장소의 쓰기 권한이 있어야 합니다.
2. 원하는 항목을 바꿉니다. `profile` 아래의 `name` 등은 왼쪽 공백을 유지하세요.
3. **Commit changes…**를 누르고 변경 설명을 적은 뒤 저장합니다. `main`에 직접 저장할 수 있으면 그렇게 하고, 보호 규칙 때문에 새 브랜치/PR이 필요하면 PR 검토·병합 절차를 따릅니다.
4. Actions에서 **pages build and deployment**의 최신 실행과 커밋을 확인합니다. 완료 후 공개 홈페이지를 새로고침합니다.

파일 업로드는 해당 업로드 링크에서 파일을 끌어놓고 **Commit changes…**로 저장합니다. 같은 폴더의 같은 이름을 사용하면 교체됩니다. 다른 이름으로 올렸다면 YAML의 경로도 바꾸세요. 업로드가 먼저 끝난 뒤 YAML 링크를 추가하면 잠시 깨진 링크가 게시되는 것을 피할 수 있습니다.

## 자기소개·기본 정보·연구 관심사

`profile`의 값은 일반 텍스트입니다. HTML을 넣으면 태그가 실행되지 않고 글자로 표시됩니다. 자기소개 `about`과 추가 섹션의 `body`만 Markdown을 처리합니다.

```yaml
about: |
  첫 번째 문단입니다. **강조**와 [링크](https://example.org)를 사용할 수 있습니다.

  두 번째 문단입니다.

interests:
  - Real-Time Systems
  - Embedded Systems
```

원하는 관심사를 한 줄씩 추가하거나 지우고, 줄을 이동해 순서를 바꿉니다. 다른 목록도 YAML에 적힌 순서를 그대로 표시하며 날짜나 이름으로 자동 정렬하지 않습니다.

소셜 링크는 아래처럼 `social_links: []`를 교체합니다. 빈 `url`은 표시하지 않습니다. 실제 주소가 준비된 항목만 넣으세요.

```yaml
  social_links:
    - label: "Google Scholar"
      url: "https://scholar.google.com/citations?user=실제_ID"
```

## 학력·수상·조교 경력 추가·삭제·순서 변경

학력은 `education` 아래 **`- date:`부터 다음 `- date:` 직전까지**가 한 항목입니다. 이 블록을 복사해 붙이고 `date`, `organization`, `degree`, `note`, `location`을 고칩니다. 설명 `note`와 장소 `location`은 `""`로 비워도 됩니다.

수상과 조교 경력은 각각 `awards`, `teaching` 아래 **`- title:`부터 다음 `- title:` 직전까지**가 한 항목입니다. `title`은 이름, `details`는 기관·과목코드·역할 등, `date`는 괄호 안의 기간입니다. `details`의 쉼표·괄호도 직접 입력합니다.

항목을 지울 때는 블록 전체를 지우고, 순서를 바꿀 때도 블록 전체를 이동하세요. 목록을 모두 없애려면 `education: []`, `awards: []`, `teaching: []`처럼 쓰면 해당 섹션을 숨깁니다.

## 논문 추가와 PDF / Code / Slides 버튼

아래는 **관리 안내용 예시이며 실제 이력이 아닙니다.** 실제 정보와 업로드한 파일 경로로 바꿔서 사용하세요.

`publications` 아래 기존 논문의 **`- title:`부터 다음 `- title:` 직전까지**를 복사합니다. 이 줄 앞의 공백 두 칸도 유지하세요. 마지막 논문은 `image:`까지입니다. `authors`, `venue`, `details`, `links`, `image`를 빠뜨리지 않도록 블록 전체를 복사하세요.

```yaml
publications:
  - title: "실제 논문 제목: 부제"
    authors:
      - "첫 번째 저자"
      - "Wonyeong Lee"
      - "마지막 저자"
    venue: "실제 학회 또는 저널명"
    details: "pp. 1–10, 도시, 국가, 월 연도"
    links:
      - label: "PDF"
        url: "/files/paper.pdf"
      - label: "Code"
        url: "https://github.com/실제계정/실제저장소"
      - label: "Slides"
        url: "/files/slides.pdf"
    image: "/images/paper.png"
```

이미 있는 `publications:` 아래에 추가할 때는 **예시의 `publications:` 줄은 복사하지 마세요.** 저자는 입력 순서대로 표시하며 `profile.name`과 정확히 일치하는 이름에 밑줄을 표시합니다. 제목·학회명·부가 설명의 마지막 마침표는 화면에서 붙이므로 중복 입력하지 않습니다.

버튼이 없으면 `links: []`, 그림이 없으면 `image: ""`로 둡니다. URL이 빈 버튼은 표시하지 않습니다. 그림은 `images/`, 논문·발표자료는 `files/`에 올립니다. `/files/paper.pdf`와 `files/paper.pdf` 모두 저장소 루트 기준으로 처리하며, 외부 링크는 `https://...` 전체 주소를 씁니다.

## 프로필 사진 업로드·교체

1. 실제 사진을 저장소 루트에 `profile.jpg`로 업로드합니다.
2. `profile.photo: ""`를 아래처럼 고칩니다.

```yaml
profile:
  photo: "/profile.jpg"
```

이것은 해당 부분만 보여주는 예시입니다. 기존 `profile`과 그 안의 다른 항목을 지우거나 `profile:`을 두 번 만들지 마세요. 파일이 PNG이거나 이름을 바꿨다면 실제 경로로 변경합니다. 교체할 때 같은 이름으로 업로드하면 YAML을 다시 바꿀 필요가 없습니다.

사진이 없으면 빈 경로를 유지합니다. 지정한 로컬 이미지가 없을 때도 빌드에서 이미지 태그를 생략해 빈 공간이나 깨진 아이콘을 만들지 않습니다. 외부 이미지 주소는 지원하지만 원격 서버의 상태에 영향을 받으므로 업로드한 로컬 파일을 권장합니다.

## CV PDF 교체

새 PDF를 저장소 루트에 **`cv.pdf`**라는 동일한 이름으로 올리고 Commit changes로 저장합니다. 기본 경로 `profile.cv: "/cv.pdf"`는 그대로 둡니다. 다른 이름을 썼다면 `profile.cv`도 고치세요. 공개 [CV PDF]({{ '/cv.pdf' | relative_url }})를 열어 내용까지 확인합니다. 홈페이지 내용만 바꿔도 PDF가 자동으로 바뀌지는 않습니다.

## 새 섹션 추가

`extra_sections: []`를 아래처럼 교체합니다. `title`과 `body`를 모두 채우세요. 추가 섹션은 조교 경력 뒤에 입력 순서대로 표시합니다.

```yaml
extra_sections:
  - title: "Projects"
    body: |
      실제 프로젝트 설명을 입력하세요.

      - [프로젝트 링크](https://example.org)
```

섹션을 더 추가하려면 `- title:` 블록 전체를 앞의 공백 두 칸과 함께 복사합니다. 사용하지 않으면 `extra_sections: []`로 되돌립니다.

## YAML 입력 주의사항

- **탭 대신 공백 두 칸**을 사용하고 같은 단계는 같은 깊이로 맞춥니다. 논문의 `authors`와 `links` 목록은 한 단계 더 들여씁니다.
- 콜론 뒤에는 공백이 필요합니다: `title: "제목"`.
- 값에 `: `, `#`, 날짜, `true`, `false` 등이 들어가면 문자열이 다른 형태로 해석되지 않도록 따옴표로 감쌉니다.
- 작은따옴표 안의 작은따옴표는 두 번 씁니다: `'Dean''s List Award'`. 또는 `"Dean's List Award"`처럼 큰따옴표를 씁니다.
- `about: |`, `body: |`의 본문은 다음 줄부터 들여씁니다. 빈 줄로 문단을 나눕니다.
- 비어 있는 문자열은 `""`, 비어 있는 목록은 `[]`입니다. 필수 논문 제목·학회명·저자 목록, 프로필 이름은 비우지 마세요.
- 같은 키를 중복 작성하지 마세요. 아래 검증기가 중복 키와 오타도 찾습니다. 저자·일반 문자열에는 Markdown을 적용하지 않습니다.

## LaTeX / Overleaf로 CV PDF 관리

현재 PDF의 LaTeX 원본은 [저장소의 `latex/` 폴더](https://github.com/wonleeyoung/wonleeyoung.github.io/tree/main/latex)에 보관합니다. Overleaf용 ZIP을 새 프로젝트로 업로드한 뒤 메인 문서는 `main.tex`, 컴파일러는 **XeLaTeX**로 설정합니다. 내용은 `cv-content.tex`, 디자인은 `cv-style.tex`에서 수정합니다. 자세한 설명은 `OVERLEAF-KO.md`에 있습니다.

Overleaf에서 만든 PDF를 내려받아 파일명을 `cv.pdf`로 바꾸고 저장소 루트에 업로드하여 교체합니다. **Overleaf와 홈페이지 YAML, 저장소의 LaTeX 사본은 자동 동기화되지 않습니다.** 홈페이지 본문은 `_data/cv.yml`에서 별도로 수정하고, 최신 Overleaf 소스도 내려받아 보관하세요. GitHub Pages는 LaTeX를 컴파일하지 않습니다.

## 로컬 검증과 미리보기

Ruby 3.3 계열과 Bundler를 설치한 환경에서 저장소 폴더를 열고 실행합니다. Windows는 RubyInstaller + Devkit 환경을 사용합니다. Ruby/Gem 의존성은 `Gemfile`과 `Gemfile.lock`에 고정하며 임의로 업데이트하지 않습니다.

```sh
bundle install
ruby scripts/validate_cv.rb
ruby tests/validate_cv_test.rb
bundle exec ruby tests/render_test.rb
bundle exec jekyll build --trace
bundle exec jekyll serve
```

브라우저에서 `http://127.0.0.1:4000/`와 `http://127.0.0.1:4000/manage/`를 확인합니다. 종료는 터미널에서 `Ctrl+C`를 누릅니다. `_config.yml`을 변경했다면 미리보기 서버를 다시 시작하세요. `index.html`을 직접 더블클릭하면 Liquid가 빌드되지 않으므로 미리보기가 아닙니다.

검증 실패 예시 `.../_data/cv.yml:74 (publications[2].authors)`는 74번째 줄 주변, 두 번째 논문의 저자 목록을 고치라는 뜻입니다. 문법 오류는 줄과 열을 표시합니다. 누락된 항목은 상위 항목도 살펴보세요. 경로 검사에서는 파일명 대소문자를 구분합니다. 선택 이미지가 없으면 경고하고 숨기지만, PDF 등 연결 파일이 없으면 실패합니다. 외부 URL 서버의 응답과 사실관계까지 검증하지는 않습니다.

이 검증기는 **수동으로 실행**합니다. 기본 브랜치 Pages 빌드가 이 스크립트를 자동 실행하는 것은 아닙니다. YAML 문법 오류는 Pages 빌드에서 실패하지만, 필수 값 누락은 별도 검증이 필요합니다.

## 배포 확인과 문제 해결

Pages 게시 원본은 **Deploy from a branch → main → /(root)**입니다. 기존 URL과 이 설정을 유지합니다. 원본 루트에 `.nojekyll`을 다시 만들면 Jekyll 변환을 막으므로 추가하지 마세요. 추가 테마·사용자 플러그인은 필요하지 않습니다. [GitHub Pages와 Jekyll 공식 설명](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll), [지원 버전](https://pages.github.com/versions/)을 참고할 수 있습니다.

1. Commit changes로 저장한 **커밋 번호**를 확인합니다.
2. Actions의 **pages build and deployment**가 그 커밋으로 성공했는지 확인합니다. 실패하면 `build` 작업 로그에서 파일·줄 번호를 찾습니다. 이전 커밋의 성공만 확인하지 마세요.
3. [홈페이지](https://wonleeyoung.github.io/), [관리 안내](https://wonleeyoung.github.io/manage/), [CV PDF](https://wonleeyoung.github.io/cv.pdf), [Paper Deadlines](https://wonleeyoung.github.io/deadlines/)를 각각 엽니다.
4. 바꾼 글과 링크를 확인합니다. 모바일·다크 모드에서도 확인하세요.

화면에 변화가 없으면 배포 대상 커밋을 먼저 확인하고 `Ctrl+Shift+R`로 새로고침하거나 시크릿 창으로 엽니다. PDF도 캐시될 수 있습니다. 파일이 404이면 업로드 위치, 확장자, 대소문자를 확인합니다. `Paper.pdf`와 `paper.pdf`는 다른 파일입니다. 외부 링크 장애는 해당 서버의 상태와 주소도 확인합니다.

`deadlines/`는 기존 별도 프로젝트 경로입니다. 이 CV 저장소 안에 같은 경로의 폴더를 새로 만들거나 별도 deadlines 저장소를 수정할 필요가 없습니다.

## 이전 버전으로 복구하기

전환 전 기준 커밋은 `10dd9f7fd0ad643ebeb79dfe409ee080d63d17c3`, 전환 전 백업 브랜치는 **`backup/pre-jekyll-20260918-10dd9f7`**입니다. [백업 보기](https://github.com/wonleeyoung/wonleeyoung.github.io/tree/backup/pre-jekyll-20260918-10dd9f7). 기존 `old-gitprofile-backup`도 그대로 둡니다.

일반 내용 실수는 `_data/cv.yml`의 History에서 정상 버전을 열어 필요한 값을 복사한 뒤, 현재 파일을 편집해 새 커밋으로 저장합니다. 파일 교체 실수는 정상 버전의 파일을 내려받아 다시 업로드합니다.

전체 변경 커밋을 되돌려야 할 때는 최신 main에서 해당 **커밋 해시를 확인한 후** 다음처럼 새 취소 커밋을 만듭니다. `실제_취소할_커밋`은 실제 해시로 바꿉니다.

```sh
git switch main
git pull --ff-only origin main
git revert 실제_취소할_커밋
git push origin main
```

보호 브랜치면 별도 복구 브랜치에서 revert한 뒤 PR로 병합합니다. 충돌하면 이후 변경을 살펴보고 해결하며, 중단하려면 `git revert --abort`를 사용합니다. **force push나 이력 삭제는 사용하지 않습니다.** 전환 커밋 전체를 revert하면 당시 HTML과 `.nojekyll`도 함께 복원됩니다. 복구 뒤에도 Actions 성공과 공개 페이지를 확인하세요.
