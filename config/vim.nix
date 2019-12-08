{neovim, vimUtils, vimPlugins, stdenv, pkgs, fetchgit}:

let
  customPlugins.coc-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "coc-nvim";
    src = fetchgit {
      url = "https://github.com/neoclide/coc.nvim.git";
      sha256 = "0zp0dh980agjwx3bxkn1ywgaqar2izvdiswf8aczyzxyg81gkxzq";
    };
  };
  custom_config = ''
    filetype plugin indent on

    syntax on
    set background=dark
    colorscheme wal

    set noswapfile

    let g:ctrlp_map = '<c-p>'
    let g:ctrlp_cmd = 'CtrlP'

    let g:airline_powerline_fonts = 1

    let g:ctrlp_working_path_mode = 'ra'

    let g:rainbow_active = 1

    let g:hindent_on_save = 1

    let g:deoplete#enable_at_startup = 1

    let g:ale_completion_enabled = 1

    call deoplete#custom#option('sources', {
    \ '_': ['ale',],
    \})

    set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
    set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

    let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
    let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn)$',
    \ 'file': '\v\.(exe|so|dll)$',
    \ 'link': 'some_bad_symbolic_links',
    \ }

    set tabstop=2
    set shiftwidth=2
    set expandtab

    let mapleader = " "

    nnoremap <leader>t :NERDTreeToggle<CR>

    autocmd FileType haskell nnoremap <buffer> <leader>? :call ale#cursor#ShowCursorDetail()<cr>

    set number
    highlight ExtraWhitespace ctermbg=red guibg=red
    match ExtraWhitespace /\s\+\%#\@<!$/
  '';
    in neovim.override {
      vimAlias = true;
      configure = {
        customRC = custom_config;
        vam.knownPlugins = pkgs.vimPlugins // customPlugins;
        vam.pluginDictionaries = [
          { names = [
            "vim-sensible"
            "vim-airline"
            "vim-airline-themes"
            "vim-fugitive"
            "nerdtree"
            "vim-nix"
            "ctrlp"
            "base16-vim"
            "vim-devicons"
            "vim-css-color"
            "vim-ruby"
            "rust-vim"
            "syntastic"
            "vim-elixir"
            "vim-gitgutter"
            "haskell-vim"
            "vim-hindent"
            "ale"
            "deoplete-nvim"
          ];
        }
      ];
    };
  }

