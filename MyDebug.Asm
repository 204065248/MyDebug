.386
.model flat, stdcall  ;32 bit memory model
option casemap :none  ;case sensitive

include MyDebug.inc

.const
    g_strFilter db 'Exe Files(*.exe)', 0,'*.exe', 0,'All Files(*.*)', 0,'*.*',0,0
    g_strOpenProcErr db '打开文件失败!', 0
    g_strTip db '提示：',0
    g_strAsmOutput db '[inf] %p %s', 0dh, 0ah, 0
    g_strAsmCallOutput db '[inf] %p call %s', 0dh, 0ah, 0
    g_strAsmJmpOutput db '[inf] %p jmp %s', 0dh, 0ah, 0
    g_strIATFuncName1 db 'dword ptr ds:[%s.%s]',0 
    g_strIATFuncName2 db 'dword ptr ds:[%s.%p]',0 
    g_strIATFuncName3 db '%s.%s',0 
    g_strIATFuncName4 db '%s.%p',0 
    g_strCmdInput db '[cmd]: ', 0
    g_strInput db '%255[^',0ah,']', 0
    g_strAddrErr db '地址错误，请重新输入!', 0
    g_strIdxErr db '序号不正确',0dh,0ah,0
    g_strCutLine db '------------------------------------',0dh,0ah,0
    g_strBPOutput db '%d', 09h, '0x%008x',0dh,0ah,0
    g_strCmpCall db 'call',0
    g_strCmpJmp db 'jmp', 0
    g_strContextOutput db 'EAX: %008x, ECX: %008x, EDX: %008x, EBX: %008x, ESI: %008x, EDI: %008x, ESP: %008x, EBP: %008x',0dh,0ah,'CS: %008x, DS: %008x, SS: %008x, ES: %008x, EFlags: %008x',0dh,0ah,0
    g_strDBOutput db '%02x ',0
    g_strDWOutput db '%hd ', 0
    g_strDDOutput db '%d ', 0
    g_strRNOutput db 0dh,0ah,0
    g_btEndCode db ' '
    g_btDotCode db '.'
    
    g_strBHErr db '硬件断点设置异常',0 
    g_strBhlTitle db '硬件断点列表：', 0
    g_strBhlColName db '序  号', 09, 09, '地  址', 09, 09, '状  态',0dh, 0ah, 0 
    g_strBhlDr0Context db 'DR0', 09, 09, 09, '0x%08X', 09, 09, '%s', 0dh, 0ah, 0
    g_strBhlDr1Context db 'DR1', 09, 09, 09, '0x%08X', 09, 09, '%s', 0dh, 0ah, 0
    g_strBhlDr2Context db 'DR2', 09, 09, 09, '0x%08X', 09, 09, '%s', 0dh, 0ah, 0
    g_strBhlDr3Context db 'DR3', 09, 09, 09, '0x%08X', 09, 09, '%s', 0dh, 0ah, 0
    g_strBhlOnline db '在  线', 0
    g_strBhlInvalidation db '失  效', 0
    g_strBhFull db '当前硬件断点已满，请先删除一个后在进行设置', 0
    
    g_strModuleLst db '模块名称：%s, 模块基址：0x%p', 0dh, 0ah, 0
    g_strMlErr  db '模块列举失败', 0dh, 0ah, 0
    
    g_strDumpExeName db 'dump.exe', 0
    g_strDumpErr db '软件dump失败', 0dh, 0ah, 0
    
    g_strTrFileName db 'asm.txt', 0
    g_strTrErr db '追踪指令失败', 0dh, 0ah, 0
    
    g_strScriptFileName db 'script.txt', 0
    g_strScErr db '脚本功能执行失败', 0dh, 0ah, 0
    g_strSclErr1 db '当前正在执行脚本功能，不能同时运行其他脚本功能', 0dh, 0ah, 0
    g_strSclErr2 db '打开文件失败, 请检查根目录是否有script.txt文件以及是否被占用!', 0dh, 0ah, 0
    
    g_strBMOutput db '%d', 09h, '0x%008x', 09h, 'Len: %d', 09h, 'Type: %s', 0dh,0ah,0
    g_strBmRChar db 'R', 0
    g_strBmWChar db 'W', 0
    g_strBmErr db '内存断点失败', 0dh, 0ah, 0 
    
    g_strHelp01 db '01. 查看寄存器功能: r', 0dh, 0ah, 0
    g_strHelp02 db '02. 修改寄存器功能: r [reg] [value]', 0dh, 0ah, 0
    g_strHelp03 db '03. 查看内存功能: db/dw/dd [addr]', 0dh, 0ah, 0 
    g_strHelp04 db '04. 修改内存功能: eb/ew/ed [addr] [value]', 0dh, 0ah, 0
    g_strHelp05 db '05. 单步步入功能: t', 0dh, 0ah, 0
    g_strHelp06 db '06. 单步步过功能: p', 0dh, 0ah, 0
    g_strHelp07 db '07. 运行功能: g [addr]', 0dh, 0ah, 0
    g_strHelp08 db '08. 软件断点设置功能: bp addr', 0dh, 0ah, 0
    g_strHelp09 db '09. 软件断点查看功能: bl', 0dh, 0ah, 0
    g_strHelp10 db '10. 软件断点删除功能: bc [index]', 0dh, 0ah, 0
    g_strHelp11 db '11. 执行到返回功能: bk', 0dh, 0ah, 0
    g_strHelp12 db '12. 硬件断点设置功能: bh addr [1/2/4] [a/e/w] ', 0dh, 0ah, 0  
    g_strHelp13 db '13. 硬件断点查看功能: bhl', 0dh, 0ah, 0
    g_strHelp14 db '14. 硬件断点删除功能: bhc [index]', 0dh, 0ah, 0
    g_strHelp15 db '15. 开始脚本功能: scs', 0dh, 0ah, 0
    g_strHelp16 db '16. 结束脚本功能: sce', 0dh, 0ah, 0
    g_strHelp17 db '17. 加载脚本功能: scl', 0dh, 0ah, 0
    g_strHelp18 db '18. 指令记录功能: tr', 0dh, 0ah, 0
    g_strHelp19 db '19. 查看模块列表功能: ml', 0dh, 0ah, 0
    g_strHelp20 db '20. 内存dump功能: dump', 0dh, 0ah, 0
    g_strHelp21 db '21. 显示反汇编功能: u [addr]', 0dh, 0ah, 0
    g_strHelp22 db '22. 内存断点设置功能: bm addr [len] [r/w] ', 0dh, 0ah, 0
    g_strHelp23 db '23. 内存断点查看功能: bml', 0dh, 0ah, 0
    g_strHelp24 db '24. 内存断点删除功能: bmc [index]', 0dh, 0ah, 0
    
.data 
    g_hInstance HANDLE NULL
    g_hExeThread HANDLE NULL
    g_DebugEvent DEBUG_EVENT <0>
    ; 断点动态数组
    g_pVecBreakPoint LPDWORD 0
    ; 断点标识
    ; 是否系统断点
    g_bIsSystemBp BOOL TRUE
    ; 是否单步断点
    g_bSingleStepCmd BOOL FALSE
    ; 是否硬件断点
    g_bBhSingStep BOOL FALSE
    
    ; 当前u位置的EIP
    g_dwUEip DWORD NULL
    ; 上一次U的地址
    g_dwUAddr DWORD NULL
    
    ; 当前db位置的EIP
    g_dwDBEip DWORD NULL
    ; 上一次U的地址
    g_dwDBAddr DWORD NULL
    
    ; 记录断点数据
    g_harewareFlag HAREWARE_FLAG <0>
    ; 上一次DR7的数据
    g_lastDR7 DWORD NULL
    
    ; 是否为执行到返回
    g_bGoBack BOOL FALSE
    
    ; 指令记录功能
    g_dwTrDestAddr DWORD NULL
    g_bTrFlag BOOL FALSE
    g_hAsmFile HANDLE NULL
    
    ; 脚本功能
    g_bScFlag BOOL FALSE
    g_hScFile HANDLE NULL
    ; 脚本是否执行完毕
    g_bSclFlag BOOL TRUE
    
.data?
    g_hProcess HANDLE ?
    g_dwPid DWORD ?
    
.code

; 恢复断点
ResumeBtCode proto :DWORD, :BYTE
; 设置断点
SetBreakPoint proto :DWORD, :ptr BYTE
; 输入指令
InputCommand proto :ptr BYTE
; 显示反汇编
ShowAsmInfo proto :LPVOID
; 单步步过
OnPCommand proto
; 单步步入
OnTCommand proto

; 去除空白字符和制表符
SkipWhiteChar proc uses ebx ecx szCommand:ptr char

    .while TRUE
        mov eax, [szCommand]
        movzx ebx, byte ptr [eax]
        .if ebx == ' ' || ebx == 09h
            inc szCommand
        .else
            .break
        .endif
    .endw
    mov eax, szCommand
    ret

SkipWhiteChar endp

; 获取文本长度
MyStrLen proc uses ecx ebx szBuff:ptr char, pBtCode:ptr char
    LOCAL @dwLen:DWORD
    
    mov @dwLen, 0
    .while TRUE
        mov eax, [szBuff]
        mov ecx, @dwLen
        movzx ebx, byte ptr [eax + ecx]
        mov eax, [pBtCode]
        movzx ecx, byte ptr [eax]
        .if ebx == 0 || ebx == ecx || ebx == 0dh || ebx == 0ah
            ; 代表到了我们的目标字符或文本到了末尾
            .break
        .else
            inc @dwLen
        .endif
    .endw
    mov eax, @dwLen
    ret

MyStrLen endp

; 是否存在int3断点
IsHaveBpBreakPoint proc uses ecx dwAddr:DWORD, dwBreakPointType:DWORD
    LOCAL @dwVecSize:SDWORD
    LOCAL @lpItem:LPDWORD
    
    mov @dwVecSize, NULL
    mov @lpItem, NULL
    
    ; 获取结构体大小
    invoke GetVectorSize, g_pVecBreakPoint
    mov @dwVecSize, eax
    dec @dwVecSize
    ; 取出每一个item
    .while TRUE
        .if @dwVecSize < 0
            .break
        .endif
        ; 获取item
        invoke GetItem, g_pVecBreakPoint, addr @lpItem, @dwVecSize
        mov edi, @lpItem
        assume edi:ptr BREAK_POINT_INFO
        mov ecx, dwBreakPointType
        .if [edi].m_dwBreakPointType == ecx
            ; 判断地址是否相同
            mov eax, [edi].m_dwAddr
            .if dwAddr == eax
                mov eax, edi
                ret
            .endif
        .endif
        assume edi:nothing
        dec @dwVecSize
    .endw
    
    xor eax, eax
    ret

IsHaveBpBreakPoint endp

; 获取模块地址
MyGetModuleHandle proc lpModuleName:ptr BYTE, lpModuleSize:ptr DWORD
    LOCAL @hProcess:HANDLE
    LOCAL @me32:MODULEENTRY32 
    LOCAL @dwResult:DWORD
    
    mov @hProcess, NULL
    mov @dwResult, NULL
    
    invoke RtlZeroMemory, addr @me32, sizeof MODULEENTRY32
    mov @me32.dwSize, sizeof MODULEENTRY32
    
    invoke CreateToolhelp32Snapshot, TH32CS_SNAPMODULE, g_dwPid
    mov @hProcess, eax
    .if @hProcess == INVALID_HANDLE_VALUE 
        xor eax, eax
        ret
    .endif
    
    invoke Module32First, @hProcess, addr @me32
    .while TRUE
        .if eax == FALSE
            .break
        .endif
        .if lpModuleName == NULL
            mov eax, @me32.modBaseAddr
            mov @dwResult, eax
            .break
        .endif
        
        lea eax, @me32.szModule
        invoke crt_strcmp, lpModuleName, eax
        .if eax == 0
            mov eax, @me32.modBaseAddr
            mov @dwResult, eax
            .if lpModuleSize != NULL
                mov eax, @me32.modBaseSize
                mov [lpModuleSize], eax 
            .endif
            .break
        .endif         
        invoke Module32Next, @hProcess, addr @me32
    .endw
    
    .if @hProcess != NULL && @hProcess != INVALID_HANDLE_VALUE
        invoke CloseHandle, @hProcess
    .endif
    
    mov eax, @dwResult
    ret

MyGetModuleHandle endp

; 处理单步异常
OnSingleStep proc
    LOCAL @dwVecSize:SDWORD
    LOCAL @lpItem:LPDWORD
    LOCAL @ctx:CONTEXT
    LOCAL @btCode:BYTE
    
    mov @lpItem, 0
    
    ; 判断是否为执行到返回
    .if g_bGoBack == TRUE
        mov g_bSingleStepCmd, FALSE
        invoke ShowAsmInfo, g_DebugEvent.u.Exception.pExceptionRecord.ExceptionAddress
        invoke ReadProcessMemory, g_hProcess, g_DebugEvent.u.Exception.pExceptionRecord.ExceptionAddress, addr @btCode, sizeof BYTE, NULL
        .if @btCode == 0c3h || @btCode == 0c2h
            mov g_bGoBack, FALSE
            invoke InputCommand, NULL
        .else
            invoke OnPCommand
        .endif
        mov eax, DBG_CONTINUE
        ret
    .elseif g_bTrFlag == TRUE
        mov g_bSingleStepCmd, FALSE
        invoke ShowAsmInfo, g_DebugEvent.u.Exception.pExceptionRecord.ExceptionAddress
        mov eax, g_dwTrDestAddr
        .if g_DebugEvent.u.Exception.pExceptionRecord.ExceptionAddress == eax
            mov g_bTrFlag, FALSE
            mov g_dwTrDestAddr, NULL
            invoke CloseHandle, g_hAsmFile
            mov g_hAsmFile, NULL
            invoke InputCommand, NULL
        .else
            invoke OnTCommand
        .endif
        mov eax, DBG_CONTINUE
        ret
    .endif
    
    ; 获取context
    mov @ctx.ContextFlags, CONTEXT_ALL
    invoke GetThreadContext, g_hExeThread, addr @ctx
    
    ; 获取结构体大小
    invoke GetVectorSize, g_pVecBreakPoint
    mov @dwVecSize, eax
    dec @dwVecSize
    ; 取出每一个item
    .while TRUE
        .if @dwVecSize < 0
            .break
        .endif
        
        ; 判断断点是否需要重设
        invoke GetItem, g_pVecBreakPoint, addr @lpItem, @dwVecSize
        mov edi, @lpItem
        assume edi:ptr BREAK_POINT_INFO
        .if [edi].m_bReset == TRUE
            invoke SetBreakPoint, [edi].m_dwAddr, addr [edi].m_btOldCode
            mov [edi].m_bReset, FALSE
        .endif
        assume edi:nothing
        dec @dwVecSize
    .endw
    
    ; 重设硬件断点
    .if g_bBhSingStep == TRUE
        mov eax, g_lastDR7
        mov @ctx.iDr7, eax 
        mov g_bBhSingStep, FALSE
    .endif
    
    ; 处理硬件断点
    mov eax, @ctx.iDr6
    .if eax & 1b
        ; L0断点
        mov eax, @ctx.regFlag
        or eax, 100h
        mov @ctx.regFlag, eax
        mov g_bBhSingStep, TRUE
        
        ; 记录当前硬件断点信息
        mov eax, @ctx.iDr7
        mov g_lastDR7, eax
        ; 取消硬件断点，L0 = 0
        xor @ctx.iDr7, 00000000000000000000000000000001b
        
        mov @ctx.iDr6, 0
        invoke SetThreadContext, g_hExeThread, addr @ctx
        
        invoke ShowAsmInfo, g_DebugEvent.u.Exception.pExceptionRecord.ExceptionAddress
        invoke InputCommand, NULL
        
    .elseif eax & 10b
        ; L1断点
        mov eax, @ctx.regFlag
        or eax, 100h
        mov @ctx.regFlag, eax
        mov g_bBhSingStep, TRUE
        
        ; 记录当前硬件断点信息
        mov eax, @ctx.iDr7
        mov g_lastDR7, eax
        ; 取消硬件断点，L1 = 0
        xor @ctx.iDr7, 00000000000000000000000000000100b
        
        mov @ctx.iDr6, 0
        invoke SetThreadContext, g_hExeThread, addr @ctx
        
        invoke ShowAsmInfo, g_DebugEvent.u.Exception.pExceptionRecord.ExceptionAddress
        invoke InputCommand, NULL
        
    .elseif eax & 100b
        ; L2断点
        mov eax, @ctx.regFlag
        or eax, 100h
        mov @ctx.regFlag, eax
        mov g_bBhSingStep, TRUE
        
        ; 记录当前硬件断点信息
        mov eax, @ctx.iDr7
        mov g_lastDR7, eax
        ; 取消硬件断点，L2 = 0
        xor @ctx.iDr7, 00000000000000000000000000010000b
        
        mov @ctx.iDr6, 0
        invoke SetThreadContext, g_hExeThread, addr @ctx
        
        invoke ShowAsmInfo, g_DebugEvent.u.Exception.pExceptionRecord.ExceptionAddress
        invoke InputCommand, NULL
        
    .elseif eax & 1000b
        ; L3断点
        mov eax, @ctx.regFlag
        or eax, 100h
        mov @ctx.regFlag, eax
        mov g_bBhSingStep, TRUE
        
        ; 记录当前硬件断点信息
        mov eax, @ctx.iDr7
        mov g_lastDR7, eax
        ; 取消硬件断点，L3 = 0
        xor @ctx.iDr7, 00000000000000000000000001000000b
        
        mov @ctx.iDr6, 0
        invoke SetThreadContext, g_hExeThread, addr @ctx
        
        invoke ShowAsmInfo, g_DebugEvent.u.Exception.pExceptionRecord.ExceptionAddress
        invoke InputCommand, NULL
        
    .else
        mov @ctx.iDr6, 0
        invoke SetThreadContext, g_hExeThread, addr @ctx
    .endif
    
    ; 判断是否单步异常,因为有可能重设Contetxt所以放在最后处理
    .if g_bSingleStepCmd == TRUE
        mov g_bSingleStepCmd, FALSE
        invoke ShowAsmInfo, g_DebugEvent.u.Exception.pExceptionRecord.ExceptionAddress
        invoke InputCommand, NULL
    .endif
    
    mov eax, DBG_CONTINUE
    ret

OnSingleStep endp

; 设置单步异常
SetTFAndDecEip proc dwDecVal:DWORD
    LOCAL @ctx:CONTEXT
    mov @ctx.ContextFlags, CONTEXT_ALL
    invoke GetThreadContext, g_hExeThread, addr @ctx
    mov eax, @ctx.regEip
    sub eax, dwDecVal
    mov @ctx.regEip, eax
    mov eax, @ctx.regFlag
    or eax, 100h
    mov @ctx.regFlag, eax
    invoke SetThreadContext, g_hExeThread, addr @ctx
    mov eax, TRUE
    ret

SetTFAndDecEip endp

; CC断点处理
OnBreakPoint proc
    LOCAL @bIsInputCommand:BOOL
    LOCAL @bIsGoCommand:BOOL
    LOCAL @dwVecSize:SDWORD
    LOCAL @lpItem:LPDWORD
    LOCAL @dwResult:DWORD
    
    mov @bIsInputCommand, FALSE
    mov @bIsGoCommand, FALSE
    mov @lpItem, NULL
    mov @dwResult, DBG_EXCEPTION_NOT_HANDLED
    
    ; 获取结构体大小
    invoke GetVectorSize, g_pVecBreakPoint
    mov @dwVecSize, eax
    dec @dwVecSize
    ; 取出每一个item
    .while TRUE
        .if @dwVecSize < 0
            .break
        .endif
        ; 获取item
        invoke GetItem, g_pVecBreakPoint, addr @lpItem, @dwVecSize
        mov edi, @lpItem
        assume edi:ptr BREAK_POINT_INFO
        ; 判断地址是否相同
        mov eax, [edi].m_dwAddr
        .if g_DebugEvent.u.Exception.pExceptionRecord.ExceptionAddress == eax
            invoke ResumeBtCode, [edi].m_dwAddr, [edi].m_btOldCode
            invoke SetTFAndDecEip, 1
            mov @bIsInputCommand, TRUE
            ; 判断是否临时断点
            .if [edi].m_dwBreakPointType == TMP_BREAK_POINT
                invoke DeleteItem, g_pVecBreakPoint, @dwVecSize
            .else
                mov [edi].m_bReset, TRUE
            .endif
            mov @dwResult, DBG_CONTINUE
        .endif
        assume edi:nothing
        dec @dwVecSize
    .endw
    
    .if @bIsInputCommand == TRUE
        ;显示反汇编
        invoke ShowAsmInfo, g_DebugEvent.u.Exception.pExceptionRecord.ExceptionAddress
        .if g_bGoBack == FALSE
            ;提示输入指令
            invoke InputCommand, NULL
        .endif
    .endif
    
    mov eax, @dwResult
    ret
    
OnBreakPoint endp

; 恢复断点
ResumeBtCode proc dwAddr:DWORD, btOldCode:BYTE
    LOCAL @dwOldProtect:DWORD
    
    invoke VirtualProtectEx, g_hProcess, dwAddr, sizeof BYTE, PAGE_READWRITE, addr @dwOldProtect
    .if eax == FALSE
        ret
    .endif
    
    ; 恢复断点
    invoke WriteProcessMemory, g_hProcess, dwAddr, addr btOldCode, sizeof BYTE, NULL
    .if eax == FALSE
        ret
    .endif
    
    invoke VirtualProtectEx, g_hProcess, dwAddr, sizeof BYTE, @dwOldProtect, addr @dwOldProtect
    .if eax == FALSE
        ret
    .endif
    
    mov eax, TRUE
    ret

ResumeBtCode endp

; 设置断点
SetBreakPoint proc dwAddr:DWORD, btOldCode:ptr BYTE
    LOCAL @btCode:BYTE
    LOCAL @dwOldProtect:DWORD
    
    mov @btCode, 0cch
    
    invoke VirtualProtectEx, g_hProcess, dwAddr, sizeof BYTE, PAGE_READWRITE, addr @dwOldProtect
    .if eax == FALSE
        ret
    .endif
    
    ; 记录原数据
    invoke ReadProcessMemory, g_hProcess, dwAddr, btOldCode, sizeof BYTE, NULL
    .if eax == FALSE
        ret
    .endif
    
    ; 设置断点
    invoke WriteProcessMemory, g_hProcess, dwAddr, addr @btCode, sizeof BYTE, NULL
    .if eax == FALSE
        ret
    .endif
    
    invoke VirtualProtectEx, g_hProcess, dwAddr, sizeof BYTE, @dwOldProtect, addr @dwOldProtect
    .if eax == FALSE
        ret
    .endif
    
    mov eax, TRUE
    ret

SetBreakPoint endp

; 处理help指令
OnHelpCommand proc
    
    invoke crt_printf, offset g_strHelp01
    invoke crt_printf, offset g_strHelp02
    invoke crt_printf, offset g_strHelp03
    invoke crt_printf, offset g_strHelp04
    invoke crt_printf, offset g_strHelp05
    invoke crt_printf, offset g_strHelp06
    invoke crt_printf, offset g_strHelp07
    invoke crt_printf, offset g_strHelp08
    invoke crt_printf, offset g_strHelp09
    invoke crt_printf, offset g_strHelp10
    invoke crt_printf, offset g_strHelp11
    invoke crt_printf, offset g_strHelp12
    invoke crt_printf, offset g_strHelp13
    invoke crt_printf, offset g_strHelp14
    invoke crt_printf, offset g_strHelp15
    invoke crt_printf, offset g_strHelp16
    invoke crt_printf, offset g_strHelp17
    invoke crt_printf, offset g_strHelp18
    invoke crt_printf, offset g_strHelp19
    invoke crt_printf, offset g_strHelp20
    invoke crt_printf, offset g_strHelp21
    invoke crt_printf, offset g_strHelp22
    invoke crt_printf, offset g_strHelp23
    invoke crt_printf, offset g_strHelp24
    ret

OnHelpCommand endp

; 处理bm addr len r/w 指令
OnBmCommand proc uses edi dwAddr:DWORD, dwLen:DWORD, dwAttributeType:DWORD
    LOCAL @ctx:CONTEXT
    LOCAL @lpBreakPointInfo:ptr DWORD
    
    mov @lpBreakPointInfo, NULL
    
    ; 判断内存断点是否存在
    invoke IsHaveBpBreakPoint, dwAddr, MEM_BREAK_POINT
    .if eax != NULL
        ret
    .endif
    
    ; 申请新的断点内存
    invoke crt_malloc, sizeof BREAK_POINT_INFO
    .if eax == NULL
        ret
    .endif 
    mov @lpBreakPointInfo, eax
    mov edi, @lpBreakPointInfo
    assume edi:ptr BREAK_POINT_INFO
    mov eax, dwAddr
    mov [edi].m_dwAddr, eax
    mov [edi].m_btOldCode, 0
    mov [edi].m_bReset, FALSE
    mov [edi].m_dwBreakPointType, MEM_BREAK_POINT
    mov eax, dwLen
    mov [edi].m_dwLen, eax
    mov eax, dwAttributeType
    mov [edi].m_dwAttributeType, eax

    ; 如果没有则设置int3断点后加入数组中
    invoke SetBreakPoint, [edi].m_dwAddr, addr [edi].m_btOldCode
    .if eax == TRUE
        invoke AddItem, g_pVecBreakPoint, @lpBreakPointInfo
    .endif
    assume edi:nothing
    
    mov eax, TRUE
    ret

OnBmCommand endp

; 处理bmc指令
OnBmcCommand proc uses edi dwIndex:DWORD
    LOCAL @lpItem:LPDWORD
    
    mov @lpItem, NULL
    
    ; 获取结构体大小
    invoke GetVectorSize, g_pVecBreakPoint
    .if dwIndex >= eax
        invoke crt_printf, offset g_strIdxErr
        xor eax, eax
        ret
    .endif
    
    ; 获取item
    invoke GetItem, g_pVecBreakPoint, addr @lpItem, dwIndex
    mov edi, @lpItem
    assume edi:ptr BREAK_POINT_INFO
    .if [edi].m_dwBreakPointType == MEM_BREAK_POINT
        ; 恢复原数据
        invoke ResumeBtCode, [edi].m_dwAddr, [edi].m_btOldCode
        .if eax == TRUE
            invoke DeleteItem, g_pVecBreakPoint, dwIndex
        .endif
    .endif
    assume edi:nothing
    xor eax, eax
    ret

OnBmcCommand endp

; 处理bml指令
OnBmlCommand proc uses edi
    LOCAL @dwVecSize:SDWORD
    LOCAL @lpItem:LPDWORD
    LOCAL @dwIndex:SDWORD
    
    mov @dwVecSize, NULL
    mov @lpItem, NULL
    mov @dwIndex, NULL
    
    ; 获取结构体大小
    invoke GetVectorSize, g_pVecBreakPoint
    mov @dwVecSize, eax
    
    invoke crt_printf, offset g_strCutLine
    ; 取出每一个item
    .while TRUE
        mov eax, @dwVecSize
        .if @dwIndex >= eax
            .break
        .endif
        ; 获取item
        invoke GetItem, g_pVecBreakPoint, addr @lpItem, @dwIndex
        mov edi, @lpItem
        assume edi:ptr BREAK_POINT_INFO
        
        .if [edi].m_dwBreakPointType == MEM_BREAK_POINT
            .if [edi].m_dwAttributeType == 1
                invoke crt_printf, offset g_strBMOutput, @dwIndex, [edi].m_dwAddr, [edi].m_dwLen, offset g_strBmRChar
            .elseif [edi].m_dwAttributeType == 2
                invoke crt_printf, offset g_strBMOutput, @dwIndex, [edi].m_dwAddr, [edi].m_dwLen, offset g_strBmWChar
            .endif
        .endif
        
        assume edi:nothing
        inc @dwIndex
    .endw
    
    invoke crt_printf, offset g_strCutLine
    mov eax, TRUE
    ret
    
OnBmlCommand endp

; 处理加载脚本指令
OnSclCommand proc
    LOCAL @szCmdBuff[MAXBYTE]:BYTE
    LOCAL @dwReadLen:DWORD
    
    mov @dwReadLen, NULL
    
    ; 判断脚本功能是否已开启
    .if g_bScFlag == TRUE
        invoke MessageBox, NULL, offset g_strSclErr1, offset g_strTip, MB_OK
        ret
    .endif
    
    .if g_bSclFlag == TRUE
        mov g_bSclFlag, FALSE
        
        ; 判断之前的脚本文件是否关闭
        .if g_hScFile != NULL && g_hScFile != INVALID_HANDLE_VALUE
            invoke CloseHandle, g_hScFile
        .endif
        mov g_hScFile, NULL
        
        ; 打开脚本文件
        invoke CreateFile, offset g_strScriptFileName, GENERIC_WRITE or GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
        mov g_hScFile, eax
        .if g_hScFile == INVALID_HANDLE_VALUE
            invoke MessageBox, NULL, offset g_strSclErr2, offset g_strTip, MB_OK
            ret
        .endif
    .endif
    
    .while TRUE
        ; 清空指令缓冲区
        invoke RtlZeroMemory, addr @szCmdBuff, MAXBYTE
        ; 读取一行命令
        lea edi, @szCmdBuff
        .while TRUE
            invoke ReadFile, g_hScFile, edi, sizeof BYTE, addr @dwReadLen, NULL
            .if eax == FALSE
                invoke MessageBox, NULL, offset g_strScErr, offset g_strTip, MB_OK
                ret
            .endif
            .if @dwReadLen == NULL
                invoke crt_strlen, addr @szCmdBuff
                .if eax > 0
                    .break
                .endif
                mov g_bSclFlag, TRUE
                jmp WHILE_END
            .endif
            movzx eax, byte ptr[edi]
            .if eax == 0ah
                .break
            .endif
            add edi, sizeof BYTE
        .endw
        
        ; 执行一行命令
        invoke InputCommand, addr @szCmdBuff
        .if eax == TRUE
            .break
        .endif
    .endw

WHILE_END:
    ; 如果脚本执行完毕则关闭文件并等待下一个用户输入指令
    .if g_bSclFlag == TRUE
        ; 关闭文件
        .if g_hScFile != NULL && g_hScFile != INVALID_HANDLE_VALUE
            invoke CloseHandle, g_hScFile
        .endif
        mov g_hScFile, NULL
        invoke InputCommand, NULL
    .endif
    ret

OnSclCommand endp

; 处理结束脚本指令
OnSceCommand proc

    ; 判断脚本功能是否已开启
    .if g_bScFlag == FALSE
        ret
    .endif
    mov g_bScFlag, FALSE
    
    ; 关闭脚本文件
    .if g_hScFile != NULL && g_hScFile != INVALID_HANDLE_VALUE
        invoke CloseHandle, g_hScFile
    .endif
    
    ret

OnSceCommand endp

; 处理开始脚本指令
OnScsCommand proc
    
    ; 判断脚本功能是否已开启
    .if g_bScFlag == TRUE
        ret
    .endif
    mov g_bScFlag, TRUE
    
    ; 判断之前的脚本文件是否关闭
    .if g_hScFile != NULL && g_hScFile != INVALID_HANDLE_VALUE
        invoke CloseHandle, g_hScFile
    .endif
    mov g_hScFile, NULL
    
    ; 删除之前的脚本文件
    invoke DeleteFile, offset g_strScriptFileName
    
    ; 创建新的脚本文件
    invoke CreateFile, offset g_strScriptFileName, GENERIC_WRITE, 0, NULL, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, NULL
    mov g_hScFile, eax
    .if g_hScFile == INVALID_HANDLE_VALUE
        invoke MessageBox, NULL, offset g_strScErr, offset g_strTip, MB_OK
        ret
    .endif
    
    ret

OnScsCommand endp

; 处理tr指令
OnTrCommand proc dwAddr:DWORD
    
    mov g_bTrFlag, TRUE
    .if dwAddr != NULL && g_dwTrDestAddr == NULL
        mov eax, dwAddr
        mov g_dwTrDestAddr, eax
        
        ; 判断之前文件是否被关闭
        .if g_hAsmFile != NULL
            invoke CloseHandle, g_hAsmFile
            mov g_hAsmFile, NULL
        .endif
        ; 删除之前的记录文件，如果有
        invoke DeleteFile, offset g_strTrFileName
        ; 创建新的记录文件
        invoke CreateFile, offset g_strTrFileName, GENERIC_WRITE, 0, NULL, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, NULL
        mov g_hAsmFile, eax
        .if g_hAsmFile == INVALID_HANDLE_VALUE
            invoke MessageBox, NULL, offset g_strTrErr, offset g_strTip, MB_OK
        .endif
        
    .endif
    .if g_dwTrDestAddr == NULL
        invoke MessageBox, NULL, offset g_strTrErr, offset g_strTip, MB_OK
        ret
    .endif
    invoke OnTCommand
    ret

OnTrCommand endp

; 处理ml指令
OnMlCommand proc
    LOCAL @hProcess:HANDLE
    LOCAL @me32:MODULEENTRY32 
    
    mov @hProcess, NULL
    
    invoke RtlZeroMemory, addr @me32, sizeof MODULEENTRY32
    mov @me32.dwSize, sizeof MODULEENTRY32
    
    invoke CreateToolhelp32Snapshot, TH32CS_SNAPMODULE, g_dwPid
    mov @hProcess, eax
    .if @hProcess == INVALID_HANDLE_VALUE 
        xor eax, eax
        ret
    .endif
    
    invoke Module32First, @hProcess, addr @me32
    .while TRUE
        .if eax == FALSE
            .break
        .endif
        
        lea eax, @me32.szModule
        invoke crt_printf, offset g_strModuleLst, eax, @me32.modBaseAddr
        invoke Module32Next, @hProcess, addr @me32
    .endw
    
    .if @hProcess != NULL && @hProcess != INVALID_HANDLE_VALUE
        invoke CloseHandle, @hProcess
    .endif
    
    mov eax, TRUE
    ret

OnMlCommand endp

; 处理dump指令
OnDumpCommand proc uses ecx edx ebx
    LOCAL @dwResult:DWORD
    LOCAL @hModule:HANDLE
    LOCAL @imgDosHeader:IMAGE_DOS_HEADER
    LOCAL @imgNtHeader:IMAGE_NT_HEADERS
    LOCAL @hFile:HANDLE
    LOCAL @lpPeBuff:ptr BYTE
    LOCAL @dwIndex:SDWORD
    LOCAL @imgSectionHeader:ptr IMAGE_SECTION_HEADER
    LOCAL @lpSectionData:ptr BYTE
    LOCAL @dwLastSectionDataSize:DWORD ; 最后一次执行的节大小
    
    xor eax, eax
    mov @hModule, eax
    mov @hFile, eax
    mov @dwResult, eax
    mov @dwIndex, eax
    mov @dwLastSectionDataSize, eax
    invoke RtlZeroMemory, addr @imgDosHeader, sizeof IMAGE_DOS_HEADER
    invoke RtlZeroMemory, addr @imgNtHeader, sizeof IMAGE_NT_HEADERS
    invoke RtlZeroMemory, addr @imgSectionHeader, sizeof IMAGE_SECTION_HEADER
    
    ; 获取模块首地址
    invoke MyGetModuleHandle, NULL, NULL
    mov @hModule, eax
    .if @hModule == NULL
        ret
    .endif
    
    ; 获取Dos头
    invoke ReadProcessMemory, g_hProcess, @hModule, addr @imgDosHeader, sizeof IMAGE_DOS_HEADER, NULL
    .if eax == FALSE
        ret
    .endif
    
    ; 获取PE头
    mov ecx, @hModule
    add ecx, @imgDosHeader.e_lfanew
    invoke ReadProcessMemory, g_hProcess, ecx, addr @imgNtHeader, sizeof IMAGE_NT_HEADERS, NULL
    .if eax == FALSE
        ret
    .endif
    
    ; 删除旧的dump文件,如果有
    invoke DeleteFile, offset g_strDumpExeName
    ; 创建文件
    invoke CreateFile, offset g_strDumpExeName, GENERIC_WRITE, 0, NULL, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, NULL
    mov @hFile, eax
    .if @hFile == INVALID_HANDLE_VALUE
        jmp DUMP_END
    .endif
    
    ; 读取PE头
    invoke VirtualAlloc, NULL, @imgNtHeader.OptionalHeader.SizeOfHeaders, MEM_COMMIT, PAGE_EXECUTE_READWRITE
    mov @lpPeBuff, eax
    .if @lpPeBuff == NULL
        jmp DUMP_END
    .endif
    invoke ReadProcessMemory, g_hProcess, @hModule, @lpPeBuff, @imgNtHeader.OptionalHeader.SizeOfHeaders, NULL
    .if eax == FALSE
        ret
    .endif
    
    ; 写入PE头
    invoke WriteFile, @hFile, @lpPeBuff, @imgNtHeader.OptionalHeader.SizeOfHeaders, NULL, NULL
    .if eax == FALSE
        jmp DUMP_END
    .endif
    
    ; 读取节列表
    mov edx, @lpPeBuff
    add edx, @imgDosHeader.e_lfanew
    add edx, sizeof IMAGE_NT_HEADERS
    mov @imgSectionHeader, edx
    
    ; 解析节数据
    movzx ecx, @imgNtHeader.FileHeader.NumberOfSections
    .while TRUE
        .if @dwIndex >= ecx
            .break
        .endif
        push ecx
        mov esi, @imgSectionHeader
        assume esi:ptr IMAGE_SECTION_HEADER
        ; 节大小
        mov ebx, [esi].SizeOfRawData
        mov @dwLastSectionDataSize, ebx
        .if @dwLastSectionDataSize == NULL
            jmp DUMP_WIHILE_END
        .endif
        ; 申请节空间
        invoke VirtualAlloc, NULL, @dwLastSectionDataSize, MEM_COMMIT, PAGE_EXECUTE_READWRITE
        mov @lpSectionData, eax
        .if @lpSectionData == NULL
            jmp DUMP_END
        .endif
        
        ; 读取节内容
        mov edx, @imgNtHeader.OptionalHeader.ImageBase
        add edx, [esi].VirtualAddress
        invoke ReadProcessMemory, g_hProcess, edx, @lpSectionData, @dwLastSectionDataSize, NULL
        .if eax == FALSE
            jmp DUMP_END
        .endif
        
        ; 写入节数据
        invoke WriteFile, @hFile, @lpSectionData, @dwLastSectionDataSize, NULL, NULL
        .if eax == FALSE
            jmp DUMP_END
        .endif
        
        ; 释放节空间
        .if @lpSectionData != NULL
            invoke VirtualFree, @lpSectionData, @dwLastSectionDataSize, MEM_DECOMMIT
            mov @lpSectionData, NULL
        .endif
    DUMP_WIHILE_END:
        assume esi:nothing
        
        mov eax, @imgSectionHeader
        add eax, sizeof IMAGE_SECTION_HEADER
        mov @imgSectionHeader, eax
        inc @dwIndex
        pop ecx
    .endw
    
    mov @dwResult, TRUE
DUMP_END:
    .if @hFile != NULL
        invoke CloseHandle, @hFile
        mov @hFile, NULL
    .endif
    
    .if @lpSectionData != NULL
        invoke VirtualFree, @lpSectionData, @dwLastSectionDataSize, MEM_DECOMMIT
        mov @lpSectionData, NULL
    .endif
    
    .if @lpPeBuff != NULL
        invoke VirtualFree, @lpPeBuff, @imgNtHeader.OptionalHeader.SizeOfHeaders, MEM_DECOMMIT
        mov @lpPeBuff, NULL
    .endif
    
    mov eax, @dwResult
    ret

OnDumpCommand endp

; 执行到返回
OnBkCommand proc
    
    mov g_bGoBack, TRUE
    invoke OnPCommand
    ret

OnBkCommand endp

; 删除硬件断点
OnBhcCommand proc dwIndex:DWORD
    LOCAL @ctx:CONTEXT
    LOCAL @lpItem:LPDWORD
    LOCAL @dwAddr:DWORD
    
    mov @ctx.ContextFlags, CONTEXT_ALL
    invoke GetThreadContext, g_hExeThread, addr @ctx
    
    ; 删除硬件断点
    mov eax, @ctx.iDr6
    .if dwIndex == 0
        ; 取消硬件断点，L0 = 0
        xor @ctx.iDr7, 00000000000000000000000000000001b
        mov @ctx.iDr6, 0
        mov g_harewareFlag._DR0, FALSE
        mov eax, @ctx.iDr0
        mov @dwAddr, eax
        mov @ctx.iDr0, 0
        invoke SetThreadContext, g_hExeThread, addr @ctx
        
    .elseif dwIndex == 1
        ; 取消硬件断点，L1 = 0
        xor @ctx.iDr7, 00000000000000000000000000000100b
        mov @ctx.iDr6, 0
        mov g_harewareFlag._DR1, FALSE
        mov eax, @ctx.iDr1
        mov @dwAddr, eax
        mov @ctx.iDr1, 0
        invoke SetThreadContext, g_hExeThread, addr @ctx
        
    .elseif dwIndex == 2
        ; 取消硬件断点，L2 = 0
        xor @ctx.iDr7, 00000000000000000000000000010000b
        mov @ctx.iDr6, 0
        mov g_harewareFlag._DR2, FALSE
        mov eax, @ctx.iDr2
        mov @dwAddr, eax
        mov @ctx.iDr2, 0
        invoke SetThreadContext, g_hExeThread, addr @ctx
        
    .elseif dwIndex == 3
        ; 取消硬件断点，L3 = 0
        xor @ctx.iDr7, 00000000000000000000000001000000b
        mov @ctx.iDr6, 0
        mov g_harewareFlag._DR3, FALSE
        mov eax, @ctx.iDr3
        mov @dwAddr, eax
        mov @ctx.iDr3, 0
        invoke SetThreadContext, g_hExeThread, addr @ctx
        
    .endif
    
    ; 判断BP断点是否存在，如果有则设置m_bReset == TRUE 并且通过断步配合重设BP断点
    invoke IsHaveBpBreakPoint, @dwAddr, CC_BREAK_POINT
    .if eax != NULL
        mov @lpItem, eax
        mov edi, @lpItem
        assume edi:ptr BREAK_POINT_INFO
        ; 设置断点
        invoke SetBreakPoint, [edi].m_dwAddr, addr [edi].m_btOldCode
        assume edi:nothing
    .endif
    
    ret

OnBhcCommand endp

; 列出硬件断点
OnBhlCommand proc
    LOCAL @ctx:CONTEXT
    
    mov @ctx.ContextFlags, CONTEXT_ALL
    invoke GetThreadContext, g_hExeThread, addr @ctx
    
    ; 判断相同地址是否设置过硬件断点
    invoke crt_printf, offset g_strBhlTitle
    invoke crt_printf, offset g_strBhlColName
    invoke crt_printf, offset g_strCutLine
    mov eax, @ctx.iDr0
    .if eax != NULL
        invoke crt_printf, offset g_strBhlDr0Context, @ctx.iDr0, offset g_strBhlOnline
    .else 
        invoke crt_printf, offset g_strBhlDr0Context, @ctx.iDr0, offset g_strBhlInvalidation
    .endif
    mov eax, @ctx.iDr1
    .if eax != NULL
        invoke crt_printf, offset g_strBhlDr1Context, @ctx.iDr1, offset g_strBhlOnline
    .else 
        invoke crt_printf, offset g_strBhlDr1Context, @ctx.iDr1, offset g_strBhlInvalidation
    .endif
    mov eax, @ctx.iDr2
    .if eax != NULL
        invoke crt_printf, offset g_strBhlDr2Context, @ctx.iDr2, offset g_strBhlOnline
    .else 
        invoke crt_printf, offset g_strBhlDr2Context, @ctx.iDr2, offset g_strBhlInvalidation
    .endif
    mov eax, @ctx.iDr3
    .if eax != NULL
        invoke crt_printf, offset g_strBhlDr3Context, @ctx.iDr3, offset g_strBhlOnline
    .else 
        invoke crt_printf, offset g_strBhlDr3Context, @ctx.iDr3, offset g_strBhlInvalidation
    .endif
    invoke crt_printf, offset g_strCutLine

    ret

OnBhlCommand endp

; 处理硬件断点指令
OnHardWareCommand proc dwAddr:DWORD, dwBhLen:DWORD, dwDhType:DWORD
    LOCAL @ctx:CONTEXT
    LOCAL @lpItem:LPDWORD
    
    mov @ctx.ContextFlags, CONTEXT_ALL
    invoke GetThreadContext, g_hExeThread, addr @ctx
    
    ; 判断相同地址是否设置过硬件断点
    mov eax, dwAddr
    .if @ctx.iDr0 == eax || @ctx.iDr1 == eax || @ctx.iDr2 == eax || @ctx.iDr3 == eax
        mov eax, FALSE
        ret
    .endif
    
    ; 判断BP断点是否存在，如果有则先去除
    invoke IsHaveBpBreakPoint, dwAddr, CC_BREAK_POINT
    .if eax != NULL
        mov @lpItem, eax
        mov edi, @lpItem
        assume edi:ptr BREAK_POINT_INFO
        ; 恢复断点
        invoke ResumeBtCode, [edi].m_dwAddr, [edi].m_btOldCode
        assume edi:nothing
    .endif
    
    
    .if g_harewareFlag._DR0 == FALSE
        mov eax, dwAddr
        mov @ctx.iDr0, eax
        
        ; 设置L0
        ; L0 = 1
        or @ctx.iDr7, 00000000000000000000000000000001b
        
        ; 设置LEN0
        .if dwBhLen == 0 || dwBhLen == 1
            ; LEN0 = 0 || LEN0 = 1
            or @ctx.iDr7, 00000000000000000000000000000000b
        .elseif dwBhLen == 2
            ; LEN0 = 2
            or @ctx.iDr7, 00000000000001000000000000000000b
        .elseif dwBhLen == 4
            ; LEN0 = 4
            or @ctx.iDr7, 00000000000011000000000000000000b
        .endif
        
        ; 设置RW0
        .if dwDhType == 3
            ; 硬件访问断点
            ; RW0 = 3
            or @ctx.iDr7, 00000000000000110000000000000000b
        .elseif dwDhType == 0
            ; 硬件执行断点
            ; RW0 = 0
            or @ctx.iDr7, 00000000000000000000000000000000b
        .elseif dwDhType == 1
            ; 硬件写入断点
            ; RW0 = 1
            or @ctx.iDr7, 00000000000000010000000000000000b
        .endif
        
        invoke SetThreadContext, g_hExeThread, addr @ctx
        mov g_harewareFlag._DR0, TRUE
        
    .elseif g_harewareFlag._DR1 == FALSE
        mov eax, dwAddr
        mov @ctx.iDr1, eax
        
        ; 设置L1
        ; L1 = 1
        or @ctx.iDr7, 00000000000000000000000000000100b
        
        ; 设置LEN1
        .if dwBhLen == 0 || dwBhLen == 1
            ; LEN1 = 0 || LEN1 = 1
            or @ctx.iDr7, 00000000000000000000000000000000b
        .elseif dwBhLen == 2
            ; LEN1 = 2
            or @ctx.iDr7, 00000000010000000000000000000000b
        .elseif dwBhLen == 4
            ; LEN1 = 4
            or @ctx.iDr7, 00000000110000000000000000000000b
        .endif
        
        ; 设置RW1
        .if dwDhType == 3
            ; 硬件访问断点
            ; RW1 = 3
            or @ctx.iDr7, 00000000001100000000000000000000b
        .elseif dwDhType == 0
            ; 硬件执行断点
            ; RW1 = 0
            or @ctx.iDr7, 00000000000000000000000000000000b
        .elseif dwDhType == 1
            ; 硬件写入断点
            ; RW1 = 1
            or @ctx.iDr7, 00000000000100000000000000000000b
        .endif
        
        invoke SetThreadContext, g_hExeThread, addr @ctx
        mov g_harewareFlag._DR1, TRUE
    .elseif g_harewareFlag._DR2 == FALSE
        mov eax, dwAddr
        mov @ctx.iDr2, eax
        
        ; 设置L2
        ; L2 = 1
        or @ctx.iDr7, 00000000000000000000000000010000b
        
        ; 设置LEN2
        .if dwBhLen == 0 || dwBhLen == 1
            ; LEN2 = 0 || LEN2 = 1
            or @ctx.iDr7, 00000000000000000000000000000000b
        .elseif dwBhLen == 2
            ; LEN2 = 2
            or @ctx.iDr7, 00000100000000000000000000000000b
        .elseif dwBhLen == 4
            ; LEN2 = 4
            or @ctx.iDr7, 00001100000000000000000000000000b
        .endif
        
        ; 设置RW2
        .if dwDhType == 3
            ; 硬件访问断点
            ; RW2 = 3
            or @ctx.iDr7, 00000000000000000000000011b
        .elseif dwDhType == 0
            ; 硬件执行断点
            ; RW2 = 0
            or @ctx.iDr7, 00000000000000000000000000000000b
        .elseif dwDhType == 1
            ; 硬件写入断点
            ; RW2 = 1
            or @ctx.iDr7, 00000000000000000000000001b
        .endif
        
        invoke SetThreadContext, g_hExeThread, addr @ctx
        mov g_harewareFlag._DR2, TRUE
    .elseif g_harewareFlag._DR3 == FALSE
        mov eax, dwAddr
        mov @ctx.iDr3, eax
        
        ; 设置L3
        ; L3 = 1
        or @ctx.iDr7, 00000000000000000000000001000000b
        
        ; 设置LEN3
        .if dwBhLen == 0 || dwBhLen == 1
            ; LEN3 = 0 || LEN3 = 1
            or @ctx.iDr7, 00000000000000000000000000000000b
        .elseif dwBhLen == 2
            ; LEN3 = 2
            or @ctx.iDr7, 01000000000000000000000000000000b
        .elseif dwBhLen == 4
            ; LEN3 = 4
            or @ctx.iDr7, 11000000000000000000000000000000b
        .endif
        
        ; 设置RW3
        .if dwDhType == 3
            ; 硬件访问断点
            ; RW3 = 3
            or @ctx.iDr7, 00110000000000000000000000000000b
        .elseif dwDhType == 0
            ; 硬件执行断点
            ; RW3 = 0
            or @ctx.iDr7, 00000000000000000000000000000000b
        .elseif dwDhType == 1
            ; 硬件写入断点
            ; RW3 = 1
            or @ctx.iDr7, 00010000000000000000000000000000b
        .endif
        
        invoke SetThreadContext, g_hExeThread, addr @ctx
        mov g_harewareFlag._DR3, TRUE
    .else
        invoke MessageBox, NULL, offset g_strBhFull, offset g_strTip, NULL
        xor eax, eax
        ret
    .endif
    
    mov eax, TRUE
    ret

OnHardWareCommand endp

; 处理e指令
OnECommand proc uses ebx dwAddr:DWORD, dwMemVal:DWORD, dwValSize:DWORD
    LOCAL @numberOfBtsWritten:DWORD
    LOCAL @dwOldProtect:DWORD
    
    xor eax, eax
    mov @numberOfBtsWritten, eax
    mov @dwOldProtect, eax
    
    invoke VirtualProtectEx, g_hProcess, dwAddr, sizeof BYTE, PAGE_READWRITE, addr @dwOldProtect
    .if eax == FALSE
        ret
    .endif
    
    ; 写入新数据
    invoke WriteProcessMemory, g_hProcess, dwAddr, addr dwMemVal, dwValSize, addr @numberOfBtsWritten
    .if eax == FALSE
        ret
    .endif
    
    invoke VirtualProtectEx, g_hProcess, dwAddr, sizeof BYTE, @dwOldProtect, addr @dwOldProtect
    .if eax == FALSE
        ret
    .endif
    
    mov eax, TRUE
    ret

OnECommand endp

; 处理dw指令
OnDWCommand proc uses ebx dwAddr:DWORD
    LOCAL @ctx:CONTEXT
    LOCAL @dwCurrentEip:DWORD
    LOCAL @wCode:DWORD
    LOCAL @numberOfBtsWritten:DWORD
    
    xor eax, eax
    mov @dwCurrentEip, eax
    mov @numberOfBtsWritten, eax
    invoke RtlZeroMemory, addr @ctx, sizeof @ctx
    
    ; 获取当前EIP地址
    mov @ctx.ContextFlags, CONTEXT_ALL
    invoke GetThreadContext, g_hExeThread, addr @ctx
    mov eax, @ctx.regEip
    mov @dwCurrentEip, eax
    
    ; 判断地址
    .if dwAddr == NULL
        .if g_dwDBAddr == NULL
            mov eax, g_DebugEvent.u.Exception.pExceptionRecord.ExceptionAddress
            mov g_dwDBEip, eax
        .else
            mov eax, g_dwDBAddr
        .endif
        mov ebx, @dwCurrentEip
        .if g_dwDBEip != ebx
            mov g_dwDBEip, ebx
            mov eax, g_DebugEvent.u.Exception.pExceptionRecord.ExceptionAddress
            mov g_dwDBAddr, eax
        .endif
        mov dwAddr, eax
    .else
        mov eax, dwAddr
        mov g_dwDBAddr, eax
    .endif
    
    invoke ReadProcessMemory, g_hProcess, dwAddr, addr @wCode, sizeof @wCode, addr @numberOfBtsWritten
    .if eax == FALSE
        ret
    .endif
    
    invoke crt_printf, offset g_strDWOutput, @wCode
    invoke crt_printf, offset g_strRNOutput
    
    mov eax, dwAddr
    add eax, @numberOfBtsWritten
    mov g_dwDBAddr, eax
    
    mov eax, TRUE
    ret

OnDWCommand endp

; 处理dd指令
OnDDCommand proc uses ebx dwAddr:DWORD
    LOCAL @ctx:CONTEXT
    LOCAL @dwCurrentEip:DWORD
    LOCAL @dwCode:DWORD
    LOCAL @numberOfBtsWritten:DWORD
    
    xor eax, eax
    mov @dwCurrentEip, eax
    mov @numberOfBtsWritten, eax
    invoke RtlZeroMemory, addr @ctx, sizeof @ctx
    
    ; 获取当前EIP地址
    mov @ctx.ContextFlags, CONTEXT_ALL
    invoke GetThreadContext, g_hExeThread, addr @ctx
    mov eax, @ctx.regEip
    mov @dwCurrentEip, eax
    
    ; 判断地址
    .if dwAddr == NULL
        .if g_dwDBAddr == NULL
            mov eax, g_DebugEvent.u.Exception.pExceptionRecord.ExceptionAddress
            mov g_dwDBEip, eax
        .else
            mov eax, g_dwDBAddr
        .endif
        mov ebx, @dwCurrentEip
        .if g_dwDBEip != ebx
            mov g_dwDBEip, ebx
            mov eax, g_DebugEvent.u.Exception.pExceptionRecord.ExceptionAddress
            mov g_dwDBAddr, eax
        .endif
        mov dwAddr, eax
    .else
        mov eax, dwAddr
        mov g_dwDBAddr, eax
    .endif
    
    invoke ReadProcessMemory, g_hProcess, dwAddr, addr @dwCode, sizeof @dwCode, addr @numberOfBtsWritten
    .if eax == FALSE
        ret
    .endif
    
    invoke crt_printf, offset g_strDDOutput, @dwCode
    invoke crt_printf, offset g_strRNOutput
    
    mov eax, dwAddr
    add eax, @numberOfBtsWritten
    mov g_dwDBAddr, eax
    
    mov eax, TRUE
    ret

OnDDCommand endp

; 处理db指令
OnDBCommand proc uses ebx dwAddr:DWORD
    LOCAL @ctx:CONTEXT
    LOCAL @dwCurrentEip:DWORD
    LOCAL @btCode:BYTE
    LOCAL @numberOfBtsWritten:DWORD
    
    xor eax, eax
    mov @dwCurrentEip, eax
    mov @numberOfBtsWritten, eax
    invoke RtlZeroMemory, addr @ctx, sizeof @ctx
    
    ; 获取当前EIP地址
    mov @ctx.ContextFlags, CONTEXT_ALL
    invoke GetThreadContext, g_hExeThread, addr @ctx
    mov eax, @ctx.regEip
    mov @dwCurrentEip, eax
    
    ; 判断地址
    .if dwAddr == NULL
        .if g_dwDBAddr == NULL
            mov eax, g_DebugEvent.u.Exception.pExceptionRecord.ExceptionAddress
            mov g_dwDBEip, eax
        .else
            mov eax, g_dwDBAddr
        .endif
        mov ebx, @dwCurrentEip
        .if g_dwDBEip != ebx
            mov g_dwDBEip, ebx
            mov eax, g_DebugEvent.u.Exception.pExceptionRecord.ExceptionAddress
            mov g_dwDBAddr, eax
        .endif
        mov dwAddr, eax
    .else
        mov eax, dwAddr
        mov g_dwDBAddr, eax
    .endif
    
    invoke ReadProcessMemory, g_hProcess, dwAddr, addr @btCode, sizeof @btCode, addr @numberOfBtsWritten
    .if eax == FALSE
        ret
    .endif
    
    invoke crt_printf, offset g_strDBOutput, @btCode
    invoke crt_printf, offset g_strRNOutput
    
    mov eax, dwAddr
    add eax, @numberOfBtsWritten
    mov g_dwDBAddr, eax
    
    mov eax, TRUE
    ret

OnDBCommand endp

; 处理修改寄存器指令
OnEditRCommand proc dwRegType:DWORD, dwRegVal:DWORD
    LOCAL @ctx:CONTEXT

    ; 获取当前环境
    mov @ctx.ContextFlags, CONTEXT_ALL
    invoke GetThreadContext, g_hExeThread, addr @ctx
    
    mov eax, dwRegVal
    .if dwRegType == REG_EAX
        mov @ctx.regEax, eax
    .elseif dwRegType == REG_EBX
        mov @ctx.regEbx, eax
    .elseif dwRegType == REG_ECX
        mov @ctx.regEcx, eax
    .elseif dwRegType == REG_EDX
        mov @ctx.regEdx, eax
    .elseif dwRegType == REG_EBP
        mov @ctx.regEbp, eax
    .elseif dwRegType == REG_ESP
        mov @ctx.regEsp, eax
    .elseif dwRegType == REG_ESI
        mov @ctx.regEsi, eax
    .elseif dwRegType == REG_EDI
        mov @ctx.regEdi, eax
    .endif
    
    invoke SetThreadContext, g_hExeThread, addr @ctx
    ret

OnEditRCommand endp

; 处理r指令
OnRCommand proc
    LOCAL @ctx:CONTEXT

    ; 获取当前环境
    mov @ctx.ContextFlags, CONTEXT_ALL
    invoke GetThreadContext, g_hExeThread, addr @ctx
    invoke crt_printf, offset g_strContextOutput, @ctx.regEax, @ctx.regEcx, 
    @ctx.regEdx, @ctx.regEbx, @ctx.regEsi, @ctx.regEdi, @ctx.regEsp,
    @ctx.regEbp, @ctx.regCs, @ctx.regDs, @ctx.regSs, @ctx.regEs, @ctx.ContextFlags
    
    ret

OnRCommand endp

; 处理u addr 指令
OnUCommand proc uses ebx dwAddr:DWORD
    LOCAL @ctx:CONTEXT
    LOCAL @dwCurrentEip:DWORD
    LOCAL @dwIndex:DWORD
    
    mov @dwIndex, 0
    
    ; 获取当前EIP地址
    mov @ctx.ContextFlags, CONTEXT_ALL
    invoke GetThreadContext, g_hExeThread, addr @ctx
    mov eax, @ctx.regEip
    mov @dwCurrentEip, eax
    
    ; 判断地址
    .if dwAddr == NULL
        .if g_dwUAddr == NULL
            mov eax, g_DebugEvent.u.Exception.pExceptionRecord.ExceptionAddress
            mov g_dwUEip, eax
        .else
            mov eax, g_dwUAddr
        .endif
        mov ebx, @dwCurrentEip
        .if g_dwUEip != ebx
            mov g_dwUEip, ebx
            mov eax, g_DebugEvent.u.Exception.pExceptionRecord.ExceptionAddress
            mov g_dwUAddr, eax
        .endif
        mov dwAddr, eax
    .else
        mov eax, dwAddr
        mov g_dwUAddr, eax
    .endif
    
    .while TRUE
        .if @dwIndex > 10
            .break
        .endif
        invoke ShowAsmInfo, dwAddr
        add dwAddr, eax
        inc @dwIndex
    .endw
    mov eax, dwAddr
    mov g_dwUAddr, eax
    
    mov eax, TRUE
    ret

OnUCommand endp

; 处理g addr 指令
OnGoCommand proc dwAddr:DWORD
    LOCAL @lpBreakPointInfo:ptr DWORD
    
    mov @lpBreakPointInfo, NULL
    
    ; 判断BP断点是否存在
    invoke IsHaveBpBreakPoint, dwAddr, CC_BREAK_POINT
    .if eax != NULL
        ret
    .endif
    
    invoke crt_malloc, sizeof BREAK_POINT_INFO
    .if eax == NULL
        ret
    .endif 
    mov @lpBreakPointInfo, eax
    mov edi, @lpBreakPointInfo
    assume edi:ptr BREAK_POINT_INFO
    mov eax, dwAddr
    mov [edi].m_dwAddr, eax
    mov [edi].m_btOldCode, 0
    mov [edi].m_bReset, FALSE
    mov [edi].m_dwBreakPointType, TMP_BREAK_POINT
    
    invoke SetBreakPoint, [edi].m_dwAddr, addr [edi].m_btOldCode
    .if eax == TRUE
        invoke AddItem, g_pVecBreakPoint, @lpBreakPointInfo
    .endif
    assume edi:nothing
    
    mov eax, TRUE
    ret

OnGoCommand endp

; 处理单步步入指令
OnTCommand proc
    
    mov g_bSingleStepCmd, TRUE
    invoke SetTFAndDecEip, 0
    mov eax, TRUE
    ret

OnTCommand endp

; 处理单步步过指令
OnPCommand proc
    LOCAL @aryCode[16]:BYTE
    LOCAL @szAsm[MAXBYTE]:BYTE
    LOCAL @nAsmLen:UINT
    LOCAL @pAddr:LPVOID
    LOCAL @dwNextAddr:DWORD
    LOCAL @lpBreakPointInfo:ptr DWORD
    
    invoke RtlZeroMemory, addr @aryCode, sizeof @aryCode
    invoke RtlZeroMemory, addr @szAsm, MAXBYTE
    mov @nAsmLen, 0
    mov @pAddr, NULL
    mov @dwNextAddr, NULL
    mov @lpBreakPointInfo, NULL
    
    mov eax, g_DebugEvent.u.Exception.pExceptionRecord.ExceptionAddress
    mov @pAddr, eax
    
    invoke ReadProcessMemory, g_hProcess, @pAddr, addr @aryCode, sizeof @aryCode, NULL 
    invoke Decode2Asm, addr @aryCode, addr @szAsm, addr @nAsmLen, @pAddr
    
    ; 判断是否是Call指令  
    invoke crt_strstr, addr @szAsm, offset g_strCmpCall
    .if eax != NULL
        ; TODO: 判断是否有硬件断点
        ; 在Call下一行下断点
        mov eax, @pAddr
        add eax, @nAsmLen
        mov @dwNextAddr, eax
        
        invoke crt_malloc, sizeof BREAK_POINT_INFO
        .if eax == NULL
            ret
        .endif 
        mov @lpBreakPointInfo, eax
        mov edi, @lpBreakPointInfo
        assume edi:ptr BREAK_POINT_INFO
        mov eax, @dwNextAddr
        mov [edi].m_dwAddr, eax
        mov [edi].m_btOldCode, 0
        mov [edi].m_bReset, FALSE
        mov [edi].m_dwBreakPointType, TMP_BREAK_POINT
        
        invoke SetBreakPoint, [edi].m_dwAddr, addr [edi].m_btOldCode
        .if eax == TRUE
            invoke AddItem, g_pVecBreakPoint, @lpBreakPointInfo
        .endif
        assume edi:nothing
    .else
        ; 设置单步
        invoke OnTCommand
    .endif
    ret
    
OnPCommand endp

; 处理BL命令
OnBlCommand proc uses edi
    LOCAL @dwVecSize:SDWORD
    LOCAL @lpItem:LPDWORD
    LOCAL @dwIndex:SDWORD
    
    mov @dwVecSize, NULL
    mov @lpItem, NULL
    mov @dwIndex, NULL
    
    ; 获取结构体大小
    invoke GetVectorSize, g_pVecBreakPoint
    mov @dwVecSize, eax
    
    invoke crt_printf, offset g_strCutLine
    ; 取出每一个item
    .while TRUE
        mov eax, @dwVecSize
        .if @dwIndex >= eax
            .break
        .endif
        ; 获取item
        invoke GetItem, g_pVecBreakPoint, addr @lpItem, @dwIndex
        mov edi, @lpItem
        assume edi:ptr BREAK_POINT_INFO
        
        .if [edi].m_dwBreakPointType == CC_BREAK_POINT
            invoke crt_printf, offset g_strBPOutput, @dwIndex, [edi].m_dwAddr
        .endif
        
        assume edi:nothing
        inc @dwIndex
    .endw
    
    invoke crt_printf, offset g_strCutLine
    mov eax, TRUE
    ret

OnBlCommand endp

; 处理BC命令
OnBcCommand proc uses edi dwIndex:DWORD
    LOCAL @lpItem:LPDWORD
    
    mov @lpItem, NULL
    
    ; 获取结构体大小
    invoke GetVectorSize, g_pVecBreakPoint
    .if dwIndex >= eax
        invoke crt_printf, offset g_strIdxErr
        xor eax, eax
        ret
    .endif
    
    ; 获取item
    invoke GetItem, g_pVecBreakPoint, addr @lpItem, dwIndex
    mov edi, @lpItem
    assume edi:ptr BREAK_POINT_INFO
    .if [edi].m_dwBreakPointType == CC_BREAK_POINT
        ; 恢复原数据
        invoke ResumeBtCode, [edi].m_dwAddr, [edi].m_btOldCode
        .if eax == TRUE
            invoke DeleteItem, g_pVecBreakPoint, dwIndex
        .endif
    .endif
    assume edi:nothing
    xor eax, eax
    ret

OnBcCommand endp

; 处理BP命令
OnBpCommand proc uses edi dwAddr:DWORD
    LOCAL @ctx:CONTEXT
    LOCAL @lpBreakPointInfo:ptr DWORD
    
    mov @lpBreakPointInfo, NULL
    
    ; 判断BP断点是否存在
    invoke IsHaveBpBreakPoint, dwAddr, CC_BREAK_POINT
    .if eax != NULL
        ret
    .endif
    
    ; 申请新的断点内存
    invoke crt_malloc, sizeof BREAK_POINT_INFO
    .if eax == NULL
        ret
    .endif 
    mov @lpBreakPointInfo, eax
    mov edi, @lpBreakPointInfo
    assume edi:ptr BREAK_POINT_INFO
    mov eax, dwAddr
    mov [edi].m_dwAddr, eax
    mov [edi].m_btOldCode, 0
    mov [edi].m_bReset, FALSE
    mov [edi].m_dwBreakPointType, CC_BREAK_POINT
    
    ; 判断当前地址有没有硬件断点，如果有则记录设置假的int3断点
    mov @ctx.ContextFlags, CONTEXT_ALL
    invoke GetThreadContext, g_hExeThread, addr @ctx

    ; 判断相同地址是否设置过硬件断点
    mov eax, dwAddr
    .if @ctx.iDr0 == eax || @ctx.iDr1 == eax || @ctx.iDr2 == eax || @ctx.iDr3 == eax
        ; 如果有硬件断点则直接加入数组中，不进行设置断点
        invoke AddItem, g_pVecBreakPoint, @lpBreakPointInfo
    .else
        ; 如果没有则设置int3断点后加入数组中
        invoke SetBreakPoint, [edi].m_dwAddr, addr [edi].m_btOldCode
        .if eax == TRUE
            invoke AddItem, g_pVecBreakPoint, @lpBreakPointInfo
        .endif
    .endif
    assume edi:nothing
    
    mov eax, TRUE
    ret

OnBpCommand endp

; 输入指令
InputCommand proc uses ebx edi lpCommandBuff:ptr BYTE
    ; cmd输入管道句柄
    LOCAL @hIn:HANDLE
    ; 命令缓冲区
    LOCAL @szCommand[MAXBYTE]:BYTE
    ; 命令缓冲区
    LOCAL @pCmd:ptr CHAR
    LOCAL @dwReadSize:DWORD
    LOCAL @dwAddr:DWORD
    LOCAL @dwIndex:DWORD
    LOCAL @dwLen:DWORD
    ; 硬件断点变量
    LOCAL @dwBhLen:DWORD
    LOCAL @dwBhType:DWORD
    LOCAL @dwResult:DWORD
    ; 内存修改数值
    LOCAL @dwMenVal:DWORD
    ; 寄存器修改数值
    LOCAL @dwRegVal:DWORD
    ; 当执行脚本的时候当前指令是否已执行成功
    LOCAL @bScAlreadyRun:BOOL
    ; 当前脚本执行结果是否需要ret
    LOCAL @bScIsNeedRet:BOOL
    
    ; 变量清空
    xor eax, eax
    mov @hIn, eax
    mov @dwReadSize, eax
    mov @pCmd, eax
    mov @dwAddr, eax
    mov @dwIndex, eax
    mov @dwLen, eax
    mov @dwBhLen, eax
    mov @dwBhType, eax
    mov @dwResult, eax
    mov @dwMenVal, eax
    mov @bScAlreadyRun, eax
    mov @bScIsNeedRet, eax
    
    .while TRUE
        
        ; 判断是脚本指令还是手动输入指令
        .if lpCommandBuff == NULL
            ; 判断是否正在执行脚本功能
            .if g_bSclFlag == FALSE
                invoke OnSclCommand
                .break
            .endif
            
            invoke RtlZeroMemory, addr @szCommand, MAXBYTE
            invoke crt_printf, offset g_strCmdInput
            
            ; 获取输入缓冲区句柄
            invoke GetStdHandle, STD_INPUT_HANDLE
            mov @hIn, eax
            .if @hIn == NULL
                ret
            .endif
            ; 获取输入内容
            invoke ReadFile, @hIn, addr @szCommand, sizeof @szCommand, addr @dwReadSize, NULL
            ; 清空空格和制表符
            invoke SkipWhiteChar, addr @szCommand
            mov @pCmd, eax
        .else
            ; 判断当前脚本指令是否执行成功
            .if @bScAlreadyRun == FALSE
                mov @bScAlreadyRun, TRUE
            .else
                mov eax, @bScIsNeedRet
                ret
            .endif
        
            ; 清空空格和制表符
            invoke SkipWhiteChar, lpCommandBuff
            mov @pCmd, eax
        .endif
        
        ; 判断是否开启脚本功能
        .if g_bScFlag == TRUE && g_hScFile != INVALID_HANDLE_VALUE && g_hScFile != NULL
            ; 记录执行命令, 且排除脚本命令
            mov eax, [@pCmd] 
            movzx ebx, byte ptr [eax]
            .if ebx == 's'
                movzx ebx, byte ptr[eax + 1]
                .if ebx == 'c'
                    movzx ebx, byte ptr[eax + 2]
                    .if ebx == 's' || ebx == 'e' || ebx == 'l'
                        jmp WHILE_NEXT
                    .endif
                .endif
            .endif
            ; 排除脚本指令自身
            invoke crt_strlen, @pCmd
            invoke WriteFile, g_hScFile, @pCmd, eax, NULL, NULL
            .if eax == FALSE
                invoke MessageBox, NULL, offset g_strScErr, offset g_strTip, MB_OK
            .endif
        .endif
        
    WHILE_NEXT:
        mov eax, [@pCmd] 
        movzx ebx, byte ptr [eax]
        .if ebx == 'b'
            movzx ebx, byte ptr[eax + 1]
            .if ebx == 'p'
                ; bp指令
                mov ebx, @pCmd
                add ebx, 2
                invoke SkipWhiteChar, ebx
                mov @pCmd, eax
                invoke crt_strtoul, @pCmd, NULL, 16
                mov @dwAddr, eax
                .if @dwAddr == NULL
                    invoke crt_printf, g_strAddrErr
                    .continue
                .endif
                invoke OnBpCommand, @dwAddr
                .continue
            .elseif ebx == 'c'
                ; bc指令
                mov ebx, @pCmd
                add ebx, 2
                invoke SkipWhiteChar, ebx
                mov @pCmd, eax
                invoke crt_strtoul, @pCmd, NULL, 10
                mov @dwIndex, eax
                invoke OnBcCommand, @dwIndex
                .continue
            .elseif ebx == 'l'
                ; bl指令
                invoke OnBlCommand
                .continue
            .elseif ebx == 'h'
                movzx ebx, byte ptr[eax + 2]
                .if ebx == 'l'
                    ; 列举硬件断点列表
                    invoke OnBhlCommand
                    .continue
                .elseif ebx == 'c'
                    ; 删除硬件断点
                    mov ebx, @pCmd
                    add ebx, 3
                    invoke SkipWhiteChar, ebx
                    mov @pCmd, eax
                    invoke crt_strtoul, @pCmd, NULL, 10
                    mov @dwIndex, eax
                    invoke OnBhcCommand, @dwIndex
                    .continue
                .else 
                    ; bh addr [1/2/4] [a/e/w]
                    mov ebx, @pCmd
                    add ebx, 2
                    invoke SkipWhiteChar, ebx
                    mov @pCmd, eax
                    ; 获取地址
                    invoke MyStrLen, @pCmd, offset g_btEndCode
                    mov @dwLen, eax
                    .if @dwLen > 8 || @dwLen == 0
                        invoke MessageBox, NULL, offset g_strBHErr, offset g_strTip, NULL
                        .continue
                    .endif
                    invoke crt_strtoul, @pCmd, NULL, 16
                    
                    mov @dwAddr, eax
                    mov ebx, @pCmd
                    add ebx, @dwLen
                    invoke SkipWhiteChar, ebx
                    mov @pCmd, eax
                    
                    ; 获取长度
                    invoke MyStrLen, @pCmd, offset g_btEndCode
                    mov @dwLen, eax
                    .if @dwLen != 1
                        invoke MessageBox, NULL, offset g_strBHErr, offset g_strTip, NULL
                        .continue
                    .endif
                    invoke crt_strtoul, @pCmd, NULL, 10
                    mov @dwBhLen, eax
                    .if !(@dwBhLen == 1 || @dwBhLen == 2 || @dwBhLen == 4)
                        invoke MessageBox, NULL, offset g_strBHErr, offset g_strTip, NULL
                        .continue
                    .endif
                    
                    mov ebx, @pCmd
                    add ebx, @dwLen
                    invoke SkipWhiteChar, ebx
                    mov @pCmd, eax
                    
                    ; 获取类型
                    invoke MyStrLen, @pCmd, offset g_btEndCode
                    mov @dwLen, eax
                    .if @dwLen != 1
                        invoke MessageBox, NULL, offset g_strBHErr, offset g_strTip, NULL
                        .continue
                    .endif
                    
                    mov eax, @pCmd
                    movzx ebx, byte ptr [eax]
                    .if ebx == 'a'
                        ; 硬件访问断点
                        mov @dwBhType, 3 ; 二进制的11
                    .elseif ebx == 'e'
                        ; 硬件执行断点
                        mov @dwBhType, 0 ; 二进制的00
                        mov @dwBhLen, 0
                    .elseif ebx == 'w'
                        ; 硬件写入断点
                        mov @dwBhType, 1 ; 二进制的01
                    .else
                        invoke MessageBox, NULL, offset g_strBHErr, offset g_strTip, NULL
                        .continue
                    .endif
                    invoke OnHardWareCommand, @dwAddr, @dwBhLen, @dwBhType
                    .continue
                .endif
            .elseif ebx == 'm'
                movzx ebx, byte ptr[eax + 2]
                .if ebx == 'l'
                    ; 列举内存断点列表
                    invoke OnBmlCommand
                    .continue
                .elseif ebx == 'c'
                    ; 删除内存断点
                    mov ebx, @pCmd
                    add ebx, 3
                    invoke SkipWhiteChar, ebx
                    mov @pCmd, eax
                    invoke crt_strtoul, @pCmd, NULL, 10
                    mov @dwIndex, eax
                    invoke OnBmcCommand, @dwIndex
                    .continue
                .else 
                    ; bm addr len r/w
                    mov ebx, @pCmd
                    add ebx, 2
                    invoke SkipWhiteChar, ebx
                    mov @pCmd, eax
                    ; 获取地址
                    invoke MyStrLen, @pCmd, offset g_btEndCode
                    mov @dwLen, eax
                    .if @dwLen > 8 || @dwLen == 0
                        invoke MessageBox, NULL, offset g_strBHErr, offset g_strTip, NULL
                        .continue
                    .endif
                    invoke crt_strtoul, @pCmd, NULL, 16
                    
                    mov @dwAddr, eax
                    mov ebx, @pCmd
                    add ebx, @dwLen
                    invoke SkipWhiteChar, ebx
                    mov @pCmd, eax
                    
                    ; 获取长度
                    invoke crt_strtoul, @pCmd, NULL, 10
                    mov @dwBhLen, eax
                    .if @dwBhLen == 0
                        invoke MessageBox, NULL, offset g_strBmErr, offset g_strTip, NULL
                        .continue
                    .endif
                    
                    mov ebx, @pCmd
                    add ebx, @dwLen
                    invoke SkipWhiteChar, ebx
                    mov @pCmd, eax
                    
                    ; 获取类型
                    invoke MyStrLen, @pCmd, offset g_btEndCode
                    mov @dwLen, eax
                    .if @dwLen != 1
                        invoke MessageBox, NULL, offset g_strBmErr, offset g_strTip, NULL
                        .continue
                    .endif
                    
                    mov eax, @pCmd
                    movzx ebx, byte ptr [eax]
                    .if ebx == 'r'
                        ; 内存读断点
                        mov @dwBhType, 1
                    .elseif ebx == 'w'
                        ; 内存写断点
                        mov @dwBhType, 2
                    .else
                        invoke MessageBox, NULL, offset g_strBmErr, offset g_strTip, NULL
                        .continue
                    .endif
                    invoke OnBmCommand, @dwAddr, @dwBhLen, @dwBhType
                    .continue
                .endif
            .elseif ebx == 'k'
                ; 执行到返回
                invoke OnBkCommand
                mov @bScIsNeedRet, TRUE
                .break
            .endif
            
        .elseif ebx == 't'
            movzx ebx, byte ptr[eax + 1]
            .if ebx == 'r'
                ; 指令记录功能 tr addr
                ; 获取地址
                mov ebx, @pCmd
                add ebx, 2
                invoke SkipWhiteChar, ebx
                mov @pCmd, eax
                invoke crt_strtoul, @pCmd, NULL, 16
                mov @dwAddr, eax
                invoke OnTrCommand, @dwAddr
            .else
                ; 单步步入指令
                invoke OnTCommand
            .endif
            mov @bScIsNeedRet, TRUE
            .break
        .elseif ebx == 'p'
            ; 单步步过指令
            invoke OnPCommand
            mov @bScIsNeedRet, TRUE
            .break
        .elseif ebx == 'g'
            ; g addr指令
            mov ebx, @pCmd
            inc ebx
            invoke SkipWhiteChar, ebx
            mov @pCmd, eax
            invoke crt_strtoul, @pCmd, NULL, 16
            mov @dwAddr, eax
            .if @dwAddr != NULL
                invoke OnGoCommand, @dwAddr
            .endif
            mov eax, TRUE
            ret
        .elseif ebx == 'u'
            ; u addr指令
            mov ebx, @pCmd
            inc ebx
            invoke SkipWhiteChar, ebx
            mov @pCmd, eax
            invoke crt_strtoul, @pCmd, NULL, 16
            mov @dwAddr, eax
            invoke OnUCommand, @dwAddr
            .continue
        .elseif ebx == 'r'
            ; 获取数据
            push eax
            mov ebx, @pCmd
            add ebx, 5
            invoke SkipWhiteChar, ebx
            mov @pCmd, eax
            invoke crt_strtoul, @pCmd, NULL, 16
            mov @dwRegVal, eax
            pop eax
            
            movzx ebx, byte ptr[eax + 2]
            .if ebx == 'e'
                movzx ebx, byte ptr[eax + 3]
                .if ebx == 'a'
                    movzx ebx, byte ptr[eax + 4]
                    .if ebx == 'x'
                        ; 修改eax
                        invoke OnEditRCommand, REG_EAX, @dwRegVal
                    .else
                        invoke OnRCommand
                    .endif
                .elseif ebx == 'b'
                    movzx ebx, byte ptr[eax + 4]
                    .if ebx == 'x'
                        ; 修改ebx
                        invoke OnEditRCommand, REG_EBX, @dwRegVal
                    .elseif ebx == 'p'
                        ; 修改ebp
                        invoke OnEditRCommand, REG_EBP, @dwRegVal
                    .else
                        invoke OnRCommand
                    .endif
                .elseif ebx == 'c'
                    movzx ebx, byte ptr[eax + 4]
                    .if ebx == 'x'
                        ; 修改ecx
                        invoke OnEditRCommand, REG_ECX, @dwRegVal
                    .else
                        invoke OnRCommand
                    .endif
                .elseif ebx == 'd'
                    movzx ebx, byte ptr[eax + 4]
                    .if ebx == 'x'
                        ; 修改edx
                        invoke OnEditRCommand, REG_EDX, @dwRegVal
                    .elseif ebx == 'i'
                        ; 修改edi
                        invoke OnEditRCommand, REG_EDI, @dwRegVal
                    .else
                        invoke OnRCommand
                    .endif
                .elseif ebx == 's'
                    movzx ebx, byte ptr[eax + 4]
                    .if ebx == 'i'
                        ; 修改esi
                        invoke OnEditRCommand, REG_ESI, @dwRegVal
                    .elseif ebx == 'p'
                        ; 修改esp
                        invoke OnEditRCommand, REG_ESP, @dwRegVal
                    .else
                        invoke OnRCommand
                    .endif
                .endif
            .else
                invoke OnRCommand
            .endif
            .continue
        .elseif ebx == 'd'
            movzx ebx, byte ptr[eax + 1]
            
            .if ebx == 'b'
                ; db 指令
                ; 获取地址
                mov ebx, @pCmd
                add ebx, 2
                invoke SkipWhiteChar, ebx
                mov @pCmd, eax
                invoke crt_strtoul, @pCmd, NULL, 16
                mov @dwAddr, eax
                
                invoke OnDBCommand, @dwAddr
                .continue
            .elseif ebx == 'd'
                ; dd 指令
                ; 获取地址
                mov ebx, @pCmd
                add ebx, 2
                invoke SkipWhiteChar, ebx
                mov @pCmd, eax
                invoke crt_strtoul, @pCmd, NULL, 16
                mov @dwAddr, eax
                
                invoke OnDDCommand, @dwAddr
                .continue
            .elseif ebx == 'w'
                ; dw 指令
                ; 获取地址
                mov ebx, @pCmd
                add ebx, 2
                invoke SkipWhiteChar, ebx
                mov @pCmd, eax
                invoke crt_strtoul, @pCmd, NULL, 16
                mov @dwAddr, eax
                
                invoke OnDWCommand, @dwAddr
                .continue
            .elseif ebx == 'u'
                movzx ebx, byte ptr[eax + 2]
                .if ebx == 'm'
                    movzx ebx, byte ptr[eax + 3]
                    .if ebx == 'p'
                        ; dump指令
                        invoke OnDumpCommand
                        .if eax == FALSE
                            invoke MessageBox, NULL, offset g_strDumpErr, offset g_strTip, NULL
                        .endif
                    .endif
                .endif
                .continue
            .endif
        .elseif ebx == 'e'
            ; 修改内存数据
            movzx ebx, byte ptr[eax + 1]
            mov edi, ebx
            
            mov ebx, @pCmd
            add ebx, 2
            invoke SkipWhiteChar, ebx
            mov @pCmd, eax
            
            ; 获取地址
            invoke MyStrLen, @pCmd, offset g_btEndCode
            mov @dwLen, eax
            .if @dwLen > 8 || @dwLen == 0
                invoke MessageBox, NULL, offset g_strBHErr, offset g_strTip, NULL
                .continue
            .endif
            invoke crt_strtoul, @pCmd, NULL, 16
            mov @dwAddr, eax
            
            mov ebx, @pCmd
            add ebx, @dwLen
            invoke SkipWhiteChar, ebx
            mov @pCmd, eax
            
            ; 获取数据
            invoke crt_strtoul, @pCmd, NULL, 16
            mov @dwMenVal, eax
            
            .if edi == 'b'
                invoke OnECommand, @dwAddr, @dwMenVal, 1
            .elseif edi == 'w'
                invoke OnECommand, @dwAddr, @dwMenVal, 2
            .elseif edi == 'd'
                invoke OnECommand, @dwAddr, @dwMenVal, 4
            .endif
        .elseif ebx == 'm'
            movzx ebx, byte ptr[eax + 1]
            .if ebx == 'l'
                invoke OnMlCommand
                .if eax == FALSE
                    invoke MessageBox, NULL, offset g_strMlErr, offset g_strTip, NULL
                .endif
            .endif
        .elseif ebx == 's'
            movzx ebx, byte ptr[eax + 1]
            .if ebx == 'c'
                movzx ebx, byte ptr[eax + 2]
                .if ebx == 's'
                    ; scs 开始脚本指令
                    invoke OnScsCommand
                .elseif ebx == 'e'
                    ; sce 结束脚本指令
                    invoke OnSceCommand
                .elseif ebx == 'l'
                    ; scl 加载脚本指令
                    invoke OnSclCommand
                    .break
                .endif
            .endif
        .elseif ebx == 'h'
            invoke OnHelpCommand
        .endif
    .endw
    
    mov eax, @bScIsNeedRet
    ret
    
InputCommand endp

; 通过函数地址获取其所在模块信息
GetModuleInfoByFuncAddr proc dwFuncAddr:DWORD, lpMe32:ptr MODULEENTRY32
    LOCAL @hProcess:HANDLE
    LOCAL @me32:MODULEENTRY32 
    LOCAL @dwModuleMinSize:DWORD
    LOCAL @dwModuleMaxSize:DWORD
    
    mov @hProcess, NULL
    mov @dwModuleMinSize, NULL
    mov @dwModuleMaxSize, NULL
    
    invoke RtlZeroMemory, addr @me32, sizeof MODULEENTRY32
    mov @me32.dwSize, sizeof MODULEENTRY32
    
    invoke CreateToolhelp32Snapshot, TH32CS_SNAPMODULE, g_dwPid
    mov @hProcess, eax
    .if @hProcess == INVALID_HANDLE_VALUE 
        xor eax, eax
        ret
    .endif
    
    invoke Module32First, @hProcess, addr @me32
    .while TRUE
        .if eax == FALSE
            .break
        .endif
        
        mov eax, @me32.modBaseAddr
        mov @dwModuleMinSize, eax
        add eax, @me32.modBaseSize
        mov @dwModuleMaxSize, eax
        
        mov eax, dwFuncAddr
        .if eax >= @dwModuleMinSize && eax < @dwModuleMaxSize
            lea eax, @me32
            invoke crt_memcpy, lpMe32, eax, sizeof MODULEENTRY32
            
            .if @hProcess != NULL && @hProcess != INVALID_HANDLE_VALUE
                invoke CloseHandle, @hProcess
            .endif
            
            mov eax, TRUE
            ret
        .endif
        
        invoke Module32Next, @hProcess, addr @me32
    .endw
    
    .if @hProcess != NULL && @hProcess != INVALID_HANDLE_VALUE
        invoke CloseHandle, @hProcess
    .endif
    
    xor eax, eax
    ret

GetModuleInfoByFuncAddr endp

; 显示反汇编
ShowAsmInfo proc uses ebx ecx edi pAddr:LPVOID
    LOCAL @aryCode[16]:BYTE
    LOCAL @szAsm[MAXBYTE]:BYTE
    LOCAL @nAsmLen:UINT
    LOCAL @szOutputBuff[MAXBYTE]:BYTE
    LOCAL @dwAsmCodeType:DWORD
    LOCAL @dwFuncAddr:DWORD
    LOCAL @me32:MODULEENTRY32 
    LOCAL @imgDosHeader:IMAGE_DOS_HEADER
    LOCAL @imgNtHeader32:IMAGE_NT_HEADERS32
    LOCAL @imgExportTable:IMAGE_EXPORT_DIRECTORY
    LOCAL @dwAddrsTable:ptr DWORD
    LOCAL @dwNamesTable:ptr DWORD
    LOCAL @dwOrdinalsTable:ptr DWORD
    LOCAL @dwIndex:DWORD
    LOCAL @dwOrdinalVal:DWORD
    LOCAL @dwAddrRVA:DWORD
    LOCAL @dwAddrName:DWORD
    LOCAL @szFuncName[MAXBYTE]:ptr BYTE
    LOCAL @bIsFindFuncName:BOOL
    LOCAL @szFuncOutputBuff[MAXBYTE]:BYTE
    LOCAL @szModuleName[MAXBYTE]:BYTE
    LOCAL @bIsIndirect:BOOL
    
    xor eax, eax
    mov @nAsmLen, eax
    mov @dwAsmCodeType, eax
    mov @dwAddrsTable, eax
    mov @dwNamesTable, eax
    mov @dwOrdinalsTable, eax
    mov @dwIndex, eax
    mov @dwOrdinalVal, eax
    mov @dwAddrRVA, eax
    mov @dwAddrName, eax
    mov @bIsFindFuncName, eax
    mov @bIsIndirect, eax
    invoke RtlZeroMemory, addr @aryCode, sizeof @aryCode
    invoke RtlZeroMemory, addr @szAsm, MAXBYTE
    invoke RtlZeroMemory, addr @szOutputBuff, MAXBYTE
    invoke RtlZeroMemory, addr @me32, sizeof MODULEENTRY32
    invoke RtlZeroMemory, addr @szFuncName, MAXBYTE
    invoke RtlZeroMemory, addr @szFuncOutputBuff, MAXBYTE
    invoke RtlZeroMemory, addr @szModuleName, MAXBYTE
    
    invoke ReadProcessMemory, g_hProcess, pAddr, addr @aryCode, sizeof @aryCode, NULL
    invoke Decode2Asm, addr @aryCode, addr @szAsm, addr @nAsmLen, pAddr
    
    ; 判断是否为记录指令功能
    .if g_bTrFlag == TRUE && g_hAsmFile != NULL && g_hAsmFile != INVALID_HANDLE_VALUE
        invoke wsprintf, addr @szOutputBuff, offset g_strAsmOutput, pAddr, addr @szAsm
        invoke crt_strlen, addr @szOutputBuff
        invoke WriteFile, g_hAsmFile, addr @szOutputBuff, eax, NULL, NULL
        .if eax == FALSE
            mov g_bTrFlag, FALSE
            mov g_dwTrDestAddr, NULL
            invoke CloseHandle, g_hAsmFile
            mov g_hAsmFile, NULL
            invoke DeleteFile, offset g_strTrFileName
            invoke MessageBox, NULL, offset g_strTrErr, offset g_strTip, MB_OK
        .endif
    .endif
    
    ; 判断是否为call
    invoke crt_strstr, addr @szAsm, offset g_strCmpCall
    .if eax != 0
        mov @dwAsmCodeType, 1
        lea eax, @szAsm
        add eax, 4
        mov edi, eax
    .endif
    
    ; 判断是否为jmp
    invoke crt_strstr, addr @szAsm, offset g_strCmpJmp
    .if eax != 0
        mov @dwAsmCodeType, 2
        lea eax, @szAsm
        add eax, 3
    .else
        mov eax, edi
    .endif
    
    ; 如果是Call或者Jmp则查找函数名称
    .if @dwAsmCodeType != 0
        ; 函数va
        lea ecx, @aryCode
        movzx ebx, byte ptr [ecx]
        movzx edi, byte ptr [ecx + 1]
        .if ebx == 0ffh && ( edi == 015h || edi == 025h)
            ; 间接call或间接jmp
            mov @bIsIndirect, TRUE
            mov ecx, [ecx + 2]
            invoke ReadProcessMemory, g_hProcess, ecx, addr @dwFuncAddr, sizeof DWORD, NULL
        .else
            invoke crt_strtoul, eax, NULL, 16
            mov @dwFuncAddr, eax
        .endif
        
        invoke GetModuleInfoByFuncAddr, @dwFuncAddr, addr @me32
        .if eax == TRUE
            ; VA转RVA
            mov eax, @dwFuncAddr
            sub eax, @me32.modBaseAddr
            mov @dwFuncAddr, eax
            
            ; 获取DLL的DOS头
            mov ecx, @me32.modBaseAddr
            invoke ReadProcessMemory, g_hProcess, ecx, addr @imgDosHeader, sizeof IMAGE_DOS_HEADER, NULL
            ; 读取Nt头
            mov ecx, @me32.modBaseAddr
            add ecx, @imgDosHeader.e_lfanew
            invoke ReadProcessMemory, g_hProcess, ecx, addr @imgNtHeader32, sizeof IMAGE_NT_HEADERS32, NULL
            ; 获取导出表
            mov ecx, dword ptr @imgNtHeader32.OptionalHeader.DataDirectory
            .if ecx == NULL
                ; 没有导入表
                jmp WSPRINTF
            .endif
            add ecx, @me32.modBaseAddr
            invoke ReadProcessMemory, g_hProcess, ecx, addr @imgExportTable, sizeof IMAGE_EXPORT_DIRECTORY, NULL
            
            ; 获取导出地址表
            mov ecx, @imgExportTable.AddressOfFunctions
            add ecx, @me32.modBaseAddr
            mov @dwAddrsTable, ecx
            ; 获取导出符号表
            mov ecx, @imgExportTable.AddressOfNameOrdinals
            add ecx, @me32.modBaseAddr
            mov @dwOrdinalsTable, ecx
            ; 获取导出名称表
            mov ecx, @imgExportTable.AddressOfNames
            add ecx, @me32.modBaseAddr
            mov @dwNamesTable, ecx
            
            ; 循环次数
            mov ecx, @imgExportTable.NumberOfNames
            .while TRUE
                .if @dwIndex >= ecx
                    .break
                .endif
                push ecx
                ; 读取序号
                mov ebx, @dwOrdinalsTable
                invoke ReadProcessMemory, g_hProcess, ebx, addr @dwOrdinalVal, sizeof WORD, NULL
                
                ; 读取序号所在的函数RVA
                mov eax, @dwOrdinalVal
                mov ebx, sizeof DWORD
                mul ebx
                add eax, @dwAddrsTable
                mov ebx, eax
                invoke ReadProcessMemory, g_hProcess, ebx, addr @dwAddrRVA, sizeof DWORD, NULL
                
                mov ebx, @dwAddrRVA
                .if ebx == @dwFuncAddr
                    ; 读取下标所在函数名称RVA
                    mov eax, @dwIndex
                    mov ebx, sizeof DWORD
                    mul ebx
                    add eax, @dwNamesTable
                    mov ebx, eax
                    invoke ReadProcessMemory, g_hProcess, ebx, addr @dwAddrName, sizeof DWORD, NULL
                    
                    ; 读取函数名称
                    mov ebx, @dwAddrName
                    add ebx, @me32.modBaseAddr
                    invoke ReadProcessMemory, g_hProcess, ebx, addr @szFuncName, MAXBYTE, NULL
                    
                    mov @bIsFindFuncName, TRUE
                    .break
                .endif
                
                ; 序号表自增
                mov eax, @dwOrdinalsTable
                add eax, sizeof WORD
                mov @dwOrdinalsTable, eax
                inc @dwIndex
                pop ecx
            .endw
            
        WSPRINTF:
            invoke MyStrLen, addr @me32.szModule, offset g_btDotCode
            invoke crt_memcpy, addr @szModuleName,addr @me32.szModule, eax
            .if @bIsIndirect == TRUE
                .if @bIsFindFuncName == TRUE
                    invoke wsprintf, addr @szFuncOutputBuff, offset g_strIATFuncName1, addr @szModuleName, addr @szFuncName
                    .if @dwAsmCodeType == 1 ; call
                        invoke crt_printf, offset g_strAsmCallOutput, pAddr, addr @szFuncOutputBuff
                    .elseif @dwAsmCodeType == 2 ; jmp
                        invoke crt_printf, offset g_strAsmJmpOutput, pAddr, addr @szFuncOutputBuff
                    .endif
                .else
                    mov ebx, @dwFuncAddr
                    add ebx, @me32.modBaseAddr
                    invoke wsprintf, addr @szFuncOutputBuff, offset g_strIATFuncName2, addr @szModuleName, ebx
                    .if @dwAsmCodeType == 1 ; call
                        invoke crt_printf, offset g_strAsmCallOutput, pAddr, addr @szFuncOutputBuff
                    .elseif @dwAsmCodeType == 2 ; jmp
                        invoke crt_printf, offset g_strAsmJmpOutput, pAddr, addr @szFuncOutputBuff
                    .endif
                .endif
            .else
                .if @bIsFindFuncName == TRUE
                    invoke wsprintf, addr @szFuncOutputBuff, offset g_strIATFuncName3, addr @szModuleName, addr @szFuncName
                    .if @dwAsmCodeType == 1 ; call
                        invoke crt_printf, offset g_strAsmCallOutput, pAddr, addr @szFuncOutputBuff
                    .elseif @dwAsmCodeType == 2 ; jmp
                        invoke crt_printf, offset g_strAsmJmpOutput, pAddr, addr @szFuncOutputBuff
                    .endif
                .else
                    mov ebx, @dwFuncAddr
                    add ebx, @me32.modBaseAddr
                    invoke wsprintf, addr @szFuncOutputBuff, offset g_strIATFuncName4, addr @szModuleName, ebx
                    .if @dwAsmCodeType == 1 ; call
                        invoke crt_printf, offset g_strAsmCallOutput, pAddr, addr @szFuncOutputBuff
                    .elseif @dwAsmCodeType == 2 ; jmp
                        invoke crt_printf, offset g_strAsmJmpOutput, pAddr, addr @szFuncOutputBuff
                    .endif
                .endif
            .endif

        .else
            invoke crt_printf, offset g_strAsmOutput, pAddr, addr @szAsm
        .endif
    .else
        invoke crt_printf, offset g_strAsmOutput, pAddr, addr @szAsm
    .endif
    
    mov eax, @nAsmLen
    ret

ShowAsmInfo endp

; 处理异常
OnExceptionDebugEvent proc
    LOCAL @dwResult:DWORD
    
    mov @dwResult, DBG_EXCEPTION_NOT_HANDLED
    
    ; 判断是否系统断点
    .if g_bIsSystemBp == TRUE
        mov g_bIsSystemBp, FALSE
        ;显示反汇编
        invoke ShowAsmInfo, g_DebugEvent.u.Exception.pExceptionRecord.ExceptionAddress
        ;提示输入指令
        invoke InputCommand, NULL
        mov @dwResult, DBG_CONTINUE
        mov eax, @dwResult
        ret
    .endif
    
    ; 判断异常类型
    .if g_DebugEvent.u.Exception.pExceptionRecord.ExceptionCode == EXCEPTION_BREAKPOINT ; CC断点
        invoke OnBreakPoint
        mov @dwResult, eax
    .elseif g_DebugEvent.u.Exception.pExceptionRecord.ExceptionCode == EXCEPTION_SINGLE_STEP ; 单步异常
        invoke OnSingleStep
        mov @dwResult, eax
    .endif
    
    mov eax, @dwResult
    ret

OnExceptionDebugEvent endp

RunDebugLoop proc
    LOCAL @dwResult:DWORD
    
    ; 循环等待调试事件
    .while TRUE
        mov @dwResult, DBG_EXCEPTION_NOT_HANDLED
        
        invoke WaitForDebugEvent, addr g_DebugEvent, INFINITE
        .if eax == FALSE
            .break
        .endif
        
        invoke OpenThread, THREAD_ALL_ACCESS, FALSE, g_DebugEvent.dwThreadId
        mov g_hExeThread, eax
        
        .if g_DebugEvent.dwDebugEventCode == EXCEPTION_DEBUG_EVENT
            invoke OnExceptionDebugEvent
            mov @dwResult, eax
        .elseif g_DebugEvent.dwDebugEventCode == EXIT_THREAD_DEBUG_EVENT
            
        .elseif g_DebugEvent.dwDebugEventCode == EXIT_PROCESS_DEBUG_EVENT
	        ret
        .elseif g_DebugEvent.dwDebugEventCode == LOAD_DLL_DEBUG_EVENT
            
        .elseif g_DebugEvent.dwDebugEventCode == UNLOAD_DLL_DEBUG_EVENT
            
        .endif
        
        ; 提交处理结果
        invoke ContinueDebugEvent, g_DebugEvent.dwProcessId, g_DebugEvent.dwThreadId, @dwResult
        
        .if g_hExeThread != NULL
            invoke CloseHandle, g_hExeThread
        .endif
        
    .endw
    ret

RunDebugLoop endp

Debug proc lpStrFileName:DWORD
    LOCAL @si:STARTUPINFO
    LOCAL @pi:PROCESS_INFORMATION
    
    invoke RtlZeroMemory, addr @si, sizeof STARTUPINFO
    invoke RtlZeroMemory, addr @pi, sizeof PROCESS_INFORMATION
    mov @si.cb, sizeof STARTUPINFO
    
    invoke CreateProcess, NULL, lpStrFileName, NULL, NULL, FALSE, DEBUG_ONLY_THIS_PROCESS, NULL, NULL, addr @si, addr @pi
    .if eax == 0
        invoke MessageBox, NULL, offset g_strOpenProcErr, offset g_strTip, MB_OK
    .endif
    
    mov eax, @pi.hProcess
    mov g_hProcess, eax
    mov eax, @pi.dwProcessId
    mov g_dwPid, eax
    invoke CloseHandle, @pi.hThread
    
    invoke RunDebugLoop
    
    ret
    
Debug endp

main proc
    LOCAL @szFileName[MAX_PATH]:CHAR
    LOCAL @ofn:OPENFILENAME
    LOCAL @pVec:ptr DWORD
    LOCAL @bpi:BREAK_POINT_INFO
    LOCAL @bpi2:BREAK_POINT_INFO
    
    ; 申请资源
    invoke NewVector
    mov g_pVecBreakPoint, eax
    
    invoke RtlZeroMemory, addr @szFileName, MAX_PATH
    invoke RtlZeroMemory, addr @ofn, sizeof OPENFILENAME
    mov @ofn.lStructSize, sizeof OPENFILENAME
    lea eax, @szFileName
    mov @ofn.lpstrFile, eax
    mov @ofn.nMaxFile, MAX_PATH
    mov @ofn.lpstrFilter, offset g_strFilter
    mov @ofn.nFilterIndex, 1
    invoke GetOpenFileName, addr @ofn
    .if eax == 1
        invoke Debug, addr @szFileName
    .endif
    
	; 释放资源
    invoke DeleteVector, g_pVecBreakPoint
    ret

main endp

start:

	invoke GetModuleHandle,NULL
	mov g_hInstance,eax
	invoke main
	
	invoke ExitProcess,0

;########################################################################

end start
