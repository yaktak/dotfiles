""" 関数定義 """
function! InitStatusLine()
    " 切り詰め開始位置
    " %F ファイルのフルパス
    " %m 編集したら"[+]"を表示
    " %r 読み込み専用なら"[RO]"を表示
    " %h ヘルプページなら"[HELP]"を表示
    " %w プレビューページなら"[Preview]"を表示
    " %= これ以降は右寄せで表示
    setlocal statusline=[%<%f%m%r%h%w]%=
endfunction

function! InitCurrentStatusLine()
    setlocal statusline=[%<%t%m%r%h%w]%=
endfunction

function! AddStatusLineInfo()
    " 現在のセッション
    " 拡張子を2段階で削除
    if v:this_session != ''
        setlocal statusline+=[%(%{fnamemodify(fnamemodify(v:this_session,':t:r'),':r')}%)]
    endif
    " ファイルのエンコーディング
    "set statusline+=\ \|\ %{&fileencoding}
    " 現在行/全行数,現在列
    setlocal statusline+=[%l/%L,%c]
endfunction

function! StoreSession()
    if v:this_session != ''
        execute ':mksession! ' . v:this_session
    endif
    execute ':mksession! ' . '~/.vim/sessions/previous.session.vim'
endfunction

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
call pathogen#infect()
"call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

""" プラグイン設定 """
" NERDTree
" Windowの横幅
let g:NERDTreeWinSize=50

" git-switcher.vim
" セッションを保存するディレクトリパス。
let g:gsw_sessions_dir = $HOME . '/.vim/sessions'
" Gswコマンド実行時にセッションの保存の確認を行う。デフォルトはyes。
let g:gsw_save_session_confirm = 'yes'
" vim起動時のセッション自動ロード設定。yes、no、confirmを設定可能でデフォルトはno。
let g:gsw_autoload_session = 'no'
" vim起動時保存したセッションのうちローカルに同じ名前のブランチが存在しないものを削除する。
" yes、no、confirmを設定可能でデフォルトはno。
let g:gsw_autodelete_sessions_if_branch_not_exist = 'no'

" syntastic.vim
" lintの設定
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

""" キーマッピング """
nnoremap <silent> <C-n> :<C-u>NERDTreeToggle<CR>
nnoremap <Space> o<ESC>
nnoremap <silent> <Tab> :<C-u>tabnext<CR>
nnoremap <silent> <S-Tab> :<C-u>tabprevious<CR>
nnoremap <C-p> <C-i>
nnoremap j gj
nnoremap k gk
nnoremap Q <Nop>
"inoremap { {}<Left>
"inoremap {<Enter> {}<Left><CR><ESC><S-o>
"inoremap [ []<Left>
"inoremap [<Enter> []<Left><CR><ESC><S-o>
"inoremap ( ()<Left>
"inoremap (<Enter> ()<Left><CR><ESC><S-o>
"inoremap < <><Left>
"inoremap " ""<Left>
"inoremap ' ''<Left>

" カラースキーム
colorscheme molokai

" [Backspace] で既存の文字を削除できるように設定
" start - 既存の文字を削除できるように設定
" eol - 行頭で[Backspace]を使用した場合上の行と連結
" indent - オートインデントモードでインデントを削除できるように設定
set backspace=start,eol,indent

" 特定のキーに行頭および行末の回りこみ移動を許可する設定
" b - [Backspace]  ノーマルモード ビジュアルモード
" s - [Space]      ノーマルモード ビジュアルモード
"   - [→]          ノーマルモード ビジュアルモード
" [ - [←]          挿入モード 置換モード
" ] - [→]          挿入モード 置換モード
" ~ - ~            ノーマルモード
set whichwrap=b,s,[,],,~

set mouse=a    " マウス機能有効化
set cursorline " カーソルラインの強調表示を有効化
set number     " 行番号を表示
set colorcolumn=80 " 80文字目に縦のラインを表示
set hidden " 隠れバッファを許容
set paste " ペーストの際に表示が崩れるのを防ぐ
set showcmd " 入力中のコマンドを表示

" シンタックスハイライト有効化
syntax on

" 補完機能関連
set complete+=k " ctrl-nでも辞書から検索されるようにする
set nowildmenu            " 候補をビジュアル的に表示しない
set wildmode=list:longest " 補完時の一覧表示機能有効化

" インデント関連
set list
"set listchars=tab:\▸\-,trail:-,eol:↲ " 不可視文字を可視化(タブが「▸-」と表示される)
set listchars=trail:▢
set tabstop=2    " タブ文字の幅
set shiftwidth=2 " >>で移動するタブ幅
set autoindent   " 自動インデント
set expandtab    " タブ文字を空白に展開

" 検索関連
set hlsearch   " 検索キーワードをハイライト
set incsearch  " インクリメンタル検索を有効化
set ignorecase " 大文字と小文字を区別しない
set smartcase  " 小文字のときのみ区別しない

" タブ関連
set showtabline=2 " タブページを常に表示

" ウィンドウ
set splitbelow " 新しいウィンドウを下に開く
set splitright " 新しいウィンドウを右に開く
" 以下のオプションは他のウィンドウがカレントウィンドウになるたびに使用される
set winwidth=80  "ウィンドウの最小幅
set winheight=30 " ウィンドウの最小の高さ

" ステータスライン
set laststatus=2 " ステータスラインを常に表示
call InitStatusLine()
call AddStatusLineInfo()

" ディレクトリ関連
set directory=~/.vim/tmp
set backupdir=~/.vim/tmp
set tags=~/.tags

" 永続的Undoを有効にする
if has('persistent_undo')
    set undodir=~/.vim/undo
    set undofile
endif

" セッションを保存する際の設定
set sessionoptions=blank,buffers,curdir,folds,help,localoptions,tabpages,winsize

" autoコマンド
augroup vimrc
    " 全てのvimrcのautocmdを削除
    autocmd!
    " PHPファイルの時にコード補完用の辞書を読み込み 
    autocmd FileType php set dictionary=~/.vim/dict/php.dict
    " PHPファイルの時にmakeで文法チェック
    autocmd FileType php set makeprg=php\ -l\ %
    " エラー表示のフォーマットを設定
    autocmd FileType php set errorformat=%m\ in\ %f\ on\ line\ %l
    " PHPファイルを保存した時にエラーがあればQuickFixに表示
    autocmd BufWritePost *.php silent make | if len(getqflist()) != 1 | copen | else | cclose | endif
    autocmd FileType javascript set dictionary=~/.vim/dict/javascript.dict
    " ウィンドウが切り替わる度にステータスラインの表示を変える
    autocmd WinEnter * call InitCurrentStatusLine() | call AddStatusLineInfo()
    autocmd WinLeave * call InitStatusLine()
    " セッションファイルがロードされていた場合、Vim終了時に現在のセッションで上書きする
    " ロードされていてもいなくても、previous.vimとしても保存する
    autocmd VimLeave * call StoreSession()
augroup END
