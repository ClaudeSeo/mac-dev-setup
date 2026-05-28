# cmux

이 디렉토리는 cmux 앱 설정을 관리합니다.

| 자산 | 용도 | 적용 방식 |
|------|------|-----------|
| `cmux.json` | cmux 앱 설정 (JSONC) | `~/.config/cmux/cmux.json`에 symlink |

## cmux config (cmux.json)

`~/.config/cmux/cmux.json`을 이 저장소의 `cmux/cmux.json`으로 symlink하여 버전 관리합니다. tmux config (`.tmux.conf`)와 동일한 패턴입니다.

### 설치

```bash
./init.sh
# 메뉴에서 "cmux-config" 항목을 Space로 선택 후 Enter
```

`init.sh`의 `setup_cmux_config`가 다음을 수행합니다:

1. `~/.config/cmux/` 디렉토리 생성 (없으면)
2. 기존 `~/.config/cmux/cmux.json`이 일반 파일이면 `*.backup.YYYYMMDDHHMMSS`로 백업
3. 저장소의 `cmux.json`을 `~/.config/cmux/cmux.json`으로 symlink

### 적용 확인

```bash
ls -l ~/.config/cmux/cmux.json
# → ~/.config/cmux/cmux.json -> <repo>/cmux/cmux.json
```

설정을 바꾸고 싶다면 저장소 파일을 직접 편집한 뒤 cmux을 재시작하거나 `Cmd+Shift+,` (reloadConfiguration) 단축키로 다시 로드합니다.

### 주의사항

- `cmux.json`은 JSONC(주석 허용) 포맷입니다. 표준 JSON 파서로 검증하면 실패할 수 있습니다.
- cmux은 파일이 없으면 시작 시 빈 템플릿을 자동 생성합니다. 즉 한 번 symlink로 교체하면 그 뒤로는 저장소 파일만 따라갑니다.
- `automation.socketPassword` 등 민감 정보를 추가할 계획이라면, 이 파일을 `.gitignore`에 등록하거나 secrets 관리 도구로 분리하세요.
