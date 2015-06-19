" This plugin provides some functions of Hetena-Blog by using AtomPub API
" File: hateblo.vim
" Author: moznion (Taiki Kawakami) <moznion@gmail.com>
" Contributor:TKNGUE
" License: MIT License

let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_hateblo')
  finish
endif

if !exists('g:hateblo_dir')
    let g:hateblo_dir = expand("$HOME/.hateblo/blog")
else 
    let g:hateblo_dir = expand(g:hateblo_dir)
endif

if !isdirectory(g:hateblo_dir) 
    if (input(printf('"%s" does not exist. Create? [y/N]', g:hateblo_dir)) =~? '^y\%[es]$')
        call mkdir(iconv(g:hateblo_dir, &encoding, &termencoding), 'p')
    else 
        let g:hateblo_dir = expand("./")
    endif
endif

if !exists('g:hateblo_config_path')
    let g:hateblo_config_path =expand("$HOME/.hateblo.vim")
else  
    let g:hateblo_config_path = expand(g:hateblo_config_path)
endif

if filereadable(g:hateblo_config_path)
  execute "source " . g:hateblo_config_path
endif

if !exists('g:hateblo_vim')
  finish
endif

"Recommended Global Configuration
" let g:hateblo_config_path = '$HOME/.hateblo/.hateblo.vim'
" let g:hateblo_dir = '$HOME/.hateblo/blog'
" let g:hateblo_title_prefix = 'TITLE:'
" let g:hateblo_category_prefix = 'CATEGORY:'
"
" This script expects the following variables in ~/.hateblo.vim
" - g:hateblo_vim['user']           User ID
" - g:hateblo_vim['api_key']        API Key
" - g:hateblo_vim['api_endpoint']   Endpoint of API
" - g:hateblo_vim['WYSIWYG_mode']   ( 0 | 1 )
" - g:hateblo_vim['always_yes']     ( 0 | 1 )
" - g:hateblo_vim['edit_command']   Command to open the entry

let g:hateblo_vim['edit_command'] = get(g:hateblo_vim, 'edit_command', 'edit')
let g:hateblo_entry_api_endpoint = g:hateblo_vim['api_endpoint'] . '/entry'

if !exists('g:hateblo_title_prefix')
    let g:hateblo_title_prefix = 'TITLE:'
endif
if !exists('g:hateblo_category_prefix')
    let g:hateblo_category_prefix = 'CATEGORY:'
endif

command! -nargs=0 HatebloCreate      call hateblo#createEntry('no')
command! -nargs=0 HatebloCreateDraft call hateblo#createEntry('yes')
command! -nargs=0 HatebloList        Unite hateblo-list
command! -nargs=0 HatebloUpdate      call hateblo#updateEntry()
command! -nargs=0 HatebloDelete      call hateblo#deleteEntry()

augroup hateblo_metarw_autosave
  autocmd!
  autocmd BufUnload hateblo:[0-9]* call metarw#hateblo#autosave()
  execute "autocmd BufRead ".  g:hateblo_dir. "/* set ft=markdown"
augroup END

let g:loaded_hateblo = 1
let &cpo = s:save_cpo
unlet s:save_cpo
