# Overleaf에서 CV 관리하기

1. 제공된 `Wonyeong_Lee_CV_Overleaf.zip`을 Overleaf의 새 프로젝트 → 프로젝트 업로드로 올립니다.
2. 메인 문서를 `main.tex`, 컴파일러를 **XeLaTeX**로 설정하고 Recompile을 누릅니다. `moderncv` 등은 Overleaf의 TeX Live에 포함되어 있으므로 별도 설치가 필요 없습니다.
3. **내용 수정은 `cv-content.tex`**에서 합니다. 구역별 주석과 기존 항목을 복사하면 됩니다. 이름·이메일 변경 시 PDF 메타데이터를 위해 `main.tex`와 `cv-style.tex`의 해당 값도 수정하세요.
4. 디자인·여백은 `cv-style.tex`에서 수정합니다. 이 프로젝트는 외부 사진, 시스템 전용 폰트, BibTeX, shell escape를 요구하지 않습니다.
5. PDF를 다운로드하고 파일명을 `cv.pdf`로 바꿔 [홈페이지 저장소 루트](https://github.com/wonleeyoung/wonleeyoung.github.io/upload/main)에 업로드하여 교체합니다. GitHub의 Commit changes로 저장한 뒤 Pages 배포를 확인하세요.
6. 홈페이지 본문은 별도로 [`_data/cv.yml`](https://github.com/wonleeyoung/wonleeyoung.github.io/edit/main/_data/cv.yml)에서 수정합니다. Overleaf, 홈페이지 YAML, 저장소의 `latex/` 사본은 자동 동기화되지 않습니다. Overleaf에서 고친 최신 소스도 ZIP으로 내려받아 보관하세요.

## 작성 규칙

- `&`, `%`, `_`, `#`를 문장에 쓸 때는 각각 `\&`, `\%`, `\_`, `\#`로 적습니다.
- 날짜 범위는 `Mar. 2026 -- Jun. 2026`처럼 씁니다. 장학금의 물결표는 `\textasciitilde{}`로 출력합니다.
- 논문 저자는 원래 순서를 유지하고 본인 이름만 `\textbf{Wonyeong Lee}`로 감쌉니다.
- `\publication`의 다섯 인자는 번호, 제목, 저자, 학회·상세 정보, 링크입니다. 링크가 없으면 마지막 `{}`를 빈 채로 둡니다.
- 학력·장학금·조교 경력은 `\academicentry{제목}{기간}{설명}` 형식입니다. `\\`는 항목 안에서 줄바꿈합니다.
- 본문은 영어입니다. 한글 주석은 출력되지 않습니다. 한글 본문을 새로 넣는 경우에는 한글 패키지·폰트를 추가 설정해야 합니다.

## 템플릿과 빌드

공식 [moderncv 템플릿](https://github.com/moderncv/moderncv/blob/v2.4.1/template.tex)의 banking 스타일을 학술 CV에 맞게 조정했습니다. `moderncv`와 원본 템플릿의 저작권은 Xavier Danaux 및 moderncv maintainers에게 있으며 LPPL 1.3c로 배포됩니다. 라이선스 전문은 `TEMPLATE-LICENSE.txt`에 포함되어 있습니다. 이 프로젝트는 수정본이며 원본 템플릿과 구별되는 파일명을 사용합니다.

로컬 검증은 Tectonic 0.17.0으로 수행했습니다. Overleaf 계정 안에서의 실제 컴파일은 수행하지 않았습니다. Overleaf에서는 위의 XeLaTeX 설정을 사용하세요.

초기 내용 기준: 2026-09-18 홈페이지 데이터 및 사용자가 제공한 조교 경력. RTSS 2026 논문은 공식 프로그램을 근거로 게재 예정(to appear)으로 표시합니다. 2026년 9~12월 조교 경력은 종료된 경력으로 표현하지 않습니다.
