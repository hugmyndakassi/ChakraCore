::-------------------------------------------------------------------------------------------------------
:: Copyright (C) Microsoft. All rights reserved.
:: Copyright (c) 2021 ChakraCore Project Contributors. All rights reserved.
:: Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
::-------------------------------------------------------------------------------------------------------

if "%_ENTRY_SCRIPT_NAME%"=="" (
    echo This script is a utility and should not be called as a script entry point.
)

:ContinueArgParse
if not "%1"=="" (
    :: _TestArch
    if "%1"=="x86" (
        set _TestArch=x86
        shift
        goto :ContinueArgParse
    ) else if "%1"=="x64" (
        set _TestArch=x64
        shift
        goto :ContinueArgParse
    )
    REM arm tests not supported at present

    :: _TestArch (deprecated name)
    if "%1"=="amd64" (
        set _TestArch=x64
        shift
        goto :ContinueArgParse
    )

    :: _TestType (new names)
    if "%1"=="debug" (
        set _TestType=debug
        shift
        goto :ContinueArgParse
    ) else if "%1"=="test" (
        set _TestType=test
        shift
        goto :ContinueArgParse
    )

    :: _TestType (old names)
    if "%1"=="chk" (
        set _TestType=debug
        shift
        goto :ContinueArgParse
    )
    
    if "%1"=="-swb" (
        :: todo: disallow -swb -disablejit combination
        set _SpecialBuild=.SWB
        goto :ContinueArgParse
    )

    if "%1"=="-dirs" (
        set _ReducedTestRun=1
        REM fallthrough to default (also add this to %_ExtraTestArgs%)
    )

    if "%1"=="-tags" (
        set _ReducedTestRun=1
        REM fallthrough to default (also add this to %_ExtraTestArgs%)
    )

    if "%1"=="-nottags" (
        set _ReducedTestRun=1
        REM fallthrough to default (also add this to %_ExtraTestArgs%)
    )

    if "%1"=="-disablejit" (
        set _SpecialBuild=.NoJIT
        shift
        goto :ContinueArgParse
    )

    if "%1"=="-lite" (
        set _SpecialBuild=.Lite
        REM fallthrough to default (also add this to %_ExtraTestArgs%)
    )

    :: default
    set _ExtraTestArgs=%_ExtraTestArgs% %1
    shift
    goto :ContinueArgParse
)

if "%_TestArch%"=="" (
    goto :invalidTestArch
)
if "%_TestType%"=="" (
    goto :invalidTestType
)

goto :end

:: ============================================================================
:: Invald Test Arch
:: ============================================================================
:invalidTestArch

    echo None of the parameters were a valid test architecture. Please specify both architecture and type.
    goto :examples

:: ============================================================================
:: Invald Test Type
:: ============================================================================
:invalidTestType

    echo None of the parameters were a valid test type. Please specify both architecture and type.
    goto :examples

:: ============================================================================
:: Examples
:: ============================================================================
:examples

    echo Examples:
    echo.
    echo     %_ENTRY_SCRIPT_NAME% x86 debug
    echo     %_ENTRY_SCRIPT_NAME% x86 test
    echo.
    echo     %_ENTRY_SCRIPT_NAME% x64 debug
    echo     %_ENTRY_SCRIPT_NAME% x64 test

    goto :end

:: ============================================================================
:: Epilogue of script (cleanup)
:: ============================================================================
:end
