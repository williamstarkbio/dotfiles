" vim: set filetype=vim :


set nocompatible


" vim-plug
" Minimalist Vim Plugin Manager
" https://github.com/junegunn/vim-plug
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" specify directory for plugins
call plug#begin(stdpath('data') . '/plugged')

" Barbaric
" Automatic input method switching for vim
" https://github.com/rlue/vim-barbaric
Plug 'rlue/vim-barbaric'

" Colorizer
" A plugin to color colornames and codes
" https://github.com/chrisbra/Colorizer
Plug 'chrisbra/Colorizer'

" Copilot.vim
" Neovim plugin for GitHub Copilot
" https://github.com/github/copilot.vim
"Plug 'github/copilot.vim'

" csv.vim
" filetype plugin for CSV files
" https://github.com/chrisbra/csv.vim
Plug 'chrisbra/csv.vim'

" EasyMotion
" improved motion shortcuts
" https://github.com/easymotion/vim-easymotion
Plug 'Lokaltog/vim-easymotion'

" fugitive.vim
" a git wrapper
" https://github.com/tpope/vim-fugitive
Plug 'tpope/vim-fugitive'

" IndexedSearch.vim
" Show "Match 123 of 456 /search term/" in Vim searches.
" https://github.com/henrik/vim-indexed-search
Plug 'henrik/vim-indexed-search'

" NERD Commenter
" powerful comment functions
" https://github.com/preservim/nerdcommenter
Plug 'preservim/nerdcommenter'

" NERD Tree
" file system explorer
" https://github.com/preservim/nerdtree
Plug 'preservim/nerdtree'

" nextflow-vim
" Nextflow syntax
" https://github.com/LukeGoodsell/nextflow-vim
"Plug 'LukeGoodsell/nextflow-vim'

" repeat.vim
" enable repeating supported plugin maps with "."
" https://github.com/tpope/vim-repeat
Plug 'tpope/vim-repeat'

" rust.vim
" Vim configuration for Rust
" https://github.com/rust-lang/rust.vim
Plug 'rust-lang/rust.vim'

" vim-sanegx
" make gx work correctly
" https://github.com/felipec/vim-sanegx
" https://github.com/vim/vim/issues/4738#issuecomment-856925080
Plug 'felipec/vim-sanegx'

" SimpylFold
" correct Python code folding
" https://github.com/tmhedberg/SimpylFold
Plug 'tmhedberg/SimpylFold'

" vim-slime
" Vim to REPL interactive programming
" https://github.com/jpalardy/vim-slime
Plug 'jpalardy/vim-slime'

" supertab
" Perform all your vim insert mode completions with Tab
" https://github.com/ervandew/supertab
Plug 'ervandew/supertab'

" surround.vim
" quoting/parenthesizing made simple
" https://github.com/tpope/vim-surround
Plug 'tpope/vim-surround'

" Tomorrow Theme
" a great color scheme
" https://github.com/chriskempson/tomorrow-theme
Plug 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}

" viewdoc
" flexible viewer for any documentation source
" https://github.com/powerman/vim-plugin-viewdoc
Plug 'powerman/vim-plugin-viewdoc'

" vim-gitgutter
" show a git diff in the gutter
" https://github.com/airblade/vim-gitgutter
Plug 'airblade/vim-gitgutter'

" vim-json
" better JSON for VIM
" https://github.com/elzr/vim-json
Plug 'elzr/vim-json'

" vim-markdown
" syntax highlighting, matching rules and mappings for the original Markdown and extensions
" https://github.com/preservim/vim-markdown
Plug 'preservim/vim-markdown'
" comment out TableFormat command:
" $HOME/.local/share/nvim/plugged/vim-markdown/ftplugin/markdown.vim
" command! -buffer TableFormat call s:TableFormat()

" vim-uppercase-sql
" Automatically uppercase SQL keywords as you type
" https://github.com/jsborjesson/vim-uppercase-sql
" NOTE
" use my fork that uses official lists of SQL keywords
" https://github.com/williamstark01/vim-uppercase-sql
Plug 'williamstark01/vim-uppercase-sql'

" load local plugins
source ~/.config/nvim/local_plugins.vim

call plug#end()
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" syntax highlighting
syntax enable
" show (partial) command in the last line of the screen
set showcmd
" display line numbers
set number
" set the default encoding to utf-8
set encoding=utf-8
" map space to the leader key in all modes
map <Space> <Leader>
" disable the Ex mode
nnoremap Q <Nop>

" disable shortcut to increment or decrement a number after the cursor
map <C-a> <Nop>
map <C-x> <Nop>

""" automatically change working directory to the directory of the current file
autocmd BufEnter * if expand('%:p') !~ '://' | :lcd %:p:h | endif


""" jump to the last cursor position of previously opened files
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \     exe "normal g`\"" |
    \ endif


""" make f search case insensitive
function FindChar()
    let c = nr2char(getchar())
    while col('.') < col('$') - 1
        normal l
        if getline('.')[col('.') - 1] ==? c
            break
        endif
    endwhile
endfunction
nnoremap f :call FindChar()<CR>


""" convert MediaWiki text format to MarkDown
function! MediaWiki_to_Markdown()
    %s/=====$//g
    %s/====$//g
    %s/===$//g
    %s/==$//g
    %s/=$//g
    %s/^=====/##### /g
    %s/^====/#### /g
    %s/^===/### /g
    %s/^==/## /g
    %s/^=/# /g
    %s/^<pre>/```/g
    %s/^<\/pre>/```/g
endfunction
command! MediaWikiToMarkdown call MediaWiki_to_Markdown()


""" whitespace
" wrap, wrapping
" http://vim.wikia.com/wiki/Word_wrap_without_line_breaks
" enable "visual" wrapping
"set wrap
" Don't split words when wrapping long lines.
set linebreak
set nolist  " list disables linebreak
" http://stackoverflow.com/questions/2280030/how-to-stop-line-breaking-in-vim
" this turns off physical line wrapping (ie: automatic insertion of newlines)
set textwidth=0
set wrapmargin=0
"set formatoptions+=l
set showtabline=2


""" default indentation
" one indentation level is 4 spaces unless overridden
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent


""" command line completion
set wildmode=longest,full
set wildmenu
" case insensitive filename completion
set wildignorecase


""" search
" case insensitive searches on queries with small letters
set ignorecase
" case sensitive searches on queries containing mixed case letters
set smartcase
" jump to the first match of the search pattern while entering it
set incsearch
" don't highlight matches of a search pattern
set nohlsearch


""" mark the target width of source code lines
" set a marker on the 89th (88+1) text column (88 is the Black max line length setting)
set colorcolumn=89


""" folds
" automatic folds based on syntax
set foldmethod=indent
set foldnestmax=1


""" set the color scheme
colorscheme Tomorrow


""" visible whitespace
" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬
"set listchars=tab:▸\ ,eol:$
" http://vimcasts.org/episodes/show-invisibles/
" shortcut to rapidly toggle `set list`
function! ToggleVisibleWhitespace()
    set list!
endfunction
nnoremap <Leader>l :call ToggleVisibleWhitespace()<CR>

" use Bash login shell in terminal
set shell=bash\ --login

""" filetype specific settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" manually set a new filetype
" see :h new-filetype
"autocmd BufNewFile,BufRead *.blue set filetype=blue

" C
autocmd BufNewFile,BufRead *.h set filetype=c

" CSS
autocmd FileType css setlocal tabstop=2 softtabstop=2 shiftwidth=2

" HTML
autocmd FileType html setlocal tabstop=2 softtabstop=2 shiftwidth=2

" JavaScript
autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2

" JSON
autocmd BufNewFile,BufRead *.json set filetype=json

" make
" makefiles require tabs for indentation
autocmd FileType make setlocal noexpandtab

" Markdown
autocmd BufNewFile,BufRead *.md set filetype=markdown
" syntax highlighting for fenced code blocks
"let g:markdown_fenced_languages = ['python', 'bash=sh']

" Python
autocmd FileType py setlocal textwidth=88 tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent
autocmd FileType python setlocal completeopt-=preview
" don't highlight trailing whitespace
let python_highlight_space_errors = 0

" SQL
autocmd FileType sql setlocal tabstop=2 softtabstop=2 shiftwidth=2

" yaml
" yaml files require spaces for indentation
autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""" strip trailing whitespace
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" http://vim.wikia.com/wiki/Remove_unwanted_spaces
" http://vimcasts.org/episodes/tidying-whitespace/
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

" strip trailing whitespace on save
" NOTE
" order file extensions alphabetically
autocmd BufWritePre *.c,*.css,*.h,*.html,*.md,*.markdown,*.nf,*.js,*.py,*.sh,*.sql,*.tex,*.txt :call <SID>StripTrailingWhitespaces()

" map the <SID>StripTrailingWhitespaces function to a shortcut
nnoremap ,w :call <SID>StripTrailingWhitespaces()<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""" custom shortcuts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" open a new tab with t
nnoremap t :tabedit<Space>

" don't place text deleted by x, X, or pasted over, in the default register
nnoremap x "_x
nnoremap X "_X
vnoremap p "_dP
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""" spell checking
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set the spell checking language to American English
set spelllang=en_us

" toggle spell checking
" http://vim.wikia.com/wiki/Toggle_spellcheck_with_function_keys
nnoremap ,s :setlocal spell!<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""" create parent directories on save
" http://stackoverflow.com/questions/4292733/vim-creating-parent-directories-on-save
function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END


""" open folds when opening a file
autocmd BufRead * normal zR


""" copy and paste transparently to and from the system clipboard
set clipboard+=unnamedplus


""" enable modeline
" run custom Vim commands placed in the initial lines of opened files
set modeline
" the number of lines that is checked for set commands
set modelines=2


""" don't include the period in a word range
set iskeyword-=.


""" insert a tab character with Shift+Tab in insert mode
inoremap <S-Tab> <C-V><Tab>


""" enable mouse support
set mouse=a


""" select a line without the newline character
" https://stackoverflow.com/questions/20165596/select-entire-line-in-vim-without-the-new-line-character/61624228#61624228
vnoremap al :<C-U>normal 0v$h<CR>
omap al :normal val<CR>
vnoremap il :<C-U>normal ^vg_<CR>
omap il :normal vil<CR>


""" Neovim settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" preview substitutions
if exists(':inccommand')
    " TODO
    " also try
    "set inccommand=split
    set inccommand=nosplit
endif

" set Neovim Python path
" https://github.com/deoplete-plugins/deoplete-jedi/wiki/Setting-up-Python-for-Neovim#using-virtual-environments
let g:python3_host_prog = $PYENV_ROOT . '/versions/neovim/bin/python'
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""" plugin settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""" Copilot.vim
let g:copilot_node_command = '~/.nvm/versions/node/v16.17.0/bin/node'
let g:copilot_filetypes = {
      \ '*': v:false,
      \ 'python': v:false,
      \ }


""" EasyMotion
let g:EasyMotion_leader_key = '<Leader>'
hi link EasyMotionTarget2First EasyMotionTarget
hi link EasyMotionTarget2Second EasyMotionTarget


""" fugitive.vim
" vertical splits on Gdiff
set diffopt+=vertical


""" vim-gitgutter
" reduce update time of diff markers
set updatetime=200
" set sign colors
highlight GitGutterAdd ctermfg=green
highlight GitGutterChange ctermfg=yellow
highlight GitGutterDelete ctermfg=red
"highlight GitGutterChangeDelete ctermfg=yellow
" always show the sign column
set signcolumn=yes


""" NERD Tree
" show hidden files
let NERDTreeShowHidden=1


""" SimpylFold
let g:SimpylFold_fold_docstring = 0
let g:SimpylFold_fold_import = 0


""" vim-slime
let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "1"}
let g:slime_dont_ask_default = 1
"let g:slime_python_ipython = 1
let g:slime_no_mappings = 1
xmap <c-c><c-c> <Plug>SlimeRegionSend
"nmap <c-c><c-c> <Plug>SlimeParagraphSend
nmap <c-c><c-c> <Plug>SlimeLineSend
nmap <c-c>v <Plug>SlimeConfig


""" supertab
let g:SuperTabDefaultCompletionType = "<c-n>"
"let g:SuperTabContextDefaultCompletionType = "<c-n>"


""" Tagbar
" toggle Tagbar
nnoremap <F8> :TagbarToggle<CR>


""" vim-json
" disable JSON syntax concealing
let g:vim_json_syntax_conceal = 0
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" more
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" load local configuration file
source ~/.config/nvim/local.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
