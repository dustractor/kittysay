
let s:save_cpo = &cpo

set cpo&vim

if exists("g:loaded_kittysay") | finish | endif

com! KittySay call kittysay#kittysay()

com! KittyWin call kittysay#kittywin()

com! KittyCan call kittysay#kittycan()

let g:loaded_kittysay = 1

let &cpo = s:save_cpo

unlet s:save_cpo

