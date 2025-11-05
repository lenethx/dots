set background=dark
set hidden
set completeopt=menu,menuone,noselect
set showmatch
set ignorecase
set hlsearch
set incsearch
set inccommand=split
set shiftwidth=4
set tabstop=4
set expandtab
set number 
"set relativenumber
set title
set ttimeoutlen=0
set wildmenu
set wildmode=longest,list
set hidden
set wrap lbr
set whichwrap+=<,>,[,]
filetype plugin indent on 
syntax on
set mouse=a
set clipboard=unnamedplus 
"just unnamed for vim
filetype plugin on
"set cursorline
set ttyfast
autocmd TermOpen * setlocal nonumber norelativenumber
autocmd TermOpen * :IndentBlanklineDisable
autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert

tnoremap <Esc> <C-\><C-n>
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l


set t_Co=256
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"


call plug#begin()
	Plug 'vim-airline/vim-airline'
	"Plug 'famiu/feline.nvim'
	"Plug 'ryanoasis/vim-devicons'
	Plug 'nvim-tree/nvim-web-devicons'
	Plug 'akinsho/bufferline.nvim'

	"Plug 'jiangmiao/auto-pairs'
	Plug 'ap/vim-css-color' " alternative nvim colorizer TODO
	Plug 'preservim/nerdtree'
	"Plug 'glepnir/dashboard-nvim'
	Plug 'nvim-lua/plenary.nvim'
"	Plug 'lewis6991/gitsigns.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'frazrepo/vim-rainbow'
"language support

	Plug 'sheerun/vim-polyglot'
	Plug 'plasticboy/vim-markdown'
	Plug 'skanehira/preview-markdown.vim'
	Plug 'smancill/conky-syntax.vim'
"php	
	Plug 'StanAngeloff/php.vim'
	Plug 'stephpy/vim-php-cs-fixer'
"	Plug 'ncm2/ncm2'
"	Plug 'ncm2/ncm2-bufword'
"	Plug 'ncm2/ncm2-path'
"	Plug 'roxma/nvim-yarp'
"	Plug 'phpactor/ncm2-phpactor'

"LSP
    Plug 'neovim/nvim-lspconfig'
"nvim-cmp
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-buffer'
	Plug 'hrsh7th/cmp-path'
	Plug 'hrsh7th/cmp-cmdline'
	Plug 'hrsh7th/nvim-cmp'
	" Plug 'powerman/vim-plugin-AnsiEsc'
	"Plug 'folke/trouble.nvim'
"emmet-ls TODO
"nvim-treesitter
"semantic-highlight.vim
"vim-multiple-cursors
"	Plug 'vim-scripts/genutils'
"	Plug 'vim-scripts/multiselect'
"	https://github.com/ggandor/leap.nvim
"	https://github.com/rgroli/other.nvim
"	https://github.com/folke/which-key.nvim
"	https://github.com/folke/flash.nvim
"	https://github.com/danielfalk/smart-open.nvim
"https://github.com/Fildo7525/pretty_hover

	Plug 'lukas-reineke/indent-blankline.nvim'

	Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
	Plug 'arcticicestudio/nord-vim'
	Plug 'miyakogi/seiya.vim'
call plug#end()
colorscheme challenger_deep
if has('nvim') || has('termguicolors')
	set termguicolors
endif

let g:seiya_target_groups = has('nvim') ? ['guibg'] : ['ctermbg']
let g:seiya_auto_enable=1
"let g:airline_theme='challenger-deep'
let g:airline_powerline_fonts=1
let g:rainbow_active = 1

"let g:airline#extensions#tabline#enabled=1
"let g:airline#extensions#tabline#formatter="unique_tail"

let NERDTreeShowHidden=1

let g:vim_markdown_conceal=0



"nnoremap <C-q> :q<CR>
nnoremap <M-e> :NERDTreeToggle<CR>

"nnoremap <C-Right> :bnext<CR>
"nnoremap <C-Left> :bprev<CR>
nnoremap <M-Right> :BufferLineCycleNext<CR>
nnoremap <M-Left> :BufferLineCyclePrev<CR>
nnoremap <M-Up> :close<CR>
nnoremap <M-t> :new<CR>:on<CR>
nnoremap <M-Down> :bd<CR>
nnoremap <C-M-Down> :bd!<CR>

nnoremap <M-r> :RainbowToggle<CR>
nnoremap <M-p> :PreviewMarkdown right<CR>
map <M-w> :set wrap!<CR>

vnoremap <silent><M-x>s :'<,'>w !scheme --quiet<CR>
nnoremap <silent><M-x>s :%w !scheme --quiet<CR>
vnoremap <silent><C-M-x>s :'<,'>w !scheme<CR>
nnoremap <silent><C-M-x>s :%w !scheme<CR>

vnoremap <silent><M-x>p :'<,'>w !python3<CR>
nnoremap <silent><M-x>p :%w !python3<CR>

"vnoremap <silent><M-x>h :'<,'>w execute "!xargs -I % echo \":{\n%\n:}\" \| ghci"<CR>
"nnoremap <silent><M-x>h :%w !xargs -I % echo ":{\n%\n:}" \| ghci<CR>


vnoremap <silent><M-x>x :'<,'>! xxd<CR>
nnoremap <silent><M-x>x :%! xxd <CR>
vnoremap <silent><C-M-x>x :'<,'>! xxd -r<CR>
nnoremap <silent><C-M-x>x :%! xxd -r<CR>
":%! xxd and :%! xxd -r)
nnoremap <C-M-v> :source $MYVIMRC<CR> 
command Oiv :e $MYVIMRC 

"nnoremap <Up> <Nop>
noremap <Up> gk
inoremap <Up> <C-o>gk
"nnoremap <Down> <Nop>
noremap <Down> gj
inoremap <Down> <C-o>gj
"nnoremap <Left> <Nop>
"nnoremap <Right> <Nop>
"nnoremap <C-k> :vsp | :term 
"
"
" Find files using Telescope command-line sugar. telescope copy paste
nnoremap <silent>ff :Telescope find_files<cr>
nnoremap <silent>fg :Telescope live_grep<cr>
nnoremap <silent>fb :Telescope buffers<cr>
nnoremap <silent>fh :Telescope help_tags<cr>

nmap ss :mksession! ~/.local/share/nvim/session/mysession.vim<CR>
nmap sl :source ~/.local/share/nvim/session/mysession.vim<CR>


"DASHBOARD
"let g:dashboard_default_executive ='telescope'
"let g:dashboard_custom_shortcut={
"\ 'last_session'       : 'SPC s l',
"\ 'find_history'       : 'SPC f h',
"\ 'find_file'          : 'SPC f f',
"\ 'new_file'           : 'SPC c n',
"\ 'change_colorscheme' : 'SPC t c',
"\ 'find_word'          : 'SPC f a',
"\ 'book_marks'         : 'SPC f b',
"\ }
"let g:dashboard_custom_header = []
"let g:dashboard_custom_header = [
"    \'   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣭⣿⣶⣿⣦⣼⣆         ',
"    \'    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ',
"    \'          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷⠄⠄⠄⠄⠻⠿⢿⣿⣧⣄     ',
"    \'           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ',
"    \'          ⢠⣿⣿⣿⠈  ⠡⠌⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ',
"    \'   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘⠄ ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ',
"    \'  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ',
"    \' ⣠⣿⠿⠛⠄⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ',
"    \' ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇⠄⠛⠻⢷⣄ ',
"    \'      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ',
"    \'       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ',
"    \'',
"    \]
"let g:indentLine_fileTypeExclude = ['dashboard']
let g:indentLine_fileTypeExclude = ['terminal']

let g:preview_markdown_auto_update=1
let g:preview_markdown_parser='glow'

nnoremap <M-CR> :lua vim.lsp.buf.code_action()<CR>
nnoremap <M-S-k> :lua vim.diagnostic.open_float()<CR>
inoremap <M-CR> :lua vim.lsp.buf.code_action()<CR>


"{% highlight vim %}
set spelllang=en
set spellfile=$HOME/.config/nvim/spell/en.utf-8.add
"{% endhighlight %}


set nofoldenable
set smoothscroll
set linebreak

set tal=0                                               
let s:tal=0                                             
set stal=0                                              
set showtabline=0                                                                                               
"hide tabline when theres only one file open            
autocmd BufWinEnter,WinEnter * if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1 | set showtabline=0 | else | set showtabline=2 | endif 

lua require('config')
