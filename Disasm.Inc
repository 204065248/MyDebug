include windows.inc

; IN PBYTE pCodeEntry,   // 需要解析指令地址
; OUT char* strAsmCode,  // 得到反汇编指令信息
; OUT UINT* pnCodeSize,  // 解析指令长度
; UINT nAddress
Decode2Asm proto :ptr BYTE, :ptr byte, :ptr UINT, :UINT

; IN PBYTE pCodeEntry,   // 需要解析指令地址
; OUT char* strAsmCode,  // 得到反汇编指令信息
; OUT char* strOpcode,   // 解析机器码信息
; OUT UINT* pnCodeSize,  // 解析指令长度
; UINT nAddress        
Decode2AsmOpcode proto :ptr BYTE, :ptr byte, :ptr byte, :ptr UINT, :UINT