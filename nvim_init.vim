" Inicia el bloque de configuración de vim-plug
call plug#begin('~/.vim/plugged')

" --- Un explorador de archivos ---
Plug 'preservim/nerdtree'

" --- Una barra de estado bonita y útil ---
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" --- Un buen tema de colores ---
Plug 'morhetz/gruvbox'

" --- Integración con FZF (ya lo tienes instalado) ---
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" --- Para comentar líneas de código fácilmente ---
Plug 'preservim/nerdcommenter'

" --- Iconos para los archivos (se ven en NERDTree) ---
Plug 'ryanoasis/vim-devicons'

" Finaliza el bloque de vim-plug
call plug#end()


" --- Configuraciones Básicas ---
" Activa el tema de colores Gruvbox
colorscheme gruvbox
" Activa los números de línea
set number
" Resaltado de sintaxis
syntax on

" --- Atajos de Teclado (Mappings) ---
" Atajo para abrir y cerrar el explorador de archivos NERDTree
" Presiona Ctrl + n para abrir/cerrar
map <C-n> :NERDTreeToggle<CR>
