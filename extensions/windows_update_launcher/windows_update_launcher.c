#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <shellapi.h>

#define NBS_EXPORT __declspec(dllexport)

/*
 * Starts the downloaded updater through the Windows shell so that an
 * installer with requireAdministrator in its manifest receives a UAC prompt.
 *
 * GameMaker passes strings to native extensions as UTF-8. Return zero after
 * the process has been created, or the Win32 error code when it was not.
 */
NBS_EXPORT double windows_update_launch(char *executable_path_utf8) {
    if (executable_path_utf8 == NULL || executable_path_utf8[0] == '\0') {
        return (double)ERROR_INVALID_PARAMETER;
    }

    int path_length = MultiByteToWideChar(
        CP_UTF8,
        MB_ERR_INVALID_CHARS,
        executable_path_utf8,
        -1,
        NULL,
        0
    );

    if (path_length == 0) {
        DWORD error = GetLastError();
        return (double)(error != ERROR_SUCCESS ? error : ERROR_NO_UNICODE_TRANSLATION);
    }

    HANDLE process_heap = GetProcessHeap();
    wchar_t *executable_path = (wchar_t *)HeapAlloc(
        process_heap,
        0,
        (SIZE_T)path_length * sizeof(wchar_t)
    );

    if (executable_path == NULL) {
        return (double)ERROR_NOT_ENOUGH_MEMORY;
    }

    if (MultiByteToWideChar(
            CP_UTF8,
            MB_ERR_INVALID_CHARS,
            executable_path_utf8,
            -1,
            executable_path,
            path_length
        ) == 0) {
        DWORD error = GetLastError();
        HeapFree(process_heap, 0, executable_path);
        return (double)(error != ERROR_SUCCESS ? error : ERROR_NO_UNICODE_TRANSLATION);
    }

    SHELLEXECUTEINFOW execute_info;
    ZeroMemory(&execute_info, sizeof(execute_info));
    execute_info.cbSize = sizeof(execute_info);
    execute_info.fMask = SEE_MASK_NOCLOSEPROCESS | SEE_MASK_NOASYNC;
    execute_info.hwnd = GetActiveWindow();
    execute_info.lpVerb = L"runas";
    execute_info.lpFile = executable_path;
    execute_info.nShow = SW_SHOWNORMAL;

    SetLastError(ERROR_SUCCESS);
    BOOL launched = ShellExecuteExW(&execute_info);
    DWORD error = launched ? ERROR_SUCCESS : GetLastError();

    if (execute_info.hProcess != NULL) {
        CloseHandle(execute_info.hProcess);
    }
    HeapFree(process_heap, 0, executable_path);

    if (!launched && error == ERROR_SUCCESS) {
        error = ERROR_GEN_FAILURE;
    }

    return (double)error;
}
