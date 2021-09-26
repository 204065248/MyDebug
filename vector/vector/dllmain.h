#pragma once
#include <Windows.h>
#include <vector>

using namespace std;

extern "C"
{
    vector<DWORD>* __stdcall NewVector();
    void __stdcall DeleteVector(vector<DWORD>* pVec);
    void __stdcall AddItem(vector<DWORD>* pVec, DWORD lpItem);
    void __stdcall GetItem(vector<DWORD>* pVec, DWORD* lpItem, DWORD dwIndex);
    void __stdcall DeleteItem(vector<DWORD>* pVec, DWORD dwIndex);
    DWORD __stdcall GetVectorSize(vector<DWORD>* pVec);
};