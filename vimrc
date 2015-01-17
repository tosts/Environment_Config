" Vundle Plugin managment {{{

    set nocompatible
    filetype off

    set runtimepath+=~/.vim/bundle/Vundle.vim
    let path='~/.vim/bundle'
    call vundle#begin()
        Plugin 'gmarik/Vundle.vim'

        Plugin 'kien/ctrlp.vim'

        Plugin 'scrooloose/nerdtree'
        Plugin 'scrooloose/nerdcommenter'
        Plugin 'scrooloose/syntastic'
        Plugin 'PProvost/vim-ps1'

        Plugin 'tpope/vim-surround'
        Plugin 'tpope/vim-repeat'
        Plugin 'tpope/vim-fugitive'

        Plugin 'AndrewRadev/linediff.vim'
        Plugin 'vim-scripts/ingo-library'
        Plugin 'vim-scripts/AdvancedDiffOptions'
        Plugin 'godlygeek/tabular'


        " Plugin 'spf13/vim-autoclose'

        Plugin 'vim-scripts/YankRing.vim'
        "Plugin 'mileszs/ack.vim'
        Plugin 'rking/ag.vim'

        Plugin 'mattn/emmet-vim'
        " Fun
        Plugin 'vim-scripts/loremipsum'
        " Plugin 'bling/vim-airline'

        " colorschemes
        Plugin 'altercation/vim-colors-solarized'
        Plugin 'tpope/vim-vividchalk'
        Plugin 'nanotech/jellybeans.vim'
        Plugin 'Lokaltog/vim-distinguished'
        Plugin 'garybernhardt/dotfiles', {'rtp': '.vim'}
        Plugin 'mindriot101/srw-colorscheme.vim'
        " not working either
        Plugin 'vim-scripts/wombat256.vim'
        Plugin 'gmarik/ingretu'
        Plugin 'desert-warm-256'

    call vundle#end()
    filetype plugin indent on

" }}}

" Vim config fixup {{{

    set nocompatible
    set modelines=0

    " Folding {{{

        augroup filetype_vim
            autocmd!
            autocmd FileType vim setlocal foldmethod=marker
        augroup END

    " }}}
    " Whitespace {{{

        set tabstop=4
        set shiftwidth=4
        set softtabstop=4
        set expandtab

    " }}}
    " Search {{{

        " smart search matches
        set ignorecase smartcase

        " already search while typing
        set incsearch showmatch hlsearch

    " }}}
    " Appearence {{{

        set nowrap
        syntax on

        set number
        set relativenumber
        set ruler
        set cursorline
        nnoremap <F2> :set invnumber \| set invrelativenumber<return>

        "colorscheme wombat256mod
        set background=dark

    " }}}
    " Editing/Behavior {{{

        set smartindent autoindent

        set backspace=indent,eol,start

        set undofile
        set undodir=~/.vim/vimundo
        set directory=~/.vim/vimswp
        set autoread

        set enc=utf-8

        " emacs navigation in command mode {{{

            cnoremap <C-A> <Home>
            cnoremap <C-F> <Right>
            cnoremap <C-B> <Left>
            cnoremap <C-D> <Delete>
            " cnoremap <M-F> <S-Right> " broken
            " cnoremap <M-B> <S-Left> " broken
            cnoremap jk <C-C>

        " }}}

    "}}}

" }}}
" Custom Behavior {{{

    " Misc sanity {{{

        " no more accidential man page lookup!
        nnoremap K <nop>

        " sanely navigate wrapped lines
        nnoremap j gj
        nnoremap k gk

        nnoremap <silent><Space> :silent nohlsearch<Bar>echo<return>

    " }}}
    " Personal essentials {{{

        " convenient tab switching
        nnoremap <C-H> gT
        nnoremap <C-L> gt

        nnoremap <silent> <leader>ev :tabnew $MYVIMRC<return>
        nnoremap <leader>sv :source $MYVIMRC<return> :echo 'resourced .vimrc'<return>
        if has('win32')
            nnoremap <silent> <leader>ep :tabnew $HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1<return>
        endif

        inoremap jk <esc>
        nnoremap <silent> <leader>q :q!<return>
        nnoremap <leader>w :w<return>:echo 'saved'<return>
        nnoremap <leader>e :Ex<return>
        "nnoremap <leader>n :tabnew<return> -> plugins
        "nnoremap <silent> <leader>r :redraw!<return>

    " }}}
    " Personal preference {{{

        " match 'very' magic by default
        vnoremap / /\v
        nnoremap / /\v

        nnoremap <tab> %
        vnoremap <tab> %

        noremap <C-j> <C-w>j
        noremap <C-k> <C-w>k

        set pastetoggle=<F3>
        " purge trailing whitespace
        map <leader>dw :%s/\s\+$//g<cr>

        nnoremap <silent> * :let @/='\<<C-R>=expand("<cword>")<cr>\>'<cr>:set hlsearch<cr>

        " missing privilege override
        cmap w!! w !sudo tee > /dev/null %

    " }}}
    " Perl {{{

        au BufRead,BufNewFile *.t setfiletype perl
        " do not un-indent #-comments (see smartindent)
        inoremap # X#

    " }}}

    set wildignore+=*.class,*.swp,*.svn,*.hg,*.so,*/target/**,*/target-eclipse/**,*/tmp/*

" }}}
" Plugins {{{

    nnoremap <leader>t :CtrlP<return>

    let g:NERDTreeWinSize=70
    nnoremap <leader>n :NERDTreeFind<return>

    ca ack Ack
    ca ag Ag

    vnoremap <leader>a, :Tabularize /\v,@<= /l0c0<return>
    vnoremap <leader>a: :Tabularize /:/l0c1<return>
    vnoremap <leader>a; :Tabularize /\v,@<= /r0c0<return>
    vnoremap <leader>a= :Tabularize /=<return>
    " escaped mapping, result keymap: \a|
    nnoremap <leader>a\| vip:Tabularize /\|\{1,2}<return>

    nnoremap <silent> <F11> :YRShow<return>

    vnoremap <leader>ld :Linediff<return>
    nnoremap <leader>lr :LinediffReset<return>

    nnoremap <leader>gs :Gstatus<return>
    nnoremap <leader>gl :Git log<return>
    nnoremap <leader>gsr :Git svn rebase<return>
    nnoremap <leader>gsd :Git svn dcommit<return>

    let g:syntastic_enable_perl_checker=1

" }}}
" Advanced Functions {{{

    " Highlight trailing whitespace {{{

        :highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
        match ExtraWhitespace /\s\+$/
        augroup highlight_trailing_whitespace
            autocmd!
            autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
            autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
            autocmd InsertLeave * match ExtraWhitespace /\s\+$/
            autocmd BufWinLeave * call clearmatches()
        augroup END

    " }}}
    " Execute in Shell function {{{

        function! s:ExecuteInShell(command)
          let command = join(map(split(a:command), 'expand(v:val)'))
          let winnr = bufwinnr('^' . command . '$')
          silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
          setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
          echo 'Execute ' . command . '...'
          silent! execute 'silent %!'. command
          silent! execute 'resize ' . line('$')
          silent! redraw
          silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
          silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<cr>'
          echo 'Shell command ' . command . ' executed.'
        endfunction

        command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
        ca shell Shell

        command! -complete=file -nargs=+ Git call s:ExecuteInShell('git '.<q-args>)
        ca git Git

        command! -complete=shellcmd -nargs=+ Prove call s:ExecuteInShell('prove '.<q-args>)
        ca prove Prove
        nnoremap <F6> :Prove -v %<Return>

        command! -complete=shellcmd -nargs=+ MysqlFeed call s:ExecuteInShell('mysql '.<q-args>)
        ca mysql MysqlFeed
        nnoremap <F7> :MysqlFeed -u root \< %<Return>

        command! -complete=file -nargs=* Octave execute s:ExecuteInShell('octave '.<q-args>)
        cabbrev octave Octave
        map <F9> :Octave %<return>

        command! -complete=file -nargs=0 Node execute s:ExecuteIntoWindow('node', 'node '.<q-args>)
        cabbrev node Node
        map <F10> :Node %<return>

    " }}}
    " Perl {{{

        noremap <leader>sd ouse feature 'say';<cr>use Data::Dumper;<cr>say 'XO'x50;<cr>say <cr>say 'XO'x50;<esc>k$a
        nnoremap <leader>rsd :%s/\( *use feature 'say';\n *use Data::Dumper;\n *say 'XO'x50;\n *say .\{-}\n *say 'XO'x50;\n\)//g<cr>

    " }}}
    " groovy {{{

        noremap <leader>xlx olog.info 'XO'*75<cr>log.info <cr>log.info 'XO'*75<esc>k$a
        nnoremap <leader>sfd :set ft=diff<cr> -- conflict with 'Say with Dumper'

    " }}}
    " Tmux interop (tslime fail) {{{

        " should be refined
        nnoremap <leader>r :call system("tmux send-keys -t work:0.1 C-P Enter")<return>

    " }}}

" }}}

set background=dark
colorscheme default
