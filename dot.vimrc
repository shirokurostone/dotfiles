
" vi互換モードをオフ
set nocompatible

" シンタックスハイライトを有効化
syntax on

" バッファを保存しなくても他のバッファを表示できるようにする
set hidden

" タイプ途中のコマンドを画面最下行に表示
set showcmd

" 検索時に大文字・小文字を区別しない
" ただし、検索語に大文字小文字が混在しているときは区別する
set ignorecase
set smartcase

" オートインデントを有効化
" set autoindent
set cindent

" オートインデント、改行、インサートモード開始直後に
" バックスペースで削除できるようにする
set backspace=indent,eol,start

" 移動コマンドを使ったとき、行頭に移動しない
set nostartofline

" ステータスラインを常に表示する
set laststatus=2
set statusline=%f%9(\ %m%r\ %)\ %l/%L

" beepの代わりにビジュアルベルを使う
set visualbell

" ビジュアルベルを無効化
set t_vb=

" 行番号を表示
" set number

" インクリメンタルサーチを有効化
set incsearch

" タブをスペースに展開
set expandtab

" タブ幅の設定
set tabstop=4
set shiftwidth=4
set softtabstop=4

" ファイル選択時に補完表示
set wildmenu

" ファイルが変更されるとリロード
set autoread

" ファイル末尾まで検索すると先頭に戻る
set wrapscan

" デフォルトの文字コードをUTF-8に
set encoding=utf-8

filetype plugin indent on

" 分割・タブのキーバインドの設定
" http://qiita.com/tekkoc/items/98adcadfa4bdc8b5a6ca
nnoremap s <Nop>

nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>

nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sw <C-w>w

nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sr <C-w>r

nnoremap s> <C-w>>
nnoremap s< <C-w><
nnoremap s+ <C-w>+
nnoremap s- <C-w>-
nnoremap s= <C-w>=

nnoremap st :<C-u>tabnew<CR>
nnoremap sn gt
nnoremap sp gT

nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>

