#--------------------------------------------------------------------------------------------------#
#                                                                                                  #
# JCL Examples                                                                                     #
#                                                                                                  #
#--------------------------------------------------------------------------------------------------#

!ifndef ROOT
ROOT = $(MAKEDIR)\..
!endif
#---------------------------------------------------------------------------------------------------
SRC = ..\Source
DCU = ..\Dcu
BIN = ..\Bin
MAP = $(BIN)\$&.map
DRC = $&.drc
#---------------------------------------------------------------------------------------------------
MAKE = $(ROOT)\bin\make.exe -$(MAKEFLAGS) -f$**
DCC = $(ROOT)\bin\dcc32.exe -e$(BIN) -i$(SRC) -n$(DCU) -q -w -u$(SRC) $**
DCCU = $(ROOT)\bin\dcc32.exe -e$(BIN) -i$(SRC) -n$(DCU) -q -w $**
BRCC = $(ROOT)\bin\brcc32.exe $**
MAKEJCLDBG = $(BIN)\makejcldbg.exe -j
#---------------------------------------------------------------------------------------------------
default: \
  MakeJclDbg.exe \
  ApiHookExample.exe \
  AppInstExample.exe \
  CreateProcAsUserExample.exe \
  FramesTrackExample.exe \
  LanManExample.exe \
  LocalesExample.exe \
  MapiExample.exe \
  MultiMediaExample.exe \
  NtSvcExample.exe \
  PeFuncExample.exe \
  ReadMailExample.exe \
  RegistryExample.exe \
  RTTIExample.exe \
  SingleInstExample.exe \
  SourceLocExample.exe \
  SysInfoExample.exe \
  TextReaderExample.exe \
  UnmangleNameExample.exe \
  VerInfoExample.exe \
  StackTrackExample.exe \
  ThreadExceptExample.exe \
  StackTrackDLLsExample.exe \
  StackTrackDLLsStaticLibrary.dll \
  StackTrackDLLsDynamicLibrary.dll \
  StackTrackDLLsComLibrary.dll
#---------------------------------------------------------------------------------------------------

MakeJclDbg.exe: debugextension\tools\MakeJclDbg.dpr
  $(DCC)

ApiHookExample.exe: ApiHookExample.dpr
  $(DCC)

AppInstExample.exe: AppInstExample.dpr
  $(DCC)

CreateProcAsUserExample.exe: CreateProcAsUserExample.dpr
  $(DCC)

FramesTrackExample.exe: FramesTrackExample.dpr
  $(DCC) -gd
  $(MAKEJCLDBG) $(MAP)
  del $(MAP)
  del $(DRC)

LanManExample.exe: LanManExample.dpr
  $(DCC)

LocalesExample.exe: LocalesExample.dpr
  $(DCC)

MapiExample.exe: MapiExample.dpr
  $(DCC)

MultiMediaExample.exe: MultiMediaExample.dpr
  $(DCC)

NtSvcExample.exe: NtSvcExample.dpr
  $(DCC)

PeFuncExample.exe: PeFuncExample.dpr
  $(DCC)

ReadMailExample.exe: ReadMailExample.dpr
  $(DCC)

RegistryExample.exe: RegistryExample.dpr
  $(DCC)

RTTIExample.exe: RTTIExample.dpr
  $(DCC)

SingleInstExample.exe: SingleInstExample.dpr
  $(DCC)

SourceLocExample.exe: SourceLocExample.dpr
  $(DCC) -gd
  $(MAKEJCLDBG) $(MAP)
  del $(MAP)
  del $(DRC)

SysInfoExample.exe: SysInfoExample.dpr
  $(DCC)

TextReaderExample.exe: TextReaderExample.dpr
  $(DCC)

UnmangleNameExample.exe: UnmangleNameExample.dpr
  $(DCC)

VerInfoExample.exe: VerInfoExample.dpr
  $(DCC)

#--------------------------------------------------------------------------------------------------#
#                                                                                                  #
# JCL Debug Examples                                                                               #
#                                                                                                  #
#--------------------------------------------------------------------------------------------------#

StackTrackExample.exe: StackTrackExample.dpr
  $(DCC) -gd
  $(MAKEJCLDBG) $(MAP)
  del $(MAP)
  del $(DRC)

ThreadExceptExample.exe: ThreadExceptExample.dpr
  $(DCCU) -gd -u$(SRC);debugextension\threadnames
  $(MAKEJCLDBG) $(MAP)
  del $(MAP)
  del $(DRC)

StackTrackDLLsExample.exe: StackTrackDLLsExample.dpr
  $(DCC) -gd -dHOOK_DLL_EXCEPTIONS
  $(MAKEJCLDBG) $(MAP)
  del $(MAP)
  del $(DRC)

StackTrackDLLsStaticLibrary.dll: StackTrackDLLsStaticLibrary.dpr
  $(DCC) -gd -dHOOK_DLL_EXCEPTIONS
  $(MAKEJCLDBG) $(MAP)
  del $(MAP)
  del $(DRC)

StackTrackDLLsDynamicLibrary.dll: StackTrackDLLsDynamicLibrary.dpr
  $(DCC) -gd -dHOOK_DLL_EXCEPTIONS
  $(MAKEJCLDBG) $(MAP)
  del $(MAP)
  del $(DRC)

StackTrackDLLsComLibrary.dll: StackTrackDLLsComLibrary.dpr
  $(DCC) -gd -dHOOK_DLL_EXCEPTIONS
  $(MAKEJCLDBG) $(MAP)
  del $(MAP)
  del $(DRC)

