""" .vimrc
" vim: set filetype=vim :

" William Stark (william.stark.5000@gmail.com)


set nocompatible


""" vim-plug
" Minimalist Vim Plugin Manager
" https://github.com/junegunn/vim-plug
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" install vim-plug automatically
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" specify directory for plugins
call plug#begin('~/.local/share/nvim/plugged')


""" plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ALE
" Asynchronous linting/fixing and Language Server Protocol client
" https://github.com/dense-analysis/ale
Plug 'dense-analysis/ale'

" Barbaric
" Automatic input method switching for vim
" https://github.com/rlue/vim-barbaric
Plug 'rlue/vim-barbaric'

" Colorizer
" A plugin to color colornames and codes
" https://github.com/chrisbra/Colorizer
Plug 'chrisbra/Colorizer'

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

" jedi-vim
" awesome Python autocompletion with VIM
" https://github.com/davidhalter/jedi-vim
Plug 'davidhalter/jedi-vim'

" NERD Commenter
" easy commenting/uncommenting
" https://github.com/scrooloose/nerdcommenter
Plug 'scrooloose/nerdcommenter'

" NERD Tree
" tree explorer plugin
" https://github.com/scrooloose/nerdtree
Plug 'scrooloose/nerdtree'

" vim-perl
" support for Perl 5
" https://github.com/vim-perl/vim-perl
Plug 'vim-perl/vim-perl', { 'for': 'perl', 'do': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny' }

" repeat.vim
" enable repeating supported plugin maps with "."
" https://github.com/tpope/vim-repeat
Plug 'tpope/vim-repeat'

" rust.vim
" Vim configuration for Rust
" https://github.com/rust-lang/rust.vim
Plug 'rust-lang/rust.vim'

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

" vim-ghost
" edit browser textarea contents in Neovim with GhostText
" https://github.com/raghur/vim-ghost
" https://github.com/GhostText/GhostText
" https://chrome.google.com/webstore/detail/ghosttext/godiecgffnchndlihlpaajjcplehddca
" requirements (install in the pyenv neovim virtual environment) :
" pip install SimpleWebSocketServer
" pip install python-slugify
" sudo apt install xdotool
" run "GhostInstall" in Neovim
"Plug 'raghur/vim-ghost', {'do': ':GhostInstall'}

" vim-gitgutter
" show a git diff in the gutter
" https://github.com/airblade/vim-gitgutter
Plug 'airblade/vim-gitgutter'

" vim-json
" better JSON for VIM
" https://github.com/elzr/vim-json
Plug 'elzr/vim-json'

" vim-markdown
" Markdown for Vim
" https://github.com/gabrielelana/vim-markdown
Plug 'gabrielelana/vim-markdown'
let g:markdown_enable_spell_checking = 0
" disable insert mode mappings
let g:markdown_enable_insert_mode_mappings = 0

" vim-polyglot
" A collection of language packs for Vim.
" https://github.com/sheerun/vim-polyglot
"let g:polyglot_disabled = ['markdown']
"Plug 'sheerun/vim-polyglot'

" vim-uppercase-sql
" Automatically uppercase SQL keywords as you type
" https://github.com/alcesleo/vim-uppercase-sql
" NOTE
" use my own fork that adds support for more SQL keywords
" https://github.com/williamstark01/vim-uppercase-sql
Plug 'williamstark01/vim-uppercase-sql'


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
nnoremap Q <nop>


""" automatically change working directory to the directory of the current file
autocmd BufEnter * if expand('%:p') !~ '://' | :lcd %:p:h | endif


""" jump to the last cursor position of previously opened files
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \     exe "normal g`\"" |
    \ endif


""" rename current file
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
nnoremap ,r :call RenameFile()<cr>


""" make f search case insensitive
nmap f :call FindChar()<CR>
function FindChar()
    let c = nr2char(getchar())
    while col('.') < col('$') - 1
        normal l
        if getline('.')[col('.') - 1] ==? c
            break
        endif
    endwhile
endfunction


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
" set a marker on the 81th text column
set colorcolumn=81


""" folds
" automatic folds based on syntax
set foldmethod=indent
set foldnestmax=1


""" set the color scheme
colorscheme Tomorrow


""" visible whitespace
" http://vimcasts.org/episodes/show-invisibles/
" Shortcut to rapidly toggle `set list`
nnoremap <Leader>l :set list!<CR>
" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬


""" use system-wide directories for swap files
set backupdir=~/.vim/tmp/backup/
set directory=~/.vim/tmp/swap/
set undodir=~/.vim/tmp/undo/


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

" ino Arduino sketches
autocmd FileType ino setlocal tabstop=2 softtabstop=2 shiftwidth=2

" JavaScript
autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2

" JSON
autocmd BufNewFile,BufRead *.json set filetype=json

" make
" makefiles require tabs for indentation
autocmd FileType make setlocal noexpandtab

" Markdown
autocmd BufNewFile,BufRead *.md set filetype=markdown
" override vim-markdown adding +, -, : to word ranges
" https://github.com/gabrielelana/vim-markdown/blob/master/ftplugin/markdown.vim#L71
autocmd FileType markdown set iskeyword-=+
autocmd FileType markdown set iskeyword-=-
autocmd FileType markdown set iskeyword-=:

" Perl
" don't autocomplete from included files
autocmd FileType perl set complete-=i
autocmd FileType perl setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent

" Python
autocmd FileType py setlocal textwidth=79 tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent
autocmd FileType python setlocal completeopt-=preview
" don't highlight trailing whitespace
let python_highlight_space_errors = 0

" SQL
autocmd FileType sql setlocal tabstop=2 softtabstop=2 shiftwidth=2

" yaml
" yaml files require spaces for indentation
autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2

" Treat .rss files as XML
"autocmd BufNewFile,BufRead *.rss setfiletype xml
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
autocmd BufWritePre *.c,*.css,*.cu,*.h,*.html,*.ino,*.md,*.markdown,*.js,*.pl,*.pm,*.py,*.sh,*.sql,*.tex,*.txt :call <SID>StripTrailingWhitespaces()

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


""" Neovim settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""" preview substitutions
if exists(':inccommand')
    " TODO
    " also try
    "set inccommand=split
    set inccommand=nosplit
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


""" plugin settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""" ALE
" disable Flake8 and Pylint in Neovim
"let b:ale_linters = ['flake8', 'pylint']
let b:ale_linters = []
" only run linters named in ale_linters settings
let g:ale_linters_explicit = 1


""" EasyMotion
let g:EasyMotion_leader_key = '<Leader>'
hi link EasyMotionTarget2First EasyMotionTarget
hi link EasyMotionTarget2Second EasyMotionTarget


""" fugitive.vim
" vertical splits on Gdiff
set diffopt+=vertical


""" vim-gitgutter
" reduce update time of diff markers
set updatetime=100
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


""" Tagbar
" toggle Tagbar
nnoremap <F8> :TagbarToggle<CR>


""" vim-json
" disable JSON syntax concealing
let g:vim_json_syntax_conceal = 0


" vim-polyglot / vim-markdown
" https://github.com/plasticboy/vim-markdown
"let g:vim_markdown_conceal = 0
"let g:vim_markdown_conceal_code_blocks = 0
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
