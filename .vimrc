set shell=/bin/bash



" vim-plug
" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'tomtom/tcomment_vim'
Plug 'preservim/tagbar'
Plug 'sjl/badwolf'
Plug 'godlygeek/tabular'
Plug 'vim-scripts/a.vim'
Plug 'vim-airline/vim-airline'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Plug 'vim-scripts/Conque-GDB'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'
Plug 'idanarye/vim-merginal'
" Plug 'https://github.com/Valloric/YouCompleteMe.git'
"Plug 'Valloric/YouCompleteMe'
Plug 'tenfyzhong/vim-gencode-cpp'
Plug 'Raimondi/delimitMate'
Plug 'christoomey/vim-tmux-navigator'
Plug 'michaeljsmith/vim-indent-object'
Plug 'chris2schill/vim-enum-to-string'
Plug 'tomtom/tinykeymap_vim'
Plug 'easymotion/vim-easymotion'
Plug 'brooth/far.vim'
" Plug 'ilyachur/cmake4vim'
" Plug 'cpiger/NeoDebug'
Plug 'puremourning/vimspector'
call plug#end()

" Run PlugInstall if there are missing plugins
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif



" Vanilla vim settings
syntax on
filetype plugin on
packadd termdebug
set nocompatible
set showcmd
set sm
set ic
set ts=4
set showmode
set ruler
set nostartofline
set hlsearch
set hidden
set wildmenu
set backspace=indent,eol,start
set ai
set t_vb=
set mouse=a
set visualbell
set confirm
set cmdheight=2
" set shellcmdflag=-ic
set notimeout ttimeout timeoutlen=5
set pastetoggle=<F11>
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set notimeout
set ttimeout
set timeoutlen=1000
set nowrap
set laststatus=2
set ttymouse=sgr
set incsearch
set lazyredraw
set foldmethod=manual
"set foldlevelstart=1
set nobackup
set nowritebackup
set noswapfile
set cmdheight=1
set textwidth=180
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.ali,*.o,*.tgz
"set termguicolors
"set nohlsearch
set t_Co=256
inoremap {<cr> {<cr>}<c-o>O
xnoremap p pgvy
augroup CppGroup
    autocmd!
    autocmd BufEnter *.c :setlocal filetype=cpp
    autocmd BufEnter * :set number
    autocmd BufEnter * :set relativenumber
    autocmd BufEnter *.gls :setlocal filetype=gls
    autocmd BufEnter *.menu :setlocal filetype=cpp
augroup END
" disable automatic commenting new lines below comments
autocmd FileType * set formatoptions-=cro
let mapleader = ","
nnoremap <leader>vimrc  :tabe ~/Documents/vimrc/.vimrc<CR>
nnoremap <leader>bashrc :tabe ~/.bashrc<cr>
augroup VimrcGroup
    autocmd!
    autocmd BufWritePost ~/Documents/vimrc/.vimrc source $MYVIMRC
augroup end

if has("gui_running")
	colorscheme badwolf
    " Guioptions
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guioptions-=rS
    set guioptions-=L
    set termguicolors
    set guifont=Monospace\ 9
else
	colorscheme badwolf
endif

let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"
" augroup remember_folds
"   autocmd!
"   autocmd BufWinLeave ?* silent! mkview | filetype detect
"   autocmd BufWinEnter ?* silent! loadview | filetype detect
" augroup END

" Alt-Mapping fix
let c='a'
while c <= 'z'
    exec "set <A-".c.">=\e".c
    exec "imap \e".c." <A-".c.">"
    let c = nr2char(1+char2nr(c))
endw
set timeout ttimeoutlen=50
inoremap <esc> <C-c>

" Zoom / Restore window.
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> `` :ZoomToggle<cr>

:command! -nargs=1 Silent execute ':silent !'.<q-args> | execute ':redraw!'


" Snippets
nnoremap <leader>for :read ~/.vim/for_loop.txt<cr>V3j=fBcw

vnoremap <C-r> "hy:%s/<C-r>h//c<left><left>
" vmap <C-r>lat "hy:%s/<C-r>h//c<left><left>\=<C-r>h+(-10.939841)<cr>y
" vmap <C-r>lon "hy:%s/<C-r>h//c<left><left>\=<C-r>h+(27.486909)<cr>y
vmap <C-r>lat "hy:%s/<C-r>h//c<left><left>\=<C-r>h+(-11.055608)<cr>y
vmap <C-r>lon "hy:%s/<C-r>h//c<left><left>\=<C-r>h+(27.504011)<cr>y
vmap <C-r>elevation "hy:%s/<C-r>h//c<left><left>\=<C-r>h+(-4090)<cr>y
vmap <C-r>minel "hy:%s/<C-r>h//c<left><left>\=<C-r>h+(10)<cr>y

let @q = '/latf=llvi"lat'
let @a = '/latitudef=llvi"lat'
let @w = '/lonf=llvi"lon'
let @s = '/longitudef=llvi"lon'
let @d = '/elevationf=llvi"elevation'

function! UtahToTyndallF()
    silent :g/lat="/norm! @q
    silent :g/latitude="/norm! @a
    silent :g/lon="/norm! @w
    silent :g/longitude="/norm! @s
    silent :g/elevation="/norm! @d
endfunction

command! UtahToTyndall :call UtahToTyndallF()


function! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfunction
nnoremap <F5> :call TrimWhitespace()<cr>


nnoremap <leader><C-k> :move-2<cr>==
xnoremap <leader><C-k> :move-2<cr>gv=gv
nnoremap <leader><C-j> :<C-u>move+<cr>==
xnoremap <leader><C-j> :move'>+<cr>gv=gv

" call tinykeymap#EnterMap('mlines', 'gm', {'name': 'MLines mode'})
" call tinykeymap#Map('mlines', 'k', ':move-2<cr>==')
" call tinykeymap#Map('mlines', 'j', ':move+<cr>==')
" nnoremap <C-m><C-k> :call MoveLineUp()<cr>
" nnoremap <C-m><C-j> :call MoveLineDown()<cr>
" xnoremap <C-m><C-k> :call MoveBlockUp()<cr>
" xnoremap <C-m><C-j> :call MoveBlockDown()<cr>
"

" function MoveLineUp() abort
"     execute  ":move-2<cr>=="
"     silent! call repeat#set("\", -1)
" endfunction
" function MoveLineDown() abort
"     execute ":move+"
"     silent! call repeat#set("\", -1)
" endfunction
"
" function MoveBlockUp() abort
"     execute ":move-2<cr>gv=gv"
"     silent! call repeat#set("\", -1)
" endfunction
"
" function MoveBlockDown() abort
"     "let lines = a:lastline-a:firstline+1
"     execute ":move'>+<cr>gv=gv"
"     silent! call repeat#set("\gv=gv", -1)
" endfunction

" Build & Run

" ALL
" nnoremap <leader>r :!./load_up &<cr>

let DIR = "/hcnat/schill"
let RESOURCE_DIR = DIR."/src/display_renderer/resources"
let CONFIG_DIR = DIR."/src/cockpit_sim"

" HDD / AMU / CNIMU
nnoremap <leader>c
    \ :Dispatch cockpit_sim<cr>
nnoremap <leader>p
    \ :Dispatch display_renderer com_nav_ecb 127.0.0.1 127.0.0.1 6978 debug<cr>
nnoremap <leader>r 
    \ :execute ':Dispatch /opt/rst/us_blk3/start'<cr>
    " \ :execute ':Dispatch '.DIR.'/load_up debug'<cr>
    " \ :execute ':Dispatch '.DIR.'/build/cockpit_sim -config-dir '.DIR.'/src/cockpit_sim'<cr>
    " \ :execute ':Dispatch '.DIR.'/build/display_renderer -device amu         -p 6976 -resource-dir '.RESOURCE_DIR.' -title "AMU Pilot"             -mouse-and-keyboard -overlay'<cr>
    " \ :execute ':Dispatch '.DIR.'/build/display_renderer -device hdd -p 6969 -resource-dir '.RESOURCE_DIR.' -title "HDD 1 (Pilot Left)" -mouse-and-keyboard -fxaa'<cr>
    " \ :execute ':Dispatch '.DIR.'/build/display_renderer -device cnimu       -p 6973 -resource-dir '.RESOURCE_DIR.' -title "CDU Pilot" -mouse-and-keyboard -overlay'<cr>
    " \ :execute ':Dispatch '.DIR.'/build/display_renderer -device com_nav_ecb -p 6978 -resource-dir '.RESOURCE_DIR.' -title "COM-NAV-ECB"           -mouse-and-keyboard -overlay'<cr>
    " \ :execute ':Dispatch '.DIR.'/build/display_renderer -device arc210 -p 6981 -resource-dir '.RESOURCE_DIR.' -title "ARC-210" -mouse-and-keyboard'<cr>
    " \ :execute ':Dispatch '.DIR.'/build/display_renderer -device tpa-100a -p 6982 -resource-dir '.RESOURCE_DIR.' -title "MILACAS-XR" -mouse-and-keyboard'<cr>
    " \ :execute ':Dispatch '.DIR.'/build/display_renderer -device skl -resource-dir '.RESOURCE_DIR.' -title "SKL" -mouse-and-keyboard'<cr>
    " \ :execute ':Dispatch '.DIR.'/build/display_renderer -device ghcp -p 6983 -resource-dir '.RESOURCE_DIR.' -title "Get Home Control Panel"'<cr>
    " \ :execute ':Dispatch '.DIR.'/build/display_renderer -device ifr-4000            -resource-dir '.RESOURCE_DIR.' -title "IFR-4000"              -mouse-and-keyboard  -overlay'<cr>
    " \ :execute ':Dispatch '.DIR.'/build/display_renderer -device hdd         -p 6972 -resource-dir '.RESOURCE_DIR.' -title "HDD 4 (Copilot Right)" -mouse-and-keyboard -log '.DIR.' /logs/hdd4_copilot_right.log'<cr>
    " \ :execute ':Dispatch '.DIR.'/build/display_renderer -device hdd         -p 6970 -resource-dir '.RESOURCE_DIR.' -title "HDD 2 (Pilot Right)"   -mouse-and-keyboard -log '.DIR.' /logs/hdd2_pilot_right.log'<cr>
    " \ :execute ':Dispatch '.DIR.'/build/display_renderer -device hdd         -p 6971 -resource-dir '.RESOURCE_DIR.' -title "HDD 3 (Copilot Left)"  -mouse-and-keyboard -log '.DIR.' /logs/hdd3_copilot_left.log'<cr>
    " \ :execute ':Dispatch '.DIR.'/build/display_renderer -device hdd         -p 6979 -resource-dir '.RESOURCE_DIR.' -title "HDD 5 (Engineer)"      -mouse-and-keyboard -log '.DIR.' /logs/hdd5_engineer.log'<cr>
    " \ :execute ':Dispatch '.DIR.'/build/display_renderer -device cnimu       -p 6974 -resource-dir '.RESOURCE_DIR.' -title "CDU Copilot"           -mouse-and-keyboard -log '.DIR.' /logs/cdu_copilot.log  -overlay'<cr>
    " \ :execute ':Dispatch '.DIR.'/build/display_renderer -device cnimu       -p 6975 -resource-dir '.RESOURCE_DIR.' -title "CDU Engineer"          -mouse-and-keyboard -log '.DIR.' /logs/cdu_engineer.log -overlay'<cr>
    " \ :execute ':Dispatch '.DIR.'/build/display_renderer -device amu         -p 6977 -resource-dir '.RESOURCE_DIR.' -title "AMU Copilot"           -mouse-and-keyboard -log '.DIR.' /logs/amu_copilot.log  -overlay'<cr>
    " \ :Silent ssh root@toradex "export DISPLAY=:0 && cd / && ./display_renderer"&<cr>
    " \ :execute ':Dispatch '.DIR.'/build/rend'<cr>
let $LD_LIBRARY_PATH = '/opt/rst/us_blk3'
let $LD_PRELOAD = '/usr/lib64/libtiff.so.5'

" nnoremap <leader>l
"     \ :execute ':Termdebug LD_LIBRARY_PATH=/opt/rst/us_blk3/ LD_PRELOAD=/usr/lib64/libtiff.so.5 /opt/rst/us_blk3/rst_us_ah64_blk3'<cr>
" nnoremap <leader>r
"     \ :execute ':Termdebug /opt/rst/us_blk3/rst_us_ah64_blk3'<cr>

" command GdbFlight   :exe ":Termdebug ezhostgtk " .  trim(system("pgrep ezhostgtk"))
nnoremap <leader>k
    \ :!pkill -SIGINT display_r<cr>
    \ :!pkill -SIGINT cockpit_sim<cr>
    \ :!pkill -SIGINT tail<cr>:cclose<cr>
    \ :cclose<cr>
    " \ :Dispatch ssh root@toradex "pkill -9 display_r"<cr> ; pkill -9 display_r ; pkill -9 cockpit_sim<cr>
" nnoremap <leader>m :Dispatch :Make -C /hcnat/hcnat/build -j6 && sudo make -C /hcnat/hcnat/build install<cr> 
" nnoremap <leader>m :Dispatch /hcnat/hcnat/build.sh && scp /hcnat/hcnat/build_arm/src/display_renderer/renderer_arm/renderer root@toradex:/<cr>
nnoremap <leader>s :Dispatch rsync -rtlavz --rsh="/usr/bin/sshpass -p natios ssh -o StrictHostKeyChecking=no -l hcnat" /hcnat/schill/ hcnat@hcnat2:/hcnat/schill<cr>
" nnoremap <leader><leader>s :Dispatch rsync -rtlavz --rsh="/usr/bin/sshpass -p natios ssh -o StrictHostKeyChecking=no -l hcnat" /hcnat/schill/ hcnat@10.10.180.39:/hcnat/schill<cr>

" nnoremap <leader>m 
"             \ :Dispatch make -C /hcnat/hummingboard/linux-fslc/ -j6 zImage dtbs modules LD=${CROSS_COMPILE}ld.bfd INSTALL_MOD_PATH=/hcnat/hummingboard/linux-fslc/modules && make modules_install && sudo ./install_kernel.sh<cr>

nnoremap <leader>m 
            \ :Make -C /home/camtt/camtt_src/trunk/build -j6 && ~/install.sh<cr>
            " \ :Dispatch ~/install.sh<cr>
            " \ :Make -C /hcnat/hcnat/build -j5<cr>
            " \ :execute ':Dispatch g++ -std=c++17 -I/hcnat test.cpp test_sm.cpp -o testsm'<cr>
            " \ :Make -C /hcnat/hcnat/build_arm -j6 && scp /hcnat/hcnat/build_arm/display_renderer root@toradex:/<cr>
            " \ :Make -C /hcnat/hcnat/build/src/display_renderer -j6<cr>
            " \ :Make -C /hcnat/hcnat/build_arm/src/display_renderer -j6 && scp /hcnat/hcnat/build_arm/display_renderer root@toradex:/<cr>
            " \ :cclose<cr>
" nnoremap <leader>d :execute ':ConqueGdb --args '.DIR.'/build/cockpit_sim '.DIR.'/config/host.ini'<cr>
" nnoremap <leader>d :execute ':!/opt/rst/us_blk3/start_ddd &'<cr>
" nnoremap <leader>d :ConqueGdb --args display_renderer cnimu 127.0.0.1 127.0.0.1 6973 debug<cr>
" nnoremap <leader>d :Dispatch cockpit_sim<cr>:ConqueGdb --args display_renderer cnimu 127.0.0.1 127.0.0.1 6973 debug<cr>


"GL Studio Open
" nnoremap <leader>gls :Dispatch FONTCONFIG_PATH=/etc/fonts QT_PLUGIN_PATH=/home/camtt/glstudio/bin /home/camtt/glstudio/bin/glStudio %<cr>
nnoremap <leader><leader>gls :!FONTCONFIG_PATH=/etc/fonts QT_PLUGIN_PATH=/home/camtt/glstudio/bin /home/camtt/glstudio/bin/glStudio % &<cr> 
" Save/Quit and Window/Tab Movement
nnoremap <leader>q :quitall<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <A-l> :tabnext<cr>
nnoremap <A-h> :tabprev<cr>
nnoremap <leader>T <c-w><Enter><c-w>T
nnoremap <C-q> :q<CR>
inoremap <C-q> <Esc>:q<CR>
nnoremap <C-Q> :q!<CR>
inoremap <C-Q> <Esc>:q!<CR>
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR><Esc>
nnoremap gb :ls<cr>:b<space>
nnoremap <A-p> "+p
" Cycle through buffers
"nnoremap ] :bnext<CR>
"nnoremap [ :bprevious<CR>
function! GotoJump()
    jumps
    let j = input("Please select your jump: ")
    if j != ''
        let pattern = '\v\c^\+'
        if j =~ pattern
            let j = substitute(j, pattern, '', 'g')
            execute "normal " . j . "\<c-i>"
        else
            execute "normal " . j . "\<c-o>"
        endif
    endif
endfunction
nmap <leader>j :call GotoJump()<CR>


" ====================================================== Plugins =============================================== "


" ------------------------------------------------------ NERDTree ----------------------------------------------- "
let g:NERDTreeWinSize = 35
let g:NERDTreeChDirMode = 0
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader><leader>n :NERDTreeFind<CR>
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1



" ------------------------------------------------------ tcomment ----------------------------------------------- "
nnoremap <c-_> gcc
inoremap <c-_> <c-o>:normal gcc
vnoremap <c-_> :normal gcc



" ------------------------------------------------------ CTags/Tagbar ----------------------------------------------- "
set tags=./tags;/
nnoremap <leader>ct :!ctags -R .<CR>
nnoremap <C-F> :CtrlPTag<CR>
nnoremap <leader>b :TagbarToggle<CR>
nnoremap <leader>tn :tn<cr>
nnoremap <leader>tp :tp<cr>
nnoremap <leader>]t :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
nnoremap <leader>]v :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
nnoremap <leader>]h :sp <CR>:exec("tag ".expand("<cword>"))<CR>
let g:tagbar_left = 0



" -------------------------------------------------- a.vim (Header Switcher) -------------------------------------------- "
nnoremap <leader>h :A<cr>
nnoremap <leader><leader>h <c-w>v:A<cr>



" -------------------------------------------- C++ Enhanced Syntax Highlight ------------------------------------ "
let g:cpp_class_scope_highlight     = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight      = 1



" ----------------------------------------------------- Airline  ------------------------------------------------ "
let g:airline_skip_empty_sections             = 1
let g:airline_inactive_collapse               = 1
let g:airline_section_y                       = ''
let g:airline_section_b                       = ''
let g:airline_section_warning                 = ''
let g:airline#extensions#tabline#enabled      = 0
let g:airline#extensions#tabline#formatter    = 'unique_tail'
let g:airline#extensions#tabline#left_sep     = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#whitespace#enabled   = 0
let g:airline_highlighting_cache=1
"set showtabline=2



" ----------------------------------------------------- Gruvbox  ------------------------------------------------ "
let g:gruvbox_contrast_dark      = "hard"
let g:gruvbox_contrast_light     = "hard"
let g:gruvbox_vert_split         = "bg1"
"let g:gruvbox_termcolors         = 256
let g:gruvbox_bold               = 1
let g:gruvbox_italic             = 1
let g:gruvbox_italicize_comments = 0
let g:gruvbox_italicize_strings  = 0
let g:gruvbox_improved_strings   = 0
let g:gruvbox_improved_warnings  = 1
let g:gruvbox_invert_tabline     = 0
set background=dark



" ----------------------------------------------------- Conque GDB  ------------------------------------------- "
"nnoremap <leader><leader>d :ConqueGdb /avcatt/avcsimc_dev/avcsim/ah64e40/avc/suite/mm/computer/load/bin1/cpu2_seq5
let g:ConqueGdb_Leader      = '\'
let g:ConqueGdb_Run         = g:ConqueGdb_Leader . 'r'
let g:ConqueGdb_Continue    = g:ConqueGdb_Leader . 'c'
let g:ConqueGdb_Next        = g:ConqueGdb_Leader . 'n'
let g:ConqueGdb_Step        = g:ConqueGdb_Leader . 's'
let g:ConqueGdb_Print       = g:ConqueGdb_Leader . 'p'
let g:ConqueGdb_ToggleBreak = g:ConqueGdb_Leader . 'b'
let g:ConqueGdb_SetBreak    = g:ConqueGdb_Leader . 'b'
let g:ConqueGdb_Finish      = g:ConqueGdb_Leader . 'f'
let g:ConqueGdb_Backtrace   = g:ConqueGdb_Leader . 't'
let g:ConqueTerm_FastMode   = 1

" ----------------------------------------------------- TermDebug ------------------------------------------- "
let g:termdebug_wide=1
let g:termdebug_use_prompt=0
" set termwinsize=0x40
" command GdbAvionics :exe ":Termdebug rst_us_ah64_blk3 " .  trim(system("pgrep rst_us"))
" command GdbAvionics :exe feedkeys("iattach " . trim(system('pgrep rst_us_ah64_blk')))
" command GdbFlight   :exe ":Termdebug ezhostgtk " .  trim(system("pgrep ezhostgtk"))
" command GdbIMS      :exe ":Termdebug ims " .  trim(system("pgrep ims"))
" command GdbIMI      :exe ":Termdebug imi " .  trim(system("pgrep imi"))
" command GdbSequencer :exe ":Termdebug sequencer " .  trim(system("pgrep sequencer"))
" call tinykeymap#EnterMap('debug_select', '<leader><leader>d', {'name': 'GDB Process select', 'after':'norm! <esc>' })
" call tinykeymap#Map('debug_select', 'a', 'GdbAvionics')
" call tinykeymap#Map('debug_select', 'f', 'GdbFlight')
" call tinykeymap#Map('debug_select', 'i', 'GdbIMS')
" call tinykeymap#Map('debug_select', 'c', 'GdbIMI')
" nnoremap <leader><leader>da :GdbAvionics<cr>
" nnoremap <leader><leader>d :Termdebug<cr>
let g:neodbg_keymap_print_variable = '<leader>dp'
let g:neodbg_keymap_terminate_debugger = '<leader>dq'
" nnoremap <leader>dn :Over<cr>
" nnoremap <leader>db :Break<cr>
" nnoremap <leader>du :Until<cr>
" nnoremap <leader>ds :Step<cr>
" nnoremap <leader>df :Finish<cr>
" nnoremap <leader>dc :Continue<cr>
" nnoremap <leader>de :Evaluate<cr>
" nnoremap <leader>ddb :Clear<cr>
command! -nargs=1 Silent execute ':silent !'.<q-args> | execute ':redraw!'

command DisableGitIgnore :exe ":Silent mv .gitignore .gitignore.bak" 
command EnableGitIgnore :exe ":Silent mv .gitignore.bak .gitignore"

command EnableRtdbg :exe ":Silent git apply --reject --whitespace=fix ~/patch_files/rtdbg_agt_integration.patch"
command DisableRtdbg :exe ":Silent git apply -R ~/patch_files/rtdbg_agt_integration.patch"

" ----------------------------------------------------- Vimspector ------------------------------------------- "
command Debug :call vimspector#Launch()
nnoremap <leader>dq :call vimspector#Reset()<cr>
nnoremap <leader>dc :call vimspector#Continue()<cr>
nnoremap <leader>db :call vimspector#ToggleBreakpoint()<cr>
nnoremap <leader>dn :call vimspector#StepOver()<cr>
nnoremap <leader>df :call vimspector#StepOut()<cr>
nnoremap <leader>ds :call vimspector#StepInto()<cr>
nnoremap <leader>dd :call vimspector#DownFrame()<cr>
nnoremap <leader>du :call vimspector#UpFrame()<cr>
nnoremap <leader>dB :VimspectorBreakpoints<cr>
nnoremap <leader>dm :call vimspector#GoToCurrentLine()<cr>


function GdbAvionicsD()
    if system("pgrep rst_us") > 0
        call vimspector#LaunchWithConfigurations( {
            \    "attach": {
            \      "adapter": "vscode-cpptools",
            \      "breakpoints": {
            \        "exception": {
            \          "all": "N",
            \          "uncaught": "N"
            \        }
            \      },
            \      "configuration": {
            \        "request": "attach",
            \        "program": "/opt/rst/us_blk3/rst_us_ah64_blk3",
            \        "processId": system("pgrep rst_us"),
            \        "cwd": "/opt/rst/us_blk3",
            \        "MIMode": "gdb",
            \        "setupCommands": [
            \          {
            \            "description": "Enable pretty-printing for gdb",
            \            "text": "set print pretty on",
            \            "ignoreFailures": "true",
            \          }
            \        ]
            \      }
            \    }
            \ } )
    else
        call vimspector#LaunchWithConfigurations( {
            \    "attach": {
            \      "adapter": "vscode-cpptools",
            \      "breakpoints": {
            \        "exception": {
            \          "all": "N",
            \          "uncaught": "N"
            \        }
            \      },
            \      "configuration": {
            \        "request": "launch",
            \        "program": "/opt/rst/us_blk3/rst_us_ah64_blk3",
            \        "cwd": "/opt/rst/us_blk3",
            \        "MIMode": "gdb",
            \        "setupCommands": [
            \          {
            \            "description": "Enable pretty-printing for gdb",
            \            "text": "set print pretty on",
            \            "ignoreFailures": "true",
            \          }
            \        ]
            \      }
            \    }
            \ } )
    endif
endfunction

function GdbIMSD()
    if system("pgrep ims") > 0
        call vimspector#LaunchWithConfigurations( {
            \    "attach": {
            \      "adapter": "vscode-cpptools",
            \      "breakpoints": {
            \        "exception": {
            \          "all": "N",
            \          "uncaught": "N"
            \        }
            \      },
            \      "configuration": {
            \        "request": "attach",
            \        "program": "/opt/rst/IMS/ims",
            \        "processId": system("pgrep ims"),
            \        "cwd": "/opt/rst/IMS",
            \        "MIMode": "gdb",
            \        "setupCommands": [
            \          {
            \            "description": "Enable pretty-printing for gdb",
            \            "text": "set print pretty on",
            \            "ignoreFailures": "true",
            \          }
            \        ]
            \      }
            \    }
            \ } )
    else
        call vimspector#LaunchWithConfigurations( {
            \    "attach": {
            \      "adapter": "vscode-cpptools",
            \      "breakpoints": {
            \        "exception": {
            \          "all": "N",
            \          "uncaught": "N"
            \        }
            \      },
            \      "configuration": {
            \        "request": "launch",
            \        "program": "/opt/rst/IMS/ims",
            \        "cwd": "/opt/rst/IMS",
            \        "MIMode": "gdb",
            \        "setupCommands": [
            \          {
            \            "description": "Enable pretty-printing for gdb",
            \            "text": "set print pretty on",
            \            "ignoreFailures": "true",
            \          }
            \        ],
            \        "environment": [
            \          { "name": "LD_LIBRARY_PATH", "value": "/opt/rst/IMS" }
            \        ]
            \      }
            \    }
            \ } )
    endif
endfunction

function GdbIMID()
    if system("pgrep imi") > 0
        call vimspector#LaunchWithConfigurations( {
            \    "attach": {
            \      "adapter": "vscode-cpptools",
            \      "breakpoints": {
            \        "exception": {
            \          "all": "N",
            \          "uncaught": "N"
            \        }
            \      },
            \      "configuration": {
            \        "request": "attach",
            \        "program": "/opt/rst/Imi/imi",
            \        "processId": system("pgrep imi"),
            \        "cwd": "/opt/rst/Imi",
            \        "MIMode": "gdb",
            \        "setupCommands": [
            \          {
            \            "description": "Enable pretty-printing for gdb",
            \            "text": "set print pretty on",
            \            "ignoreFailures": "true",
            \          }
            \        ]
            \      }
            \    }
            \ } )
    else
        call vimspector#LaunchWithConfigurations( {
            \    "attach": {
            \      "adapter": "vscode-cpptools",
            \      "breakpoints": {
            \        "exception": {
            \          "all": "N",
            \          "uncaught": "N"
            \        }
            \      },
            \      "configuration": {
            \        "request": "launch",
            \        "program": "/opt/rst/Imi/imi",
            \        "cwd": "/opt/rst/Imi",
            \        "MIMode": "gdb",
            \        "setupCommands": [
            \          {
            \            "description": "Enable pretty-printing for gdb",
            \            "text": "set print pretty on",
            \            "ignoreFailures": "true",
            \          }
            \        ],
            \        "environment": [
            \          { "name": "LD_LIBRARY_PATH", "value": "/opt/rst/Imi" }
            \        ]
            \      }
            \    }
            \ } )
    endif
endfunction

function GdbSequencerD()
    if system("pgrep sequencer") > 0
        call vimspector#LaunchWithConfigurations( {
            \    "attach": {
            \      "adapter": "vscode-cpptools",
            \      "breakpoints": {
            \        "exception": {
            \          "all": "N",
            \          "uncaught": "N"
            \        }
            \      },
            \      "configuration": {
            \        "request": "attach",
            \        "program": "/opt/rst/Sequencer/sequencer",
            \        "processId": system("pgrep sequencer"),
            \        "cwd": "/opt/rst/Sequencer",
            \        "MIMode": "gdb",
            \        "setupCommands": [
            \          {
            \            "description": "Enable pretty-printing for gdb",
            \            "text": "set print pretty on",
            \            "ignoreFailures": "true",
            \          }
            \        ]
            \      }
            \    }
            \ } )
    else
        call vimspector#LaunchWithConfigurations( {
            \    "attach": {
            \      "adapter": "vscode-cpptools",
            \      "breakpoints": {
            \        "exception": {
            \          "all": "N",
            \          "uncaught": "N"
            \        }
            \      },
            \      "configuration": {
            \        "request": "launch",
            \        "program": "/opt/rst/Sequencer/sequencer",
            \        "cwd": "/opt/rst/Sequencer",
            \        "MIMode": "gdb",
            \        "setupCommands": [
            \          {
            \            "description": "Enable pretty-printing for gdb",
            \            "text": "set print pretty on",
            \            "ignoreFailures": "true",
            \          }
            \        ]
            \      }
            \    }
            \ } )
    endif
endfunction

function GdbFlightD()
    if system("pgrep ezhostgtk") > 0
        call vimspector#LaunchWithConfigurations( {
            \    "attach": {
            \      "adapter": "vscode-cpptools",
            \      "breakpoints": {
            \        "exception": {
            \          "all": "N",
            \          "uncaught": "N"
            \        }
            \      },
            \      "configuration": {
            \        "request": "attach",
            \        "program": "/opt/rst/FlightModel/ezhostgtk",
            \        "processId": system("pgrep ezhostgtk"),
            \        "cwd": "/opt/rst/FlightModel",
            \        "MIMode": "gdb",
            \        "setupCommands": [
            \          {
            \            "description": "Enable pretty-printing for gdb",
            \            "text": "set print pretty on",
            \            "ignoreFailures": "true",
            \          }
            \        ]
            \      }
            \    }
            \ } )
    else
        call vimspector#LaunchWithConfigurations( {
            \    "attach": {
            \      "adapter": "vscode-cpptools",
            \      "breakpoints": {
            \        "exception": {
            \          "all": "N",
            \          "uncaught": "N"
            \        }
            \      },
            \      "configuration": {
            \        "request": "launch",
            \        "program": "/opt/rst/FlightModel/ezhostgtk",
            \        "cwd": "/opt/rst/FlightModel",
            \        "MIMode": "gdb",
            \        "setupCommands": [
            \          {
            \            "description": "Enable pretty-printing for gdb",
            \            "text": "set print pretty on",
            \            "ignoreFailures": "true",
            \          }
            \        ],
            \        "environment": [
            \          { "name": "LD_LIBRARY_PATH", "value": "/opt/rst/FlightModel" }
            \        ]
            \      }
            \    }
            \ } )
    endif
endfunction

function GdbShmDebugD()
    call vimspector#LaunchWithConfigurations( {
        \    "attach": {
        \      "adapter": "vscode-cpptools",
        \      "breakpoints": {
        \        "exception": {
        \          "all": "N",
        \          "uncaught": "N"
        \        }
        \      },
        \      "configuration": {
        \        "request": "launch",
        \        "program": "/home/camtt/shmemdebug/gui/shmem_debug_gui",
        \        "cwd": "/home/camtt/shmemdebug/gui",
        \        "MIMode": "gdb",
        \        "setupCommands": [
        \          {
        \            "description": "Enable pretty-printing for gdb",
        \            "text": "set print pretty on",
        \            "ignoreFailures": "true",
        \          }
        \        ]
        \      }
        \    }
        \ } )
endfunction

function GdbScenarioEditorD()
    call vimspector#LaunchWithConfigurations( {
        \    "attach": {
        \      "adapter": "vscode-cpptools",
        \      "breakpoints": {
        \        "exception": {
        \          "all": "N",
        \          "uncaught": "N"
        \        }
        \      },
        \      "configuration": {
        \        "request": "launch",
        \        "program": "/opt/rst/ScenarioEditor/scenario_editor",
        \        "cwd": "/opt/rst/ScenarioEditor",
        \        "MIMode": "gdb",
        \        "setupCommands": [
        \          {
        \            "description": "Enable pretty-printing for gdb",
        \            "text": "set print pretty on",
        \            "ignoreFailures": "true",
        \          }
        \        ]
        \      }
        \    }
        \ } )
endfunction
" command GdbFlight   :exe ":Termdebug ezhostgtk " .  trim(system("pgrep ezhostgtk"))

command GdbAvionics  :call GdbAvionicsD()
command GdbIMS       :call GdbIMSD()
command GdbIMI       :call GdbIMID()
command GdbSequencer :call GdbSequencerD()
command GdbFlight    :call GdbFlightD()
command GdbShmDebug  :call GdbShmDebugD()
command GdbScenarioEditor :call GdbScenarioEditorD()


" ----------------------------------------------------- TinyKeyMap ------------------------------------------- "
let g:tinykeymaps_default = [""]
let g:tinykeymap#show_message = "cmdline"
let g:tinykeymap#timeout = 0
let g:tinykeymap#ignore_error = 1
let g:tinykeymap#show_error_timeout = "1000ms"
call tinykeymap#EnterMap('gdb', '<leader>dm', {'name': 'Gdb mode', 'after':'sleep 50m | redraw' })
call tinykeymap#Map('gdb', 'h', ':norm! j')
call tinykeymap#Map('gdb', 'j', ':norm! j')
call tinykeymap#Map('gdb', 'k', ':norm! k')
call tinykeymap#Map('gdb', 'l', ':norm! l')
call tinykeymap#Map('gdb', 'n', 'Over')
call tinykeymap#Map('gdb', 'b', 'Break')
call tinykeymap#Map('gdb', 'u', 'Until')
call tinykeymap#Map('gdb', 's', 'Step')
call tinykeymap#Map('gdb', 'f', 'Finish')
call tinykeymap#Map('gdb', 'c', 'Continue')
call tinykeymap#Map('gdb', 'z', ':norm! zz')
call tinykeymap#Map('gdb', 'e', 'Evaluate')
call tinykeymap#Map('gdb', '<cr>', '')
call tinykeymap#Map('gdb', 'db', 'Clear')


" -----------------------------------------------------  Tabularize  ------------------------------------------- "
vnoremap <leader><leader>a :Tabularize /=<cr>
vnoremap <expr> -<Space> ':Tabularize /\S\(' . split(&commentstring, '%s')[0] . '.*\)\@<!\zs\ /l0<CR>'
nnoremap <expr> -<Space> ':Tabularize /\S\(' . split(&commentstring, '%s')[0] . '.*\)\@<!\zs\ /l0<CR>'
xnoremap <leader>t= :Tabularize /\[=\]<cr>
xnoremap <leader>t} :Tabularize /\v(.)*\zs}/l1c0<cr>
xnoremap <leader>t, :Tabularize /,\zs/l1c0<cr>
xnoremap <leader>t<space> :Tabularize / \S/l1r0<cr>



" ------------------------------------------------------- Signature ----------------------------------------------- "
"nnoremap <A-m> :SignatureListGlobalMarks<CR>
"nnoremap [ :<C-U>call signature#mark#Goto("next", "spot", "global")<CR>
"nnoremap ] :<C-U>call signature#mark#Goto("prev", "spot", "global")<CR>
"nnoremap <leader>md :delmarks A-Z0-9<cr>:wviminfo!<cr>
"let g:SignatureIncludeMarks = 'ABCDEFGHIJKLNOPRSTUVWXYZ'



" ------------------------------------------------------- EasyMotion ----------------------------------------------- "
map <leader> <Plug>(easymotion-prefix)
map <leader>f <Plug>(easymotion-bd-f)
nmap <leader>f <Plug>(easymotion-overwin-f)
"nmap <leader>s <Plug>(easymotion-overwin-s)



" ------------------------------------------------------- Fzf ----------------------------------------------- "
nnoremap <C-p> :Files<cr>
nnoremap <A-b> :Buffers<cr>
nnoremap <A-n> :Lines<cr>
nnoremap <A-m> :Tags<cr>
let g:fzf_buffers_jump = 1
let g:fzf_layout = { 'down': '40%' }
let $FZF_DEFAULT_COMMAND = "ag --ignore '\*.ali' --ignore '\*.o' --ignore '\*.exe' --ignore 'build/\*' -g ''"
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

command! -bang -nargs=* FzfGrep
  \ call fzf#vim#grep(
  \   'rg --column --line-number -g "!tags" -g "!*.ali" -g "!*.o" -g "!build" --hidden --no-heading --color="always" '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%', '?'),
  \   <bang>0)

  "\ 'csearch '.shellescape(<q-args>,1).' | rg '.shellescape((<q-args>), 1), 
command! -bang -nargs=* FzfCSearch
  \ call fzf#vim#grep(
  \ 'csearch '.shellescape(<q-args>, 1), 
  \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \   <bang>0)


nnoremap <A-f> :FzfGrep <c-r><c-w><cr>
nnoremap <A-g> :FzfGrep<cr>

"command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)

"function! s:RunShellCommand(cmdline)
  "echo a:cmdline
  "let expanded_cmdline = a:cmdline
  "for part in split(a:cmdline, ' ')
     "if part[0] =~ '\v[%#<]'
        "let expanded_part = fnameescape(expand(part))
        "let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     "endif
  "endfor
  "botright new
  "setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  "call setline(1, 'You entered:    ' . a:cmdline)
  "call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  "call setline(3,substitute(getline(2),'.','=','g'))
  "execute '$read !'. expanded_cmdline
  "setlocal nomodifiable
  "1
"endfunction

"command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)



" ---------------------------------------------------- YouCompleteMe ------------------------------------------------------ "
let g:ycm_global_ycm_extra_conf = '/hcnat/.ycm_extra_conf.py'
set completeopt-=preview
nnoremap <leader><leader>y :YcmCompleter FixIt<cr>
let g:ycm_show_diagnostics_ui = 0


" ---------------------------------------------------- vim-enum_to_string ------------------------------------------------------ "
let g:enum_to_string_is_template = 1
let g:enum_to_string_function_name = 'enum_to_string'
let g:enum_to_string_template_string = 'template<>'


" ---------------------------------------------------- vim-dispatch ------------------------------------------------------ "
let g:dispatch_tmux_height=20

" ------------------------------------------------------ Fugitive ----------------------------------------------- "
nnoremap <leader>G :ToggleGit<cr>:MerginalToggle<cr>:if bufwinnr(".git/index") > 0 <bar><bar> b:NERDTree.IsOpen() <bar> wincmd l <bar> endif<cr>
nnoremap <leader>gp :Git -c push.default=current push<cr>
nnoremap <leader>gfh :0Gclog!<cr>
nnoremap <leader>gh :Gclog!<cr>
nnoremap <leader>gd :Gvdiff !~1
nnoremap <leader>ge :Gedit<cr>
nnoremap <leader>gl :G log --oneline --decorate --graph --all<cr>
nnoremap <leader><leader>gl :term git log --oneline --graph --all<cr>
nnoremap <leader>dgr :diffget //3<cr>
nnoremap <leader>dgl :diffget //2<cr>
let g:fugitive_summary_format = "%an\t%s"

function! ToggleGit()
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Git
    endif
endfunction
command ToggleGit :call ToggleGit()

function DiffCurrentQuickfixEntry() abort
    cc
    let qf = getqflist({'context': 0, 'idx': 0})
    if get(qf, 'idx') && type(get(qf, 'context')) == type({}) && type(get(qf.context, 'items')) == type([])
        let diff = get(qf.context.items[qf.idx - 1], 'diff', [])
        for i in reverse(range(len(diff)))
            exe (i ? 'rightbelow' : 'leftabove') 'vert diffsplit' fnameescape(diff[i].filename)
            wincmd p
        endfor
    endif
endfunction
nnoremap <leader>gdc :call DiffCurrentQuickfixEntry()<cr>

" ------------------------------------------------------ Merginal ----------------------------------------------- "
" Joined hotkey with futigives

" ------------------------------------------------------ Far ----------------------------------------------- "
let g:far#enable_undo=1
nnoremap <leader><leader>e :argdo %s/<c-r><c-w>/
" set regexpengine=1
let g:far#source='rg'
nnoremap <leader>far :Far <c-r><c-w>  /<left><left>
" let g:far#ignore_files= [ '~/farignore' ]
"
" nnoremap <leader>m :Make -j6<cr>
" nnoremap <leader>r :Dispatch ./gui/shmem_debug_gui<cr>


" ------------------------------------------------------ GLS Syntax Highlighting ----------------------------------------------- "
let g:gls_syntax_mode='normal'
function GlsSyntaxStealthToggleFunc()
    if g:gls_syntax_mode != 'stealth'
        let g:gls_syntax_mode = 'stealth'
    else
        let g:gls_syntax_mode = 'normal'
    endif
    if &filetype ==# 'gls'
        set ft=gls
    endif
endfunction
command GlsSyntaxStealthToggle :call GlsSyntaxStealthToggleFunc()
