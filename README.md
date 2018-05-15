# Mac OS X 개발 환경 설정

## 시스템 업데이트
```sh
# 시스템 업데이트
$ sudo softwareupdate -iva
```

## 시스템 설정
**Apple 아이콘 > 시스템 환경설정:**
- 트랙패드 > 탭하여 클릭하기
- Dock > 자동으로 Dock 가리기와 보기
- Mission Control > 핫 코너 > (좌측 상단) 화면 보호기 시작
- Mission Control > 핫 코너 > (우측 상단) 디스플레이 잠자기
- 키보드 > 단축키 > 입력 소스 > 이전 입력 소스 선택 (command + space)
- 키보드 > 단축키 > Spotlight > Spotlight 검색 보기 비활성화

**Command Line:**
- 숨김파일 보기
```sh
$ defaults write com.apple.finder AppleShowAllFiles -bool true
```

- .DS_Store 생성 방지
```sh
$ defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
```

## Homebrew
```sh
$ xcode-select --install
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
$ brew update
$ brew tap caskroom/cask

$ brew install git
$ git clone https://github.com/ClaudeSeo/mac-dev-setup
$ cd mac-dev-setup
$ brew bundle
```

## iTerm2
- zsh
```sh
$ chsh -s `which zsh`
```

- oh-my-zsh
```sh
$ sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

$ vim ~/.zshrc

# 테마 수정
ZSH_THEME="agnoster"
```

- powerline font
```sh
$ git clone https://github.com/powerline/fonts.git --depth=1
$ cd fonts
$ ./install.sh
```

- iTerm2 > Preferencs > Profiles > Text > Change font > Roboto Mono Light for Power line

## nvm
```sh
$ curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
$ nvm install --lts
```

<sub>- 만약 profile 에 아래의 코드가 없을경우 추가한다</sub>
```sh
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

## pyenv
```sh
$ brew update
$ brew install pyenv
$ brew instlal pyenv-virtualenv
$ echo 'eval "$(pyenv init -)";' >> ~/.zshrc
$ echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
$ pyenv install 3.6.4

$ pyenv virtualenv <PYTHON_VERSION> <ENV_NAME>
```

## zsh
- [slimzsh](https://github.com/changs/slimzsh)
- [z](https://github.com/rupa/z)

## 크롬 확장프로그램
- [full-page-screen-capture](https://chrome.google.com/webstore/detail/full-page-screen-capture/fdpohaocaechififmbbbbbknoalclacl)
- [React Developer Tools](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi)
- [Vue.js devtools](https://chrome.google.com/webstore/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd)
- [XPath Helper](https://chrome.google.com/webstore/detail/xpath-helper/hgimnogjllphhhkhlmebbmlgjoejdpjl)
- [Save to Pocket](https://chrome.google.com/webstore/detail/save-to-pocket/niloccemoadcdkdjlinkgdfekeahmflj)
- [uBlock Origin](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm)

## Visual Studio Code 확장프로그램
- Vetur
- Git History
- Git Lens
- Git Blame
- ESLint
- Dash
- Color Picker
- Python-autopep8
