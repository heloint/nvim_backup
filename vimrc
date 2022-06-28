" Basic settings------------------------------
" --------------------------------------------
set clipboard=unnamedplus
set number
set mouse=a
set ts=4 sw=4 expandtab
set noswapfile
set nobackup
set smartindent
set autoindent
set incsearch
set ignorecase
set smartcase
set nowrap
set hidden
set laststatus=2
" set statusline=%f "tail of the filename
set statusline=%<\ %f\ %m%r%y%w%=%l\/%-6L\ %3c\
set scrolloff=10
set showcmd

" Show the matching pair of tagsii -----------
" --------------------------------------------
set showmatch

" Highlight current line ---------------------
" --------------------------------------------
set cursorline
:hi Cursorline cterm=NONE ctermbg=236

" Run current python script from Vim--------------------
" Environment must be enabled before hand if needed-----
" ------------------------------------------------------
nmap <F5> <Esc>:w<CR>:!clear;python %<CR>

" Use hjkl with ctrl while in insert--------------
" ------------------------------------------------
inoremap <C-d> <Bs>
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>


" Autoclosing symbols-----------------------
" ------------------------------------------
" inoremap ( ()<Esc>i
" inoremap { {}<Esc>i
inoremap {<CR> {<CR>}<Esc><S-O>
" inoremap [ []<Esc>i
" inoremap ' ''<Esc>i
" inoremap " ""<Esc>i
" inoremap < <><Esc>i

" Shift-Tab for tabbing backwards-----------
" ------------------------------------------
inoremap <S-Tab> <Esc><<i

" Enclosing selected part between symbols-------
" ----------------------------------------------
xnoremap " c""<Esc>P
xnoremap " c""<Esc>P
xnoremap ' c''<Esc>P
xnoremap ( c()<Esc>P
xnoremap { c{}<Esc>P
xnoremap [ c[]<Esc>P
xnoremap * c**<Esc>P

" Old enclosing mappings -----------------
" ----------------------------------------
" xnoremap " :s/\%V\(.*\)\%V/"\1"/<CR> 
" xnoremap ' :s/\%V\(.*\)\%V/'\1'/<CR> 
" xnoremap ( :s/\%V\(.*\)\%V/(\1)/<CR>
" xnoremap { :s/\%V\(.*\)\%V/{\1}/<CR>
" xnoremap [ :s/\%V\(.*\)\%V/[\1]/<CR>
" xnoremap * :s/\%V\(.*\)\%V/*\1*/<CR>

" Insert and 'de-insert' tab in visual mode.
" ------------------------------------------
xnoremap <Tab> >
xnoremap <S-Tab> <

" Insert/Remove multiple linebreaks---------
" ------------------------------------------
xnoremap <CR> :s/$/\r/g <CR>
xnoremap <Bs> :g/^$/d <CR>

" File explorer -----------------------------
" -------------------------------------------
inoremap <C-b> <Esc>:Lexplore<CR>
nnoremap <C-b> <Esc>:Lexplore<CR>
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_winsize=30

" Autocomplete menu -------------------------------------------------
" -------------------------------------------------------------------
set completeopt=longest,menuone,noinsert
set pumheight=5

autocmd BufNewFile,BufRead *.py set complete+=k~/.vim/dictionaries/python_dict.txt
autocmd BufNewFile,BufRead *.js set complete+=k~/.vim/dictionaries/javascript_dict.txt
autocmd BufNewFile,BufRead *.css set complete+=k~/.vim/dictionaries/css_dict.txt

inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
 \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

filetype plugin on
set omnifunc=ale#completion#OmniFunc

" Convert line into a single column---------------
" ------------------------------------------------
command -range Column :'<,'>s/,\ /\r/g

" From a column of variable names create Python class self.variable assignments.
" ------------------------------------------------------------------------------
command -range Pyself :'<,'>s/\%V\(.*\)\%V/        self.\1\ \=\ \1/g 

" Open a terminals in split. Bterm to below and Vterm for vertical right.
" -----------------------------------------------------------------------
command Bterminal :below terminal
command Vterminal set splitright|:vertical terminal

" Comment and uncomment the selected rows in .py files.-----
" ----------------------------------------------------------
au FileType python command -range Comment :'<,'>norm i# <Esc>
au FileType javascript command -range Comment :'<,'>norm i// <Esc>

au FileType python command -range Uncomment :'<,'>s/^# //g
au FileType javascript command -range Uncomment :'<,'>s/^\/\/ //g

" Collect(yank J for selected test), Empty(empty register j), Dump(put j)
command -range Collect :'<,'>yank J
command Dump :put j
command Empty :let @j=""

" ALE LINTING -----------------------------------------------------
" Install A.L.E. linting plugin. Works way too well for python.----
" mkdir -p ~/.vim/pack/git-plugins/start
" git clone --depth 1 https://github.com/dense-analysis/ale.git ~/.vim/pack/git-plugins/start/ale


" INDENTLINE PLUGIN -------------------------------------------------
" Install 'indentLine' plugin. Works well for html,css and stuff.----
" git clone https://github.com/Yggdroot/indentLine.git ~/.vim/pack/vendor/start/indentLine
" vim -u NONE -c "helptags  ~/.vim/pack/vendor/start/indentLine/doc" -c "q"

" VIM-CLOSETAG PLUGIN ----------------------------------------------
" Install vim-closetag for html
" git clone https://github.com/alvan/vim-closetag ~/.vim

let g:indentLine_color_term = 239

" Auto load templates -------------------------------------
" ---------------------------------------------------------

" Linters for Python
 let g:ale_linters = { 'python': ['pyflakes', 'mypy', 'pyright', 'flake8']}
 let g:ale_linters = { 'javascript': ['eslint']}

" When open a new HTML file with vim, a basic HTML template will be loaded.
autocmd BufNewFile *.html 0r ~/.vim/templates/html.skel 

" Auto-saving certain file types as it's modified ------------------------------
" autocmd BufNewFile,BufRead *.md :autocmd TextChanged,TextChangedI <buffer> silent write
" autocmd BufNewFile,BufRead *.py :autocmd TextChanged,TextChangedI <buffer> silent write
" autocmd BufNewFile,BufRead *.sql :autocmd TextChanged,TextChangedI <buffer> silent write
" autocmd BufNewFile,BufRead *.c :autocmd TextChanged,TextChangedI <buffer> silent write
" autocmd BufNewFile,BufRead *.html :autocmd TextChanged,TextChangedI <buffer> silent write
" autocmd BufNewFile,BufRead *.css :autocmd TextChanged,TextChangedI <buffer> silent write
" autocmd BufNewFile,BufRead *.js :autocmd TextChanged,TextChangedI <buffer> silent write



nnoremap <F7> :!cp -r % /home/user/Desktop/phylomizer/server/pipe/<CR>
nnoremap <F8> :!cp -r % /home/user/Desktop/phylomizer/server/pipe/phylomizer_py3<CR>
nnoremap <F9> :e!<CR>
