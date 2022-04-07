
" KittySay, a vim plugin for running things in kitty terminals.
"   Copyright (C) 2022 Shams Kitz
"
"   This program is free software: you can redistribute it and/or modify
"   it under the terms of the GNU General Public License as published by
"   the Free Software Foundation, either version 3 of the License, or
"   (at your option) any later version.
"
"   This program is distributed in the hope that it will be useful,
"   but WITHOUT ANY WARRANTY; without even the implied warranty of
"   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
"   GNU General Public License for more details.
"
"   You should have received a copy of the GNU General Public License
"   along with this program.  If not, see <https://www.gnu.org/licenses/>.
"   -------------------------------------------------------------------

function! kittysay#version()
    return '0.1.0'
endfunction

let s:data = {}

function! s:data.init() dict
    let self.filepath = expand("%:p")
    let self.filename = expand("%:p:t:r")
    let self.parent_dir = expand("%:p:h")
    let self.parentname = expand("%:p:h:t")
    let self.pparentdir = expand("%:p:h:h")
    let self.win_name = self.filename
    let self.ses_name = self.parentname
    let self.prog = "python3"
    let self.module_run = "cd \"".self.pparentdir."\" & ".self.prog." -m %s"
    let self.script_run = self.prog." %s"
    let self.make_rule = ""
    let self.run_as_make = "make ".self.make_rule
    let self.win_cmd = printf(
                \ "sh -c 'kitty -o allow_remote_control=yes -d=\"%s\" --listen-on=unix:@%s_%s' &",
                \ self.parent_dir,self.ses_name,self.win_name)
endfunction

function! s:data.mkwin() dict
    echom "new win:"
    echom self.win_cmd
    call system(self.win_cmd)
endfunction


function! s:data.format_run_cmd() dict
    echom "looking for Makefile in ".self.parent_dir
    let l:makefile = self.parent_dir."/Makefile"
    let l:do_a_make = 0
    let l:send_fmt = "kitty @ --to=unix:@%s_%s send-text %s\<cr>"
    if filereadable(l:makefile)
        echom "has a Makefile"
        return printf(l:send_fmt,self.ses_name,self.win_name,self.run_as_make)
    else
        echom "no Makefile found, guessing based off file type"
        echom &filetype
        if &filetype == 'python'
            echom "filetype is python"
            let l:arg = self.filepath
            let l:run = self.script_run
            if filereadable(self.parent_dir."/__init__.py")
                let l:arg = self.parent_dir
                if !filereadable(self.parent_dir."/__main__.py")
                    let l:arg = self.pparentdir
                    let l:run = self.module_run
                endif
            endif
            let l:runcmd = printf(l:run,l:arg)
            echom "RUNCMD: ".l:runcmd
            return printf(l:send_fmt,self.ses_name,self.win_name,l:runcmd)
        endif
    endif

endfunction

function! s:data.send_command() dict
    let l:sendcmd = self.format_run_cmd()
    echom l:sendcmd
    call system(l:sendcmd)
endfunction
function! s:data.send_cancel() dict
    let l:cancelcmdfmt = "kitty @ --to=unix:@%s_%s send-text \<C-c>"
    let l:cancelcmd = printf(l:cancelcmdfmt,self.ses_name,self.win_name)
    call system(l:cancelcmd)
endfunction

function! kittysay#kittycan()
    call s:data.init()
    call s:data.send_cancel()
endfunction

function! kittysay#kittywin()
    call s:data.init()
    call s:data.mkwin()
endfunction

function! kittysay#kittysay()
    call s:data.init()
    call s:data.send_command()
endfunction

