#define WIN32_LEAN_AND_MEAN
#include <windows.h>

extern "C"
{
	UINT main();

	DWORD writeLine(wchar_t *str);
	void readLine(wchar_t *dest, DWORD maxLen);
}

HANDLE cout;
HANDLE cin;

DWORD writeLine(wchar_t *str)
{
	DWORD ret;
	wchar_t *beg = str;
	while (*str)
		++str;
	WriteFile(cout, beg, (DWORD)((str - beg) * sizeof(wchar_t)), &ret, 0);
	return ret >> 1;
}

void readLine(wchar_t *dest, DWORD maxLen)
{
	DWORD ret;
	ReadConsole(cin, dest, maxLen + 1, &ret, 0);
	dest[ret] = L'\0';
}

void mainCRTStartup()
{
	cout = GetStdHandle(STD_OUTPUT_HANDLE);
	cin = GetStdHandle(STD_INPUT_HANDLE);

    ExitProcess(main());
}
