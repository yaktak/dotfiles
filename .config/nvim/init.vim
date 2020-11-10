let g:nvim_config_file = $XDG_CONFIG_HOME . '/nvim/init.vim'

source $XDG_CONFIG_HOME/nvim/autoload/util.vim

" ローカル設定ファイルを読み込む
" 読み込み順を制御したいので exrc は使わない
if (filereadable('./.localrc.vim'))
    source ./.localrc.vim
endif

" ------------------
"   プラグイン管理
" ------------------
" {{{

" dein のプラグイン用ディレクトリ
let s:dein_plugin_dir = $XDG_CACHE_HOME . '/dein/plugins'

" dein 本体のディレクトリ
let s:dein_dir = s:dein_plugin_dir . '/repos/github.com/Shougo/dein.vim'

" dein を導入してなかったら git clone
if !isdirectory(s:dein_dir)
    execute '!git clone https://github.com/Shougo/dein.vim.git ' . s:dein_dir
endif

" runtimepath に追加
execute 'set runtimepath+=' . s:dein_dir

if &compatible
  set nocompatible
endif

if dein#load_state(s:dein_plugin_dir)
  call dein#begin(s:dein_plugin_dir)

  " プラグインを TOML から読み込む
  call dein#load_toml($XDG_CONFIG_HOME . '/dein/plugin.toml', {'lazy': 0})
  call dein#load_toml($XDG_CONFIG_HOME . '/dein/plugin_lazy.toml', {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

" 未インストールのプラグインをインストール
if dein#check_install()
    call dein#install()
endif

" アンイストール用コマンド
function! s:deinClean()
  if len(dein#check_clean())
      call map(dein#check_clean(), 'delete(v:val)')
      call dein#recache_runtimepath()
      echo 'dein clean finished'
  else
      echo '[ERR] no disabled plugins'
  endif
endfunction
command! DeinClean :call s:deinClean()

" nvim-lsp の設定
lua << EOF
require'nvim_lsp'.tsserver.setup{}
require'nvim_lsp'.intelephense.setup{}
--require'nvim_lsp'.vuels.setup{}
EOF

"}}}

" --------------
"   マッピング
" --------------
"{{{

" ハイライトを消す
nnoremap <silent> <Esc> :<C-u>nohlsearch<CR>

" 次のバッファへ移動
nnoremap <silent> <C-n> :<C-u>bn<CR>

" 前のバッファへ移動
nnoremap <silent> <C-p> :<C-u>bp<CR>

" 少し多めに移動
nnoremap <C-j> 8j
nnoremap <C-k> 8k

" インサートモード中に横移動
inoremap <C-b> <C-o>h
inoremap <C-f> <C-o>l

" コマンドラインで Emacs 風に移動
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>

" quickfix window 用
nnoremap ]q :<C-u>cnext<CR>
nnoremap [q :<C-u>cprevious<CR>

" LSP
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

" vim-test
nmap <silent> t<C-n> :<C-u>TestNearest<CR>
nmap <silent> t<C-f> :<C-u>TestFile<CR>
nmap <silent> t<C-s> :<C-u>TestSuite<CR>
nmap <silent> t<C-l> :<C-u>TestLast<CR>
nmap <silent> t<C-g> :<C-u>TestVisit<CR>

"}}}

" ---------------------
"   Leader マッピング
" ---------------------
"{{{

let mapleader = "\<Space>"

" 設定ファイルを開く
nnoremap <silent> <Leader>,<Space> :<C-u>call util#open_config_file()<CR>
" 設定ファイルを再読込
nnoremap <silent> <Leader>,r :<C-u>call util#reload_config_file()<CR>
" ウィンドウを閉じる
nnoremap <silent> <Leader>q :<C-u>q<CR>
" 保存
nnoremap <silent> <Leader>w :<C-u>w<CR>
" 最初のレジスタを貼り付け
nnoremap <silent> <Leader>rp "0p
" 下に改行を挿入
nnoremap <Leader>o o<ESC>
" 上に改行を挿入
nnoremap <Leader><S-o> O<ESC>
" ペーストモード切り替え
nnoremap <silent> <Leader>p :<C-u>call util#toggle_paste_mode()<CR>
" 折返しの有無の切り替え
nnoremap <silent> <Leader>wt :<C-u>call util#toggle_wrap()<CR>

" vim-indent-guides
nnoremap <silent> <Leader>ig :<C-u>IndentGuidesToggle<CR>

" vim-quickrun
nnoremap <silent> <Leader>x :<C-u>QuickRun<CR>

" Defx
nnoremap <silent> <Leader>e<Space> :<C-u>Defx -toggle<CR>
nnoremap <silent> <Leader>e. :<C-u>Defx `expand('%:p:h')` -search=`expand('%:p')`<CR>

" Denite
nnoremap <silent> <Leader>sb :<C-u>Denite buffer<CR>
nnoremap <silent> <Leader>sc :<C-u>Denite command<CR>
nnoremap <silent> <Leader>sh :<C-u>Denite command_history<CR>
nnoremap <silent> <Leader>sd :<C-u>Denite directory_rec<CR>
nnoremap <silent> <Leader>sg :<C-u>Denite grep -resume -refresh -buffer-name=denite-grep<CR>
nnoremap <silent> <Leader>sf :<C-u>Denite file/rec<CR>
nnoremap <silent> <Leader>sl :<C-u>Denite line<CR>
nnoremap <silent> <Leader>so :<C-u>Denite outline<CR>
nnoremap <silent> <Leader>sm :<C-u>Denite mark<CR>

" vista
nnoremap <silent> <Leader>v<Space> :<C-u>Vista!!<CR>

"}}}

" -----------
"   Vim設定
" -----------
" {{{

" --- 基本オプション ---
let g:netrw_dirhistmax = 0 "netrw の履歴ファイルを作らない

syntax on
"set exrc " ローカルの設定ファイルをを許可
"set secure " ローカルの設定ファイルで autocmd を許可しない
set redrawtime=10000 "重い再描画の際に syntax off になるまでの時間
set backupcopy=yes
set conceallevel=2
set concealcursor=niv

set mouse=a " マウス機能
set hidden " 隠れバッファの許可
set winminheight=0 " ウィンドウの最小の高さ
set clipboard=unnamed,unnamedplus " yank 時に '+' と '*' レジスタにコピーする
set breakindent " 行の折り返し時にインデントを考慮する
set undofile " 永続的Undo機能
set diffopt+=iwhite " vimdiff のとき空白を無視

augroup basic
    autocmd!
    " autocmd FileType vue syntax sync fromstart
augroup END

" --- カーソル移動 ---
set scrolloff=8 " 上下8行の視界を確保
set sidescrolloff=16 " 左右スクロール時の視界を確保
set sidescroll=1 " 左右スクロールは1文字ずつ行う

" --- エンコーディング ---
set encoding=utf8 " Vimが内部で用いるエンコーディング
set termencoding=utf8 " 端末の出力に用いられるエンコーディング

" --- 折りたたみ ---
set foldminlines=0
set foldmethod=manual

" --- タグ ---
" set tags=tags
set tagbsearch " タグファイル検索時に二分探索を使う
set tagcase=ignore " タグファイルの検索

" --- セッション ---
" セッションに保存する項目
set sessionoptions=buffers,curdir,folds,help,localoptions,tabpages,winpos,winsize

" --- 見た目 ---
set showmatch " 対応する括弧を強調表示
set cursorline " カーソルラインの強調表示
" set cursorcolumn " カーソルラインの強調表示（縦）
set number " 行番号の表示
set colorcolumn=100 " 縦のライン表示
set showcmd " 入力中のコマンドを表示
set list " 不可視文字を表示
set listchars=tab:>-,trail:-,eol:↲

" --- 検索 / 置換 ---
set shortmess+=I " 起動時の :intrto を非表示
set hlsearch " 検索キーワードをハイライト
set incsearch " インクリメンタル検索を有効化
set ignorecase " case-insensitive で検索する
set smartcase " 検索パターンが upper-case の場合は case-sensitive にする
set gdefault " 置換の時 g オプションをデフォルトで有効にする
set inccommand=split
set wildignore+=**/node_modules/**

" --- タブ ---
set showtabline=2 " タブラインを常に表示
set tabline=%!ui#tabline()

" --- ウィンドウ ---
set splitbelow " 新しいウィンドウを下に開く
set splitright " 新しいウィンドウを右に開く
set winwidth=30 " ウィンドウの最小幅
set winheight=25 " ウィンドウの最小の高さ
" set noequalalways " ウィンドウを閉じたり開いたりした場合に、カレントウィンドウ以外の高さ、幅を整えない

augroup window
    autocmd!
    autocmd FileType qf wincmd L | vertical resize 70 | set winfixwidth
augroup END

" --- ステータスライン ---
set laststatus=2 " ステータスラインを常に表示
set statusline=%!ui#statusline()

" --- 補完機能 ---
set wildmenu " 候補をビジュアル的に表示
set wildmode=list:full

" --- インデント ---
set tabstop=4 " タブ文字の幅
set softtabstop=4 " 削除する空白の数
set shiftwidth=4 " >>で移動するタブ幅
set autoindent " 自動インデント
set smartindent " C言語スタイルのブロックを自動挿入
set expandtab " タブ文字を空白に展開

filetype plugin indent on

augroup indent
    autocmd!
    autocmd FileType css        setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType html       setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType pug        setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType ruby       setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType sass       setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType scss       setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType vue        setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType typescript setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType toml       setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType yaml       setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

" ---------------------
"     テンプレート
" ---------------------
autocmd BufNewFile *.php 0r $XDG_CONFIG_HOME/nvim/template/t.php

" vim:set foldmethod=marker:
