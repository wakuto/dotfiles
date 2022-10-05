let vimdir = $HOME.'/.vim/'
if !isdirectory(vimdir)
  call mkdir(vimdir)
endif
" 行番号を表示
set number

" 折り返しなし
set nowrap

" ベルをオフ
set belloff=all

if !exists('g:vscode')
  " coc.nvimの表示がバグるため一時的にOFF
  " set ambiwidth=double
endif

" インデント関連
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent
" 可視化
set list
set listchars=tab:>-,multispace:»\ ,trail:-,extends:»,precedes:«

" いつでもバックスペースでの削除を有効化
set backspace=indent,eol,start

" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore

"文字コード関連
set fenc=utf-8
scriptencoding utf-8
set encoding=utf-8

" backup, swap関連
set nobackup
set noswapfile

" 編集中のファイルが変更されたら自動で読み直す
set autoread

set cursorline      " 現在の行をハイライト
hi clear CursorLine " 上と合わせることで行番号のみハイライト

" cdコマンドの設定---------
" https://vim-jp.org/vim-users-jp/2009/09/08/Hack-69.html
command! -nargs=? -complete=dir -bang CD  call s:ChangeCurrentDir('<args>', '<bang>')
function! s:ChangeCurrentDir(directory, bang)
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . a:directory
    endif

    if a:bang == ''
        pwd
    endif
endfunction

" Change current directory.
nnoremap <silent> <Space>cd :<C-u>CD<CR>
"--------------------------

" undoファイルの設定
try 
  if has('persistent_undo')
    let undo_path = expand(vimdir.'undo')
    exe 'set undodir=' .. undo_path
    set undofile
  endif
catch
  echo "could not set infinite undo"
endtry


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
call AddPlugin('https://github.com/Yggdroot/indentLine.git')
call AddPlugin('https://github.com/mbbill/undotree.git')
if !exists('g:vscode')
  call AddPlugin('https://github.com/neoclide/coc.nvim.git')
endif

" キーマップ

" ノーマルモードでもエンターで改行
noremap <CR> o<ESC>

" ESCをjjにマップ
inoremap jj <ESC>

" NERDTree
nnoremap <silent> <C-e> :NERDTreeToggle<CR>

" UndoTree
nnoremap <F5> <Cmd>UndotreeToggle<CR>

" split command
nnoremap sh <C-w>h
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l

" 色設定
" colorscheme material
colorscheme desert
syntax on

" coc settings------------
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction


if !exists('g:vscode')
  nnoremap <silent> <C-]> <Plug>(coc-definition)
  " use <tab> for trigger completion and navigate to the next complete item

  inoremap <silent><expr> <Tab>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<Tab>" :
        \ coc#refresh()

  nnoremap <F6> <Plug>(coc-rename)
endif
" ------------------------
