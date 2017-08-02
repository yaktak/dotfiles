" --- キーマッピング ---
nnoremap j gj
nnoremap k gk
nnoremap Q <Nop>

" タブで.vimrcを開く
nnoremap <silent> <C-,> :<C-u>execute 'tabedit' . $HOME . '/.vimrc'<CR>

" 次のタブへ移動
nnoremap <silent> <C-n> :<C-u>tabnext<CR>

" 前のタブへ移動
nnoremap <silent> <C-p> :<C-u>tabprevious<CR>

" 次のウィンドウへ移動
nnoremap <C-j> <C-w>w

" 前のウィンドウへ移動
nnoremap <C-k> <C-w>W


"inoremap { {}<Left>
"inoremap {<Enter> {}<Left><CR><ESC><S-o>
"inoremap [ []<Left>
"inoremap [<Enter> []<Left><CR><ESC><S-o>
"inoremap ( ()<Left>
"inoremap (<Enter> ()<Left><CR><ESC><S-o>
"inoremap < <><Left>
"inoremap " ""<Left>
"inoremap ' ''<Left>

" --- Leaderマッピング ---
let mapleader = "\<Space>"
let b:comment_identifier = ''

function! CommentOutRow()
    if b:comment_identifier != ''
        execute 'normal I' . b:comment_identifier . ' '
    endif
endfunction

augroup mapping
    autocmd!
    autocmd BufRead *.py,*.rb let b:comment_identifier = '#'
    autocmd BufRead *.js,*.php let b:comment_identifier = '//'
    autocmd FileType vim let b:comment_identifier = '"'
augroup END


" NERTTreeの表示を切替
nnoremap <silent> <Leader>nt :<C-u>NERDTreeToggle<CR>

" vim-indent-guidesの切替
nnoremap <silent> <Leader>ig :<C-u>IndentGuidesToggle<CR>

" Highlight Marksのハイライトを全て削除
nnoremap <silent> <Leader>mh :<C-u>RemoveMarkHighlights<CR>

" 最初のレジスタを貼り付け
nnoremap <Leader>p "0p

" 現在行と列のハイライトを切替
nnoremap <Leader>cl :<C-u>setlocal cursorline! cursorcolumn!<CR>

" 1行コメントアウト
nnoremap <Leader>- :<C-u>call CommentOutRow()<CR>

" 下に改行を挿入
nnoremap <Leader><Space> o<ESC>

" 次のlowercaseのマークへジャンプ
nnoremap <Leader>] ]`

" 前のlowercaseのマークへジャンプ
nnoremap <Leader>[ [`


" --- 基本オプション ---
colorscheme molokai
syntax on

" [Backspace] で既存の文字を削除できるように設定
" start  - 既存の文字を削除できるように設定
" eol    - 行頭で[Backspace]を使用した場合上の行と連結
" indent - オートインデントモードでインデントを削除できるように設定
set backspace=start,eol,indent
set mouse=a  " マウス機能
set hidden   " 隠れバッファの許可
set paste    " ペーストの際に表示が崩れるのを防ぐ
set undofile " 永続的Undo機能


" --- ディレクトリ ---
set directory=~/.vim/tmp
set backupdir=~/.vim/tmp
set undodir=~/.vim/undo
set tags=~/.tags


" --- セッション ---
set sessionoptions=curdir,folds,help,localoptions,tabpages,winsize

" セッションファイルがロードされていた場合、Vim終了時に現在のセッションで上書きする
" ロードされていてもいなくても、previous.vimとして保存する
function! StoreSession()
    if v:this_session != ''
        execute ':mksession! ' . v:this_session
    endif
    execute ':mksession! ' . '~/.vim/sessions/previous.session.vim'
endfunction

augroup session
    autocmd!
    autocmd VimLeave * call StoreSession()
augroup END


" --- 見た目 ---
set nocursorline   " カーソルラインの強調表示
set number         " 行番号の表示
set colorcolumn=80 " 縦のライン表示
set showcmd        " 入力中のコマンドを表示


" --- 不可視文字 ---
set list
set listchars=tab:>-,trail:-,eol:↲


" --- 検索 ---
set hlsearch   " 検索キーワードをハイライト
set incsearch  " インクリメンタル検索を有効化
set ignorecase " 大文字と小文字を区別しない
set smartcase  " 小文字のときのみ区別しない


" --- タブ ---

" タブページのラベルの表示方法
" 0: 表示しない
" 1: 2個以上タブがあるときに表示
" 2: 常に表示
set showtabline=1


" --- ウィンドウ ---
set splitbelow   " 新しいウィンドウを下に開く
set splitright   " 新しいウィンドウを右に開く
set winwidth=90  " ウィンドウの最小幅
set winheight=30 " ウィンドウの最小の高さ


" --- ステータスライン ---
set laststatus=2 " ステータスラインを常に表示

function! InitStatusLine()
    " %< 切り詰め開始位置
    " %f カレントディレクトリからの相対パス
    " %m 編集したら"[+]"を表示
    " %r 読み込み専用なら"[RO]"を表示
    " %h ヘルプページなら"[HELP]"を表示
    " %w プレビューページなら"[Preview]"を表示
    " %= これ以降は右寄せで表示
    set statusline=%<%f%m%r%h%w%=
endfunction

function! SwitchStatusLineCurrent()
    call InitStatusLine()

    " 現在のセッション
    if v:this_session != ''
        " 拡張子を2段階で削除
        setlocal statusline+=[%(%{fnamemodify(fnamemodify(v:this_session,':t:r'),':r')}%)]
    else
        setlocal statusline+=[No\ Session]
    endif

    "setlocal statusline+=[%{&fileencoding}] " ファイルのエンコーディング
    setlocal statusline+=[%l/%L,%c]         " 現在行/全行数,現在列
endfunction

augroup statusLine
    autocmd!
    autocmd SessionLoadPost  * call SwitchStatusLineCurrent()
    autocmd WinEnter * call SwitchStatusLineCurrent()
    autocmd WinLeave * call InitStatusLine()
augroup END

call SwitchStatusLineCurrent()


" --- 補完機能 ---
set complete+=k           " ctrl-nでも辞書から検索されるようにする
set nowildmenu            " 候補をビジュアル的に表示しない
set wildmode=list:longest " 補完時の一覧表示機能有効化

augroup complement
    autocmd!
    autocmd BufRead *.js setlocal dictionary=$HOME.'/.vim/dict/javascript.dict'
    autocmd BufRead *.php setlocal dictionary=$HOME.'/.vim/dict/php.dict'
augroup END


" --- インデント ---
set tabstop=4     " タブ文字の幅
set softtabstop=4 " 削除する空白の数
set shiftwidth=4  " >>で移動するタブ幅
set autoindent    " 自動インデント
set smartindent   " C言語スタイルのブロックを自動挿入
set expandtab     " タブ文字を空白に展開

augroup indent
    autocmd!
    autocmd BufRead,BufNewfile *.css,*.htm,*.html,*.js,*.rb,*.tpl setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END


" --- Linting ---

" エラー表示のフォーマットを設定
set errorformat=%m\ in\ %f:\ line\ %l

augroup linting
    autocmd!
    autocmd BufRead *.php setlocal makeprg=php\ -l\ %

    " エラーがあればQuickFixに表示
    autocmd BufWritePost *.php silent make | if len(getqflist()) != 1 | copen | else | cclose | endif
augroup END


" --- ユーザー定義コマンド ---

" :Bt <N>...でバッファ番号からバックグラウンドにタブを開く
command! -nargs=+ Bt call BufsToTabs(<f-args>)
function! BufsToTabs(...)
    let l:c_tab = tabpagenr()
    for l:e in a:000
        if !buflisted(str2nr(l:e))
            echoerr "No such buffers number: " . l:e
        else
            let l:name = bufname(str2nr(l:e))
            execute 'tabedit ' . l:name 
        endif
    endfor
    execute l:c_tab . ' tabnext'
endfunction


" --- dein.vim ---

let s:dein_dir = $HOME . '/.vim/plugins/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &compatible
    set nocompatible
endif

" deinが導入されてなければclone
if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim.git' s:dein_repo_dir
endif

execute 'set runtimepath^=' . s:dein_repo_dir

call dein#begin(s:dein_dir)

" 管理するプラグイン
call dein#add(s:dein_repo_dir)
call dein#add('scrooloose/nerdtree')
call dein#add('tpope/vim-surround')
call dein#add('ToruIwashita/git-switcher.vim')
call dein#add('vim-syntastic/syntastic')
call dein#add('nathanaelkane/vim-indent-guides')
call dein#add('mtscout6/syntastic-local-eslint.vim')
call dein#add('posva/vim-vue')
call dein#add('alvan/vim-closetag')
call dein#add('tomasr/molokai')
call dein#add('Tumbler/highlightMarks')
call dein#add('gregsexton/MatchTag')

call dein#end()

" 未インストールのプラグインをインストール
if dein#check_install()
    call dein#install()
endif

filetype plugin indent on

function! s:deinClean()
  if len(dein#check_clean())
    call map(dein#check_clean(), 'delete(v:val)')
  else
    echo '[ERR] no disabled plugins'
  endif
endfunction
command! DeinClean :call s:deinClean()


" --- NERDTree ---

" Windowの横幅
let g:NERDTreeWinSize=50


" -- git-switcher.vim ---

" セッションを保存するディレクトリパス。
let g:gsw_sessions_dir = $HOME . '/.vim/sessions'

" Gswコマンド実行時にセッションの保存の確認を行う。デフォルトはyes。
let g:gsw_save_session_confirm = 'yes'

" vim起動時のセッション自動ロード設定。yes、no、confirmを設定可能でデフォルトはno。
let g:gsw_autoload_session = 'no'

" vim起動時保存したセッションのうちローカルに同じ名前のブランチが存在しないものを削除する。
" yes、no、confirmを設定可能でデフォルトはno。
let g:gsw_autodelete_sessions_if_branch_not_exist = 'no'


" --- Syntastic.vim ---

" linterの設定
let g:syntastic_javascript_checkers=['eslint']

" エラー行に sign を表示
let g:syntastic_enable_signs = 1

" location list を常に更新
let g:syntastic_always_populate_loc_list = 1

" location list を常に表示
let g:syntastic_auto_loc_list = 0

" ファイルを開いた時にチェックを実行する
let g:syntastic_check_on_open = 1

" :wq で終了する時もチェックする
let g:syntastic_check_on_wq = 0


" --- Highlight Marks ---

" signを有効にする
let g:highlightMarks_useSigns = 0
