let vimdir = $HOME.'/.vim/'
if !isdirectory(vimdir)
  call mkdir(vimdir)
endif
" 行番号を表示
set number
set relativenumber

scriptencoding utf-8
set encoding=utf-8

" ベルをオフ
set belloff=all

" シンタックスを有効化
syntax on

set ambiwidth=double
" タブをスペースに変換
set expandtab

" インデント類
set autoindent
set smartindent

" 行頭でのTab文字の表示幅
set shiftwidth=2

" バックスペースができないの解消
set backspace=indent,eol,start

" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore

"文字コードをUFT-8に設定
set fenc=utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread

" クリップボードを有効化
set clipboard=unnamedplus

"画面上でタブ文字が占める幅
set tabstop=2

"連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set softtabstop=2

set cursorline      " 現在の行をハイライト
hi clear CursorLine " 上と合わせることで行番号のみハイライト

" infinite undo
try 
  if has('persistent_undo')
    let undo_path = expand(vimdir.'undo')
    "set undodir=~/.vim/.undodir
    exe 'set undodir=' .. undo_path
    set undofile
  endif
catch
  echo "could not set infinite undo"
endtry

" ノーマルモードでもエンターで改行
noremap <CR> o<ESC>

" NERDTreeを簡単に開く
nnoremap <silent><C-e> :NERDTreeToggle<CR>

" いつでもバックスペースでの削除を有効化
set backspace=indent,eol,start

" エディタウィンドウの末尾から2行目にステータスラインを常時表示させる
set laststatus=2
" ステータス行に表示させる情報の指定(どこからかコピペしたので細かい意味はわかっていない)
"set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

" プラグインの設定
let g:plugins = []
let s:plugdir = vimdir.'plugins/'

function! AddPlugin(repo)
  if !isdirectory(s:plugdir)
    call mkdir(s:plugdir)
  endif
  call add(g:plugins, a:repo)
  let directory_name = split(split(g:plugins[-1], '/')[-1], '\.')[0]
  if !isdirectory(s:plugdir.directory_name)
    echo 'Cloning '.a:repo.' ...'
    call system('git clone '.g:plugins[-1].' '.s:plugdir.directory_name)
  endif
  execute 'set runtimepath+='.s:plugdir.directory_name
endfunction

function! UpdatePlugins()
  for repo in g:plugins
    let directory_name = split(split(repo, '/')[-1], '\.')[0]
    echo 'Pulling '.repo.' ...'
    call system('git -C '.s:plugdir.directory_name.' pull origin master')
  endfor
endfunction

call AddPlugin('https://github.com/preservim/nerdtree.git')
call AddPlugin('https://github.com/itchyny/lightline.vim.git')
call AddPlugin('https://github.com/kaicataldo/material.vim.git')
call AddPlugin('https://github.com/terryma/vim-multiple-cursors.git')
call AddPlugin('https://github.com/nathanaelkane/vim-indent-guides.git')
call AddPlugin('https://github.com/vim-syntastic/syntastic.git')
call AddPlugin('https://github.com/mbbill/undotree.git')
call AddPlugin('https://github.com/prabirshrestha/vim-lsp.git')
call AddPlugin('https://github.com/mattn/vim-lsp-settings.git')
call AddPlugin('https://github.com/prabirshrestha/asyncomplete.vim.git')
call AddPlugin('https://github.com/prabirshrestha/asyncomplete-lsp.vim.git')
"call AddPlugin('https://github.com/Shougo/deoplete.nvim.git')

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

nnoremap <F5> :UndotreeToggle<cr>

set termguicolors
colorscheme material

" split command
nnoremap sp :sp<Return>
nnoremap sv :vs<Return>
nnoremap sh <C-w>h
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l

" asyncomplete.vim
let g:asyncomplete_auto_popup = 0

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
