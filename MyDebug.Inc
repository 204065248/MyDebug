include windows.inc
include kernel32.inc
include user32.inc
include msvcrt.inc
include Comctl32.inc
include shell32.inc
include comdlg32.inc
include Disasm.inc
include vector.inc

includelib kernel32.lib
includelib user32.lib
includelib Disasm.lib
includelib msvcrt.lib
includelib Comctl32.lib
includelib shell32.lib
includelib Comdlg32.lib
includelib vector.lib

; Test.exe 00401030
; 主入口 01012475
; 010064A4    | 8B 4D 10                | mov ecx,dword ptr ss:[ebp+10]   |
; Test1.exe
; 主入口:        00319e30
; 硬件写入/访问: 003A53D8 
; 断点结构体
; CC断点
CC_BREAK_POINT equ 1
; 临时断点
TMP_BREAK_POINT equ 2
; 内存断点
MEM_BREAK_POINT equ 3
; 断点结构体信息
BREAK_POINT_INFO struct
    m_dwAddr DWORD 0
    m_btOldCode BYTE 0
    m_bReset BOOL 0
    m_dwBreakPointType DWORD 0
    ; 内存断点特有属性
    m_dwLen DWORD 0
    m_dwAttributeType DWORD 0
BREAK_POINT_INFO ends

; 硬件断点记录结构体
HAREWARE_FLAG struct
    _DR0 BOOL FALSE
    _DR1 BOOL FALSE
    _DR2 BOOL FALSE
    _DR3 BOOL FALSE
HAREWARE_FLAG ends

; 定义寄存器宏
REG_EAX equ 1
REG_EBX equ 2
REG_ECX equ 3
REG_EDX equ 4
REG_EBP equ 5
REG_ESP equ 6
REG_ESI equ 7
REG_EDI equ 8