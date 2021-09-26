// dllmain.cpp : 定义 DLL 应用程序的入口点。
#include "pch.h"
#include "dllmain.h"


vector<DWORD>* __stdcall NewVector()
{
    return new vector<DWORD>;
}

void __stdcall DeleteVector(vector<DWORD>* pVec)
{
    delete pVec;
}

void __stdcall AddItem(vector<DWORD>* pVec, DWORD lpItem)
{
    pVec->push_back(lpItem);
}

void __stdcall GetItem(vector<DWORD>* pVec, DWORD* lpItem, DWORD dwIndex)
{
    *lpItem = (*pVec)[dwIndex];
}

void __stdcall DeleteItem(vector<DWORD>* pVec, DWORD dwIndex)
{
    pVec->erase(pVec->begin() + dwIndex);
}

DWORD __stdcall GetVectorSize(vector<DWORD>* pVec)
{
    return pVec->size();
}