;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;@                                                                            @
;@                 S t a r F i e l d   S c r e e n s a v e r                  @
;@                                                                            @
;@             (c) 2004-2023 by Prodatron / SymbiosiS (Jörn Mika)             @
;@                                                                            @
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

relocate_start

;==============================================================================
;### CODE-TEIL ################################################################
;==============================================================================

;### PROGRAMM-KOPF ############################################################

prgdatcod       equ 0           ;Länge Code-Teil (Pos+Len beliebig; inklusive Kopf!)
prgdatdat       equ 2           ;Länge Daten-Teil (innerhalb 16K Block)
prgdattra       equ 4           ;Länge Transfer-Teil (ab #C000)
prgdatorg       equ 6           ;Original-Origin
prgdatrel       equ 8           ;Anzahl Einträge Relocator-Tabelle
prgdatstk       equ 10          ;Länge Stack (Transfer-Teil beginnt immer mit Stack)
prgdatrs1       equ 12          ;*reserved* (3 bytes)
prgdatnam       equ 15          ;program name (24+1[0] chars)
prgdatflg       equ 40          ;flags (+1=16colour icon available)
prgdat16i       equ 41          ;file offset of 16colour icon
prgdatrs2       equ 43          ;*reserved* (5 bytes)
prgdatidn       equ 48          ;"SymExe10"
prgdatcex       equ 56          ;zusätzlicher Speicher für Code-Bereich
prgdatdex       equ 58          ;zusätzlicher Speicher für Data-Bereich
prgdattex       equ 60          ;zusätzlicher Speicher für Transfer-Bereich
prgdatres       equ 62          ;*reserviert* (28 bytes)
prgdatism       equ 90          ;Icon (klein)
prgdatibg       equ 109         ;Icon (gross)
prgdatlen       equ 256         ;Datensatzlänge

prgpstdat       equ 6           ;Adresse Daten-Teil
prgpsttra       equ 8           ;Adresse Transfer-Teil
prgpstspz       equ 10          ;zusätzliche Prozessnummern (4*1)
prgpstbnk       equ 14          ;Bank (1-8)
prgpstmem       equ 48          ;zusätzliche Memory-Bereiche (8*5)
prgpstnum       equ 88          ;Programm-Nummer
prgpstprz       equ 89          ;Prozess-Nummer

prgcodbeg   dw prgdatbeg-prgcodbeg  ;Länge Code-Teil
            dw prgtrnbeg-prgdatbeg  ;Länge Daten-Teil
            dw prgtrnend-prgtrnbeg  ;Länge Transfer-Teil
prgdatadr   dw #1000                ;Original-Origin                    POST Adresse Daten-Teil
prgtrnadr   dw relocate_count       ;Anzahl Einträge Relocator-Tabelle  POST Adresse Transfer-Teil
prgprztab   dw prgstk-prgtrnbeg     ;Länge Stack                        POST Tabelle Prozesse
            dw 0                    ;*reserved*
prgbnknum   db 0                    ;*reserved*                         POST Bank-Nummer
            db "Starfield Screensaver":ds 3:db 0  ;Name
            db 0                    ;flags (+1=16c icon)
            dw 0                    ;16 colour icon offset
            ds 5                    ;*reserved*
prgmemtab   db "SymExe10"           ;SymbOS-EXE-Kennung                 POST Tabelle Speicherbereiche
            dw 0                    ;zusätzlicher Code-Speicher
            dw 0                    ;zusätzlicher Data-Speicher
            dw 0                    ;zusätzlicher Transfer-Speicher
            ds 26                   ;*reserviert*
            db 0,1                  ;required OS version (1.0)
prgicnsml   db 2,8,8,#F0,#F0,#E1,#D0,#B0,#F4,#F2,#F0,#F0,#B4,#F0,#F0,#B4,#F8,#F0,#70
prgicnbig   db 6,24,24,#F0,#F0,#F0,#F0,#F0,#F0,#B0,#F0,#F0,#F0,#F0,#F0,#F2,#F0,#F0,#D0,#F0,#F0,#F0,#F0,#F0,#F2,#F0,#F0,#F0,#D0,#F0,#F0,#B4,#F0,#F0,#F1,#F0,#F0,#F0,#B0,#F0,#F0,#F0,#F0,#F0,#F8,#E0,#F0,#E1,#F2,#F0,#F0,#F0,#F8,#F1,#F0
            db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#71,#78,#F0,#F0,#74,#F1,#F0,#F0,#B2,#F0,#F0,#F0,#F0,#F0,#F0,#F2,#F0,#F0,#F0,#E2,#F0,#B4,#F2,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F8,#F4,#F0,#F0,#F0,#F4,#70
            db #D2,#F0,#F0,#F8,#B4,#F0,#F0,#F0,#E0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F1,#F0,#F0,#F0,#F0,#F8,#F0,#70,#F0,#F0,#F0,#70,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0


;### SCREEN-SAVER BILD ########################################################
db 16,64,40
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#70,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#D0,#F0,#F0,#F0,#F0,#F1,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#70,#F0,#F0,#F1,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F4,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#D0,#F0
db #B2,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#B4,#F0,#F0,#F0,#F0,#F0,#F4,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F4,#F0,#E1,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#E1,#F0,#F0,#F0,#F0,#F0,#F0,#F2,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F8,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#F1,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#70,#F0,#F0,#F8,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#F4,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#D1,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#E3,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F8,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F1,#F0,#F0,#F0,#F0,#F8,#F0,#F0,#F0,#F1,#70
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#B4,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#7C,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F8,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#F2,#F0,#F0,#F8,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F1,#F0,#F0,#B4,#F0,#F0,#B4,#F0,#F0,#F0,#F0,#F0,#F4
db #F0,#F0,#F0,#D0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#D0
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F4,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#D0,#F0,#F0,#F0
db #F0,#F8,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #E0,#F0,#F0,#F0,#F0,#F0,#F0,#F2,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F0,#F0,#F0,#D0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#F2,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0
db #F0,#F0,#F0,#F0,#D0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0,#F0

;### PRGPRZ -> Programm-Prozess
dskprzn     db 2
sysprzn     db 3
windatprz   equ 3   ;Prozeßnummer
windatsup   equ 51  ;Nummer des Superfensters+1 oder 0
prgwin      db 0    ;Nummer des Haupt-Fensters
cfgwin      db 0    ;Nummer des Config-Fensters

cfgdat  db "3DSF"   ;ID
cfganz  db 32       ;Anzahl Sterne (nur 16, 32 oder 64 möglich)
cfgspd  db 2        ;Sternen-Speed (1-8)
cfgcol  db 2        ;0=Rot, 1=Grün, 2=Blau
cfglok  db 0        ;1=System sperren
cfgtmp  ds 64


prgprz  ld a,(prgprzn)
        ld (prgwindat+windatprz),a
        ld (configwin+windatprz),a
        call sysptc
        call adrgen

        ld b,10                 ;Maximal 10 Zyklen auf Init-Message warten
prgprz1 push bc
        rst #30
        ld a,(prgprzn)
        db #dd:ld l,a
        db #dd:ld h,-1
        ld iy,prgmsgb
        rst #18
        db #dd:dec l
        pop bc
        jr z,prgprz2
        djnz prgprz1
        call prgani             ;Animation starten und anschließend beenden
        jp prgend

prgprz0 ld a,(prgprzn)
        db #dd:ld l,a
        db #dd:ld h,-1
        ld iy,prgmsgb
        rst #08                 ;Schlafen und auf Kommando warten
        db #dd:dec l
        jr nz,prgprz0
prgprz2 ld iy,prgmsgb
        ld a,(iy+0)
        cp 1
        jp c,prgend     ;0=Ende
        jr z,prgini     ;1=Init (p1=bank, p2/3=adr)
        cp 3
        jr z,prgcfg     ;3=Config
        jr nc,prgprz3
        call prgani     ;2=Animation starten
        jr prgprz0
prgprz3 cp MSR_DSK_WCLICK       ;*** Fenster-Aktion wurde geklickt
        jr nz,prgprz0
        ld a,(iy+2)
        cp DSK_ACT_CLOSE        ;*** Close wurde geklickt
        jp z,cfgcnc
        cp DSK_ACT_CONTENT      ;*** Inhalt wurde geklickt
        jr nz,prgprz0
        ld l,(iy+8)
        ld h,(iy+9)
        ld a,h
        or l
        jr z,prgprz0
        jp (hl)

;### PRGINI -> Config-Parameter holen
prgini  ld a,(prgbnknum)
        add a:add a:add a:add a
        or (iy+1)
        ld l,(iy+2)
        ld h,(iy+3)
        ld de,cfgtmp
        ld bc,64
        rst #20:dw jmp_bnkcop
        ld a,(cfgtmp+0):cp "3":jr nz,prgini0
        ld a,(cfgtmp+1):cp "D":jr nz,prgini0
        ld a,(cfgtmp+2):cp "S":jr nz,prgini0
        ld a,(cfgtmp+3):cp "F":jr nz,prgini0
        ld hl,(cfgtmp+4)
        ld (cfganz),hl
        ld (cfganzt),hl
        ld hl,(cfgtmp+6)
        ld (cfgcol),hl
        ld (cfgcolt),hl
prgini0 jp prgprz0

;### PRGCFG -> Config einstellen
prgcfg  db #dd:ld a,h
        ld (cfgprz),a
        call cfgopn
        jp prgprz0

;### PRGANI -> Animation durchführen
mospos  ds 4
prgani  ld c,MSC_DSK_WINOPN
        ld a,(prgbnknum)
        ld b,a
        ld de,prgwindat
        call msgsnd             ;Fenster aufbauen
prgani1 rst #30
        call msgget             ;Message holen -> IXL=Status, IXH=Absender-Prozeß
        jr nc,prgani1
        cp MSR_DSK_WOPNER
        ret z                   ;kein Speicher für Fenster -> Animation abbrechen
        cp MSR_DSK_WOPNOK
        jr nz,prgani1           ;andere Message als "Fenster geöffnet" -> ignorieren
        ld a,(prgmsgb+4)
        ld (prgwin),a           ;Fenster wurde geöffnet -> Nummer merken
        call staini             ;*** Animations-Init
        call fulakt
        jr c,prgani3
        rst #30
        rst #30
        rst #30
        rst #20:dw jmp_mosget
        ld (mospos+0),de
        ld (mospos+2),hl
prgani0 call msgget
        jr c,prgani2
        call staani             ;*** Animation, wenn keine Message vorliegt
        rst #20:dw jmp_mosget   ;DE=XPos, HL=YPos
        ld bc,(mospos+2)        ;test, ob Maus bewegt wurde
        or a
        sbc hl,bc
        jr nz,prgani4
        ld hl,(mospos+0)
        ex de,hl
        sbc hl,de
        jr z,prgani0
        jr prgani4
prgani2 cp MSR_DSK_WCLICK       ;*** Fenster-Aktion wurde geklickt
        jr nz,prgani0
        ld a,(iy+2)
        cp DSK_ACT_KEY
        jr nz,prgani0
prgani4 call prgani3            ;*** Taste wurde gedrückt -> Animation beenden
        jp fuloff
prgani3 ld a,(prgwin)           ;Fenster schließen
        ld b,a
        ld c,MSC_DSK_WINCLS
        jp msgsnd

;### PRGEND -> Programm beenden
prgend  ld a,(prgprzn)
        db #dd:ld l,a
        ld a,(sysprzn)
        db #dd:ld h,a
        ld iy,prgmsgb
        ld (iy+0),MSC_SYS_PRGEND
        ld a,(prgcodbeg+prgpstnum)
        ld (iy+1),a
        rst #10
prgend0 rst #30
        jr prgend0


;==============================================================================
;### CONFIG-ROUTINEN ##########################################################
;==============================================================================

cfgprz  db 0

;### CFGOPN -> Öffnet Config-Window
cfgopn  ld a,(cfgwin)
        or a
        ret nz                  ;Fenster bereits offen
        ld c,MSC_DSK_WINOPN
        ld a,(prgbnknum)
        ld b,a
        ld de,configwin
        call msgsnd             ;Fenster aufbauen
cfgopn1 rst #30
        call msgget             ;Message holen -> IXL=Status, IXH=Absender-Prozeß
        jr nc,cfgopn1
        cp MSR_DSK_WOPNER
        ret z                   ;kein Speicher für Fenster -> Animation abbrechen
        cp MSR_DSK_WOPNOK
        jr nz,cfgopn1           ;andere Message als "Fenster geöffnet" -> ignorieren
        ld a,(prgmsgb+4)
        ld (cfgwin),a           ;Fenster wurde geöffnet -> Nummer merken
        ret

;### CFGCLO -> Schließt Config-Window
cfgclo  ld a,(cfgwin)
        or a
        ret z                   ;Fenster nicht offen
        ld c,MSC_DSK_WINCLS
        ld b,a
        xor a
        ld (cfgwin),a
        jp msgsnd               ;Fenster schließen

;### CFGOKY -> User hat OK geclickt
cfgoky  call cfgclo
        ld hl,(cfganzt):ld (cfganz),hl
        ld hl,(cfgcolt):ld (cfgcol),hl
        ld a,(prgbnknum)
        ld b,a
        ld a,(cfgprz)
        or a
        jp z,prgprz0
        ld c,MSR_SAV_CONFIG
        ld de,cfgdat
        call msgsnd1
        jp prgprz0

;### CFGCNC -> User hat Cancel geclickt
cfgcnc  call cfgclo
        ld hl,(cfganz):ld (cfganzt),hl
        ld hl,(cfgcol):ld (cfgcolt),hl
        jp prgprz0


;==============================================================================
;### STARFIELD-ROUTINEN #######################################################
;==============================================================================

;### STAINI -> Initialisiert Stern-Speicher
;### Verändert  F,BC,DE,IX
staini  ld ix,stamem            ;Stern-Daten vorbereiten
        ld de,stalen
        ld a,(cfganz)
        ld (stadrwa+2),a
        ld b,a
        cp 32
        ld a,64
        ld c,4
        jr c,staini1
        ld c,2
        jr z,staini1
        dec c
staini1 ld (ix+staxps),0
        ld (ix+stayps),0
        ld (ix+stazps),a
        ld (ix+staadr+0),#ff
        ld (ix+staadr+1),#ff
        add c
        add ix,de
        djnz staini1
        ld a,(prgbnknum)        ;Datenstruktur für 16K-Routine vorbereiten
        ld (stadat),a
        ld hl,stadrwa
        ld (stadat+1),hl
        ret

;### STAANI -> Führt eine Animations-Phase durch
staani  ld ix,stamem
        ld a,(cfganz)
        ld b,a
staani1 push bc
        push ix
        ld a,(cfgspd)
        neg
        add (ix+stazps)
        cp 64
        jr nc,staani2
        call stanew             ;E=XPos (-128 bis +127), D=YPos (-128 bis +127)
        ld (ix+staxps),e
        ld (ix+stayps),d
        ex de,hl
        ld a,127
        jr staani3
staani2 ld l,(ix+staxps)
        ld h,(ix+stayps)
staani3 ld (ix+stazps),a
        ld c,a
        call staclc             ;Stern berechnen
        call staplt
        pop ix
        ld (ix+stapos+0),l
        ld (ix+stapos+1),h
        ld (ix+stamsk),e
        ld (ix+stapen),d
        ld bc,stalen
        add ix,bc
        pop bc
        djnz staani1
staani4 jp staani5
staani5 ld ix,stadat            ;Sterne plotten
        ld hl,jmp_bnk16c
        rst #28
        ei
        ret

;### STANEW -> Generiert Position für neuen Stern
;### Ausgabe    E=XPos (-128 bis +127), D=YPos (-128 bis +127)
;### Verändert  AF,BC,HL
rndtab              ;enthält 128 Random-Werte
db 180,136,148,74,77,198,3,194,208,181,11,105,220,202,95,246,223,14,243,93,134,196,13,151,119,76,159,165,67,71,212,211,150,252,233
db 58,177,250,62,136,27,255,173,4,147,25,26,204,72,11,75,97,77,242,250,102,71,41,41,165,104,105,182,83,162,53,47,149,20,117,231,66
db 201,96,74,235,161,160,109,25,143,177,233,213,5,139,234,110,173,128,131,118,90,103,69,14,62,250,15,99,93,125,39,121,65,160,138,40
db 240,167,129,99,27,200,117,192,152,213,4,53,18,26,84,32,0,137,168,139

stanew  ld a,r
        and 127
        ld c,a
        ld b,0
        ld hl,rndtab
        add hl,bc
        call stanew1
        ld e,a
        inc c
        ld hl,rndtab
        add hl,bc
        call stanew1
        ld d,a
        ret
stanew1 ld a,(hl)
        cp 224
        jr c,stanew2
        sub 224
        ld d,a
        add a
        add a
        add a
        add d
stanew2 add 16
        ret

;### STACLC -> Berechnet 2D-Position von Stern
;### Eingabe    L=XPos (-128 bis +127), H=YPos (-128 bis +127), C=ZPos (127 bis 64)
;### Ausgabe    L=XPos (-128 bis +127), H=YPos (-128 bis +127), C=Farbe (0-7)
;### Verändert  AF,B,DE
staclcs db 0
staclct db 255,251,247,243,239,236,233,229,226,223,220,217,214,211,209,206,203,201,198,196,194,191,189,187,185,183,181,179,177,175,173,171
        db 169,167,166,164,162,161,159,158,156,155,153,152,150,149,147,146,145,143,142,141,140,139,137,136,135,134,133,132,131,130,129,128

staclc  ld a,h
        call staclc1        ;Y umrechnen
        push af
        ld a,l
        call staclc1        ;X umrechnen
        pop hl
        ld l,a
        ld a,127            ;Farbe aus Z berechnen
        sub c
        srl a
        srl a
        srl a
        ld c,a              ;Farbe = (127-z)/8
        ret
staclc1 push hl
        push bc
        bit 7,a
        jr z,staclc2
        ld (staclcs),a
        neg                 ;Koordinate immer Positiv
staclc2 ld e,a              ;DE=Koordinate
        ld d,0
        ld b,d
        ld hl,staclct-64
        add hl,bc
        ld a,(hl)           ;A=64*256/(Z+1)
        call clcm16
        ld a,h
        ld hl,staclcs
        inc (hl):dec (hl)
        jr z,staclc3
        ld (hl),0
        neg                 ;Vorzeichen zurückholen
staclc3 pop bc
        pop hl
        ret

;### STAPLT -> Berechnet Plot-Daten für Stern
;### Eingabe    L=XPos (-128 bis +127), H=YPos (-128 bis +127), C=Farbe (0-7)
;### Ausgabe    HL=Adresse, E=Lösch-Maske, D=Pen
;### Verändert  AF,BC,D,IX
stapltc db #c0,#0c,#cc,#30,#f0,#3c,#fc,#fc  ;1,2,3,4,5,6,7,7
stapltm db #22,#33,#44,#55,#66,#77,#88,#99  ;1,2,3,4,5,6,7,8
stapltp db #22,#22,#66,#66,#ee,#ee,#ff,#ff
stapltn db #dd,#dd,#99,#99,#11,#11,#00,#00


staplt  jp staplt0

staplti ld ixl,c        ;*** nc
        ld ixh,0
        ld bc,stapltn
        add ix,bc
        ld a,l
        sra a           ;a=-64 bis +63
        add 60
        cp 120
        jr nc,staplt2
        ld e,a          ;e=x (0-119)
        ld a,h
        sra a           ;a=-64 bis +63
        add 64          ;a=y (0-127)
        ld l,1          ;a15=1
        scf             ;a14=1
        rra:rr l
        rra:rr l        ;*256/4 -> *64
        ld h,a          ;hl=scradr y
        xor a
        ld d,a
        srl e
        rla             ;a=0/1 pixelversatz
        add hl,de       ;hl=scradr x/y
        or a
        ld de,#0ff0
        jr z,stapltj
        ld de,#f00f
stapltj ld a,(ix+0)
        or d
        ld d,a
        ret

stapltk ld a,128        ;*** nxt
        add l
        ld l,a
        ld a,128
        add h
        ld h,a
        ld d,c
        inc d
        ret

staplth db #dd:ld l,c   ;*** g9k
        db #dd:ld h,0
        ld bc,stapltm
        add ix,bc
        ld d,(ix+0)
        ld a,l
        add 128
        ld l,a          ;L=X (0-255)
        ld a,h
        add 106
        cp 212
        jr nc,staplt2
        ld h,a          ;H=Y (0-211)
        ret

staplt0 db #dd:ld l,c   ;*** cpc/msx/pcw/ep
        db #dd:ld h,0
stapltz ld bc,stapltc
        add ix,bc
        ld a,l
staplta add 80
stapltb cp 160
        jr nc,staplt2
        ld e,a          ;E=X (0-159)
        ld a,h
staplte add 100
stapltf cp 200
        jr nc,staplt2
        ld l,a          ;L=Y (0-199)
stapltg call getadr     ;HL=Adresse, A=Pixeloffset, ZF=Pixel (1=links, 0=rechts)
stapltx ld e,#aa
        jr nz,staplt1
staplty ld e,#55
staplt1 ld a,e
        rrca
        and (ix+0)
        ld d,a
        ret
staplt2 ld hl,#ffff
        ret
staplt3 pop bc
        call getadrc
        ld de,#f00f
        jr z,staplt4
        ld de,#0ff0
staplt4 ld a,(ix+0)
        and d
        ld d,a
        ret

;### ADRGEN -> generates precalculated screenline addresses
adrgen  ld hl,#c000     ;3
        ld de,getadr1   ;3
        ld a,200        ;2
adrgen0 jp adrcpc0      ;3 11

adrcpc0 ex de,hl        ;1
        ld (hl),e       ;1
        inc hl          ;1
        ld (hl),d       ;1
        inc hl          ;1
        ex de,hl        ;1
        ld bc,#800      ;3
        add hl,bc       ;1
        jr nc,adrcpc1   ;2
        ld bc,#c050     ;3
        add hl,bc       ;1
adrcpc1 dec a           ;1
        jr nz,adrcpc0   ;2
adrcpc2 ret             ;1 20

adrepr0 ld bc,80        ;3
adrepr1 ex de,hl        ;1
        ld (hl),e       ;1
        inc hl          ;1
        ld (hl),d       ;1
        inc hl          ;1
        ex de,hl        ;1
        add hl,bc       ;1
        dec a           ;1
        jr nz,adrepr1   ;2
        ret             ;1 14 -> 45 bytes

getadr1                         ;Zeilenstart-Adressen (PCW) [176 lines]
dw #C220,#C221,#C222,#C223,#C224,#C225,#C226,#C227,#C4F0,#C4F1,#C4F2,#C4F3,#C4F4,#C4F5,#C4F6,#C4F7,#C7C0,#C7C1,#C7C2,#C7C3,#C7C4,#C7C5,#C7C6,#C7C7,#CA90
dw #CA91,#CA92,#CA93,#CA94,#CA95,#CA96,#CA97,#CD60,#CD61,#CD62,#CD63,#CD64,#CD65,#CD66,#CD67,#D030,#D031,#D032,#D033,#D034,#D035,#D036,#D037,#D300,#D301
dw #D302,#D303,#D304,#D305,#D306,#D307,#D5D0,#D5D1,#D5D2,#D5D3,#D5D4,#D5D5,#D5D6,#D5D7,#D8A0,#D8A1,#D8A2,#D8A3,#D8A4,#D8A5,#D8A6,#D8A7,#DB70,#DB71,#DB72
dw #DB73,#DB74,#DB75,#DB76,#DB77,#DE40,#DE41,#DE42,#DE43,#DE44,#DE45,#DE46,#DE47,#E110,#E111,#E112,#E113,#E114,#E115,#E116,#E117,#E3E0,#E3E1,#E3E2,#E3E3
dw #E3E4,#E3E5,#E3E6,#E3E7,#E6B0,#E6B1,#E6B2,#E6B3,#E6B4,#E6B5,#E6B6,#E6B7,#E980,#E981,#E982,#E983,#E984,#E985,#E986,#E987,#EC50,#EC51,#EC52,#EC53,#EC54
dw #EC55,#EC56,#EC57,#EF20,#EF21,#EF22,#EF23,#EF24,#EF25,#EF26,#EF27,#F1F0,#F1F1,#F1F2,#F1F3,#F1F4,#F1F5,#F1F6,#F1F7,#F4C0,#F4C1,#F4C2,#F4C3,#F4C4,#F4C5
dw #F4C6,#F4C7,#F790,#F791,#F792,#F793,#F794,#F795,#F796,#F797,#FA60,#FA61,#FA62,#FA63,#FA64,#FA65,#FA66,#FA67,#FD30,#FD31,#FD32,#FD33,#FD34,#FD35,#FD36
dw #FD37
ds 2*24     ;missing 24 lines for cpc/ep

;### GETADR -> Berechnet Bildschirm-Adresse (CPC/EP)
;### Eingabe    E=XPos, L=YPos
;### Ausgabe    HL=Adresse, A=Pixeloffset, ZF=Pixel (1=links, 0=rechts)
;### Veraendert F,BC,DE
getadr  ld bc,getadr1
getadr9 ld h,0
        add hl,hl
        add hl,bc
        ld c,(hl)
        inc hl
        ld h,(hl)
        ld l,c
        ld a,e
        ld d,0
        srl e
        add hl,de
        and 1
        ret

;### GETADRB -> Berechnet Bildschirm-Adresse (MSX)
;### Eingabe    E=XPos, L=YPos
;### Ausgabe    HL=Adresse, A=Pixeloffset, ZF=Pixel (1=links, 0=rechts)
;### Veraendert F,BC,DE
getadrb srl l
        ld h,l
        rr e
        ld l,e
        ld a,0
        adc 0
        ret

;### GETADRC -> Berechnet Bildschirm-Adresse (PCW)
;### Eingabe    E=XPos (0-179), L=YPos (0-175)
;### Ausgabe    HL=Adresse, A=Pixeloffset, ZF=Pixel (1=links, 0=rechts)
;### Veraendert F,BC,DE
getadrc ld h,0
        add hl,hl
        ld bc,getadr1
        add hl,bc
        ld c,(hl)
        inc hl
        ld h,(hl)
        ld l,c          ;hl=lineadr
        ld a,e
        ld c,e
        and #fe
        add a
        ld e,a
        ld a,0
        adc 0
        ld d,a
        add hl,de
        add hl,de
        ld a,c
        and 1
        ret

;### CLCM16 -> Multipliziert zwei Werte (16bit)
;### Eingabe    A=Wert1, DE=Wert2
;### Ausgabe    HL=Wert1*Wert2 (16bit)
;### Veraendert AF,DE
clcm16  ld hl,0
        or a
clcm161 rra
        jr nc,clcm162
        add hl,de
clcm162 sla e
        rl d
        or a
        jr nz,clcm161
        ret

;### SYSPTC -> Patched Routinen für MSX/G9K/PCW/EP/NC/SVM/ZNX-Betrieb
;g9k
sysptcg dw staplt,staplth
        dw fulclr,fulclr5,      staani4,stadrwc,     fulakt0,fulakt6
        dw fulaktx+1,fulcolr-2, fulakty+1,fulcolg-2, fulaktz+1,fulcolb-2
        dw 0
;msx
sysptcm dw staplta,#ff00+128,   stapltb,#ff00+255,   staplte,#ff00+106,   stapltf,#ff00+212
        dw stapltg,getadrb
        dw stapltx,#ff00+#1e,   staplty,#ff00+#e1
        dw stapltz,stapltm
        dw fulclr,fulclr2,      staani4,stadrwb,     fulakt0,fulakt4
        dw fulaktx+1,fulcolr-2, fulakty+1,fulcolg-2, fulaktz+1,fulcolb-2
        dw 0
;pcw
sysptcp dw staplta,#ff00+90,    stapltb,#ff00+180,   staplte,#ff00+88,    stapltf,#ff00+176
        dw stapltg,staplt3
        dw stapltz,stapltp
        dw fulclr,fulclr4,      fulakt0,fulakt5,     staplt2,#c000,       adrgen0,adrcpc2
        dw 0
;ep
sysptce dw fulclr,fulclr6,      fulakt0,fulakt7,     fulakt2,fulakt9,     adrgen0,adrepr0
        dw 0

;nc
sysptcn dw staplt,staplti,      fulclr,fulclr8,      fulakt0,fulaktc
        dw stadrw6-1,#ff00+#b6, stadrw7-1,#ff00+#b6, stadrw8-1,#ff00+#a2
        dw 0

;znx
sysptcx dw staplt,stapltk,      staani4,stadrwd,     fulclr,fulclr9,      fulakt0,fulaktd
        dw 0

;svm
sysptcs dw staplt,stapltk,      staani4,stadrwe,     fulclr,fulclrb,      fulakt0,fulakte
        dw 0


sysptc  ld hl,jmp_sysinf        ;Computer-Typ holen
        ld de,256*6+5
        ld ix,cfgsf2flg
        ld iy,66+2+6+8-5
        rst #28
        ld bc,4
        ld a,(cfgcpctyp)
        and #1f
        cp 6
        jr nc,sysptc0
        ld a,(cfgsf2flg)        ;cpc
        bit 3,a
        ret z
        ld a,#c3                ;+g9k
        ld (g9kcmd),a
        ld ix,sysptcg
        jr sysptc1
sysptc0 ld ix,sysptce
        jr z,sysptc2            ;ep
        cp 18
        ld ix,sysptcs
        jr z,sysptc1            ;svm
        cp 20
        ld ix,sysptcx
        jr z,sysptc1            ;nxt
        cp 15
        ld ix,sysptcn
        jr nc,sysptc1           ;nc
        cp 12
        ld ix,sysptcp
        jr nc,sysptc1           ;pcw
        ld ix,sysptcm           ;msx
sysptc2 ld a,(cfgsf2flg)
        bit 3,a
        jr z,sysptc1
        ld ix,sysptcg           ;+g9k
sysptc1 ld l,(ix+0)
        ld h,(ix+1)
        ld e,(ix+2)
        ld d,(ix+3)
        ld a,l
        or h
        ret z
        add ix,bc
        inc hl
        ld (hl),e
        inc d
        jr z,sysptc1
        dec d
        inc hl
        ld (hl),d
        jr sysptc1


;==============================================================================
;### FULLSCREEN-ROUTINEN ######################################################
;==============================================================================

fulbuf  ds 17*2+2
fulblk  ds 17*2

fulakta db #06,#62,#1f,#80,#01,#ec,#0f,#01,#2a

g9kregclr   dw 0        ;Ziel
            dw 0
            dw 1000     ;Größe
            dw 300
            db 0        ;direction (leave always 0!)
            db #c       ;#c=normal, #3=not, #8=and, #e=or, #6=xor, +16=transparency
            dw -1       ;write mask (leave always -1!)
            dw #0000    ;foreground colour (font or fill colour)
            dw 0        ;background colour (only for font)
            db G9K_OPCODE_LMMV

g9kregdel   dw 0        ;Ziel
            dw 0
            dw 4        ;Größe
            dw 2
            db 0        ;direction (leave always 0!)
            db #c       ;#c=normal, #3=not, #8=and, #e=or, #6=xor, +16=transparency
            dw -1       ;write mask (leave always -1!)
            dw #0000    ;foreground colour (font or fill colour)
            dw 0        ;background colour (only for font)
            db G9K_OPCODE_LMMV

g9kregplt   dw 0        ;Ziel
            dw 0
            dw 0        ;Größe
            dw 0
            db 0        ;direction (leave always 0!)
            db #c       ;#c=normal, #3=not, #8=and, #e=or, #6=xor, +16=transparency
            dw -1       ;write mask (leave always -1!)
            dw #7777    ;foreground colour (font or fill colour)
            dw 0        ;background colour (only for font)
            db G9K_OPCODE_LMMV

;### FULAKT -> Stoppt Desktop und aktiviert Fullscreen Mode
;### Ausgabe    CF=1 -> nicht möglich, da Desktop bereits eingefroren ist
fulakt  ld a,(prgwin)           ;Desktop abschalten
        ld d,a
        ld e,-1
        ld a,DSK_SRV_DSKSTP
        call dsksrv
        dec d
        scf
        ret z
        ld a,DSK_SRV_MODGET     ;Mode merken
        call dsksrv
        ld ix,fulbuf+2
        ld (fulbuf),de
        ld b,17                 ;Farben merken
fulakt1 push bc
        push ix
        ld a,17
        sub b
        ld e,a
        ld a,DSK_SRV_COLGET
        call dsksrv
        pop ix
        pop bc
        ld (ix+0),d
        ld (ix+1),l
        inc ix:inc ix
        djnz fulakt1
        ld ix,fulblk
        call fuloff1
        rst #30
        call fulclr             ;Bildschirm löschen
        ld e,0
        ld hl,jmp_scrset        ;Mode 0 setzen (nur CPC)
        rst #28
        ld a,(cfgcol)
        cp 1
fulaktx ld ix,fulcolr
        jr c,fulakt2
fulakty ld ix,fulcolg
        jr z,fulakt2
fulaktz ld ix,fulcolb
fulakt2 ld (nxtpal+1),ix
        call fuloff1            ;Farben setzen
fulakt0 jp fulakt3
fulakt3 ld b,#7f                ;Screensaver Mode setzen (CPC)
        ld a,#8c+0
        out (c),a
        or a
        ret
fulakt7 ld hl,staepm            ;Screensaver Mode setzen (EP)
fulakt8 ld (stadat+1),hl
        ld ix,stadat
        ld hl,jmp_bnk16c
        rst #28
        ei
        ld hl,stadrwa
        ld (stadat+1),hl
        ret
fulakt9 ld (staepm3+1),ix
        ret
fulakt4 ld hl,fulakta           ;Screensaver Mode setzen (MSX)
        ld bc,256*9+0
        call vdpreg
fulakt5 or a                    ;Screensaver Mode  setzen (PCW)
        ret
fulaktc ld a,#c0                ;Screensaver Mode  setzen (NC)
        out (#00),a
        or a
        ret
fulaktd call nxtspr             ;Screensaver Mode  setzen (NXT)
        call nxtpal
        or a
        ret
fulakte in a,(P_VIDPTR_L)       ;Screensaver Mode  setzen (SVM)
        out (P_BLITDSTA_L),a
        in a,(P_VIDPTR_H)
        out (P_BLITDSTA_H),a
        in a,(P_VIDPTR_U)
        out (P_BLITDSTA_U),a    ;blit dest adr=video adr
        xor a
        out (P_VIDRESX_L),a     ;512x512
        out (P_VIDRESY_L),a
        out (P_BLITDSTL_L),a
        inc a
        out (P_BLITDSTL_H),a    ;256byte line length
        inc a
        out (P_VIDRESX_H),a
        out (P_VIDRESY_H),a
        ld a,D_VIDGFX4BPP
        out (P_VIDMODE),a
        xor a                   ;clear screen
        ld bc,512
        ld l,a
        ld e,a
        call stadrwh
        ld a,-1
        out (P_MPTRX_HI),a
        out (P_MPTRY_HI),a
        or a
        ret
fulakt6 ld a,G9K_SCREEN_MODE0   ;Screensaver Mode  setzen (G9K)
        ld bc,G9K_CPC_BASE+G9K_REG_SELECT
        out (c),a
        ld a,G9K_SCR0_BITMAP + G9K_SCR0_DTCLK2 + G9K_SCR0_XIM1024 + G9K_SCR0_4BIT
        ld c,G9K_REG_DATA
        out (c),a
        xor a
        ld c,G9K_SYS_CTRL
        out (c),a
        ld a,G9K_SCROLL_LOW_X
        ld c,G9K_REG_SELECT
        out (c),a
        xor a
        ld c,G9K_REG_DATA
        out (c),a
        out (c),a

        xor a                   ;hide mousepointer
        ld c,G9K_REG_SELECT
		out (c),a
		ld c,G9K_REG_DATA
		out (c),a
		ld hl,#07FE
		out (c),l
		out (c),h
        ld c,G9K_VRAM
        ld a,16
        ld e,a
fulaktb out (c),a
        dec e
        jr nz,fulaktb
        ret

;### FULOFF -> Deaktiviert Fullscreen Mode und kehrt zum Desktop zurück
fuloff  call fulclr
        ld de,(fulbuf)          ;Mode wiederherstellen
        set 7,e
        ld a,DSK_SRV_MODSET
        call dsksrv
        ld ix,fulbuf+2
        call fuloff1
        ld a,DSK_SRV_DSKCNT     ;Desktop einschalten
        jp dsksrv
fuloff1 ld b,17                 ;Farben setzen
fuloff2 push bc
        push ix
        ld a,17
        sub b
        ld e,a
        ld a,DSK_SRV_COLSET
        ld d,(ix+0)
        ld l,(ix+1)
        call dsksrv
        pop ix
        pop bc
        inc ix:inc ix
        djnz fuloff2
        ret

;### FULCLR -> Löscht den kompletten Bildschirm
fulclr  jp fulclr1
fulclrb ret                     ;Bildschirm löschen (SVM) -> only when FULAKT
fulclr9 xor a                   ;Bildschirm löschen (NXT)
        ld bc,SPRITE_STATUS_SLOT_SELECT_P_303B
        out (c),a
        xor a
        ld bc,256*64+SPRITE_ATTRIBUTE_P_57
fulclra out (c),a
        out (c),a
        out (c),a
        out (c),a
        djnz fulclra
fulclrc ld a,DSK_SRV_DSKPNT     ;Bildschirm löschen (SVM/NXT)
        ld e,0
        jp dsksrv
fulclr8 ld hl,stacln2           ;Bildschirm löschen (NC)
        jr fulclr7
fulclr6 ld hl,stacln1           ;Bildschirm löschen (EP)
        jr fulclr7
fulclr1 ld hl,stacln            ;Bildschirm löschen (CPC)
fulclr7 ld (stadat+1),hl
        ld ix,stadat
        ld hl,jmp_bnk16c
        rst #28
        ei
        ld hl,stadrwa
        ld (stadat+1),hl
        ret
fulclr2 ld hl,#0000             ;Bildschirm löschen (MSX)
        call vdpwrt
        ld bc,#6a*2
        xor a
fulclr3 out (#98),a
        djnz fulclr3
        dec c
        jr nz,fulclr3
        ret
fulclr4 xor a                   ;Bildschirm löschen (PCW)
        ld hl,#c000
        ld b,l
        rst #20:dw jmp_bnkwbt
        ex de,hl
        ld hl,#c000
        ld bc,16384-1
        rst #20:dw jmp_bnkcop
        ld a,#10
        ld hl,#c000
        ld de,#4000
        ld bc,7200-1
        rst #20:dw jmp_bnkcop
        ret
fulclr5 ld hl,g9kregclr         ;Bildschirm löschen (G9K)
        jp g9kcmd

;### STADRWD -> Plottet alle Sterne (NXT)
;### Verändert  AF,BC,DE,HL,IX,IXL
stadrwd ld iy,(stadrwa+2)
        ld bc,SPRITE_STATUS_SLOT_SELECT_P_303B
        xor a
        out (c),a                       ;select sprite slot 1
        ld ix,stamem
        ld bc,stalen
stadrw0 ld a,(ix+stapos+0)
        ld l,a
        srl a:srl a
        add l
        out (SPRITE_ATTRIBUTE_P_57),a   ;x low
        ld a,(ix+stapos+1)
        out (SPRITE_ATTRIBUTE_P_57),a   ;y
        ld a,0
        rla
        out (SPRITE_ATTRIBUTE_P_57),a   ;x high, palofs=0, no mirror/rotation
        ld a,(ix+stapen)
        or #c0
        out (SPRITE_ATTRIBUTE_P_57),a   ;V E N5 N4 N3 N2 N1 N0 -> visible, 5bytes for attribute, pattern [bit6-1]
        ld a,#80
        out (SPRITE_ATTRIBUTE_P_57),a   ;H N6 T X X Y Y Y8 -> 4bit pattern, pattern [bit0]
        add ix,bc
        dec iyl
        jr nz,stadrw0
        halt
        ret

;### STADRWD -> Plottet alle Sterne (SVM)
;### Verändert  AF,BC,DE,HL,IX,IXL
stadrwe ld iy,(stadrwa+2)
        ld ix,stamem
stadrwf ld l,(ix+staadr+0)
        ld e,(ix+staadr+1)
        ld c,(ix+staclr)
        ld b,0
        call stadrwg
        ld l,(ix+stapos+0)
        ld e,(ix+stapos+1)
        ld (ix+staadr+0),l
        ld (ix+staadr+1),e
        ld c,(ix+stapen)
        ld (ix+staclr),c
        ld b,c
        call stadrwg
        ld bc,stalen
        add ix,bc
        dec iyl
        jr nz,stadrwf
        rst #30
        ret
stadrwg ld a,c
        srl a:adc 0
        ld c,a
        ld a,b
        ld b,0
;a=fill, bc=size, l=xpos, e=ypos
stadrwh          out (P_BLITFILL1),a
        ld h,0:add hl,hl
        ld a,l  :out (P_BLITDSTX_L),a
        ld a,h  :out (P_BLITDSTX_H),a
        ex de,hl
        ld h,0:add hl,hl
        ld a,l  :out (P_BLITDSTY_L),a
        ld a,h  :out (P_BLITDSTY_H),a
        ld a,c  :out (P_BLITSIZX_L),a
                 out (P_BLITSIZY_L),a
        ld a,b  :out (P_BLITSIZX_H),a
                 out (P_BLITSIZY_H),a
        ld a,D_BMFILL
        out (P_BLITCTRL),a
        ret

;### STADRWB -> Plottet alle Sterne (MSX)
;### Verändert  AF,BC,DE,HL,IX,IXL
stadrwb ld iy,(stadrwa+2)
        ld ix,stamem
        ld bc,stalen
stadrw3 ld l,(ix+staadr+0)
        ld h,(ix+staadr+1)
        call vdpwrt
        xor a
        out (#98),a
        ld l,(ix+stapos+0)
        ld h,(ix+stapos+1)
        ld (ix+staadr+0),l
        ld (ix+staadr+1),h
        call vdpwrt
        ld a,(ix+stapen)
        out (#98),a
        add ix,bc
        db #fd:dec l
        jr nz,stadrw3
        ret

;### STADRWC -> Plottet alle Sterne (G9K)
;### Verändert  AF,BC,DE,HL,IX,IXL
stadrwc ld iy,(stadrwa+2)
        ld ix,stamem
stadrw5 ld l,(ix+staadr+0)
        ld h,0
        add hl,hl
        ld (g9kregdel+0),hl
        ld a,(ix+staadr+1)
        ld (g9kregdel+2),a
        ld hl,g9kregdel
        call g9kcmd
        ld l,(ix+stapos+0)
        ld (ix+staadr+0),l
        ld h,0
        add hl,hl
        ld (g9kregplt+0),hl
        ld a,(ix+stapos+1)
        ld (ix+staadr+1),a
        ld (g9kregplt+2),a
        ld a,(ix+stapen)
        ld (g9kregplt+12),a
        ld (g9kregplt+13),a
        and 14  ;2,4,6,8
        rra     ;1,2,3,4
        ld (g9kregplt+4),a
        inc a   ;2,3,4,5
        rra     ;1,1,2,2
        ld (g9kregplt+6),a
        ld hl,g9kregplt
        call g9kcmd
        ld bc,stalen
        add ix,bc
        db #fd:dec l
        jr nz,stadrw5
        ret

;### VDPREG -> Setzt eine Anzahl an VDP-Registern
;### Eingabe    HL=Register-Data, C=erstes Register, B=Anzahl Register
;### Verändert  AF,BC,HL
vdpreg  ld a,c
        di
        out (#99),a
        ld  a,17+128
        ei
        out (#99),a
        ld  c,#9B
        otir
        ret

;### VDPWRT -> VDP-Adresse zum Schreiben setzen
;### Eingabe    HL=Adresse
;### Verändert  AF,HL
vdpwrt  call vdpwai
        xor a
        rlc h
        rla
        rlc h
        rla
        srl h
        srl h
        di
        out (#99),a
        ld a,14+128
        out (#99),a
        ld a,l
        nop
        out (#99),a
        ld a,h
        or 64
        ei
        out (#99),a
        ret

;### VDPWAI -> Wartet, bis VDP für Kommando bereit ist
;### Verändert  AF
vdpwai  ld  a,2
        di
        out (#99),a
        ld a,15+128
        out (#99),a
        in a,(#99)
        rra
        ld a,0
        out (#99),a
        ld a,15+128
        ei
        out (#99),a
        jr c,vdpwai
        ret

;----------------------------------------------------------------------------;
; SYMBOS VM defines and stuff                                                ;
;----------------------------------------------------------------------------;

read"..\..\..\SVN-Main\trunk\_svm\hardware.cpc"


;----------------------------------------------------------------------------;
; SPECTRUM NEXT defines and stuff                                            ;
;----------------------------------------------------------------------------;

macro   nextreg number,value
    if "value"="a"
        db #ed,#92,number
    elseif "value"="A"
        db #ed,#92,number
    else
        db #ed,#91,number,value
    endif
mend

SPRITE_STATUS_SLOT_SELECT_P_303B    equ #303B
SPRITE_ATTRIBUTE_P_57               equ #57
SPRITE_PATTERN_P_5B                 equ #5B
PALETTE_INDEX_NR_40                 equ #40     ;Chooses a ULANext palette number to configure.
PALETTE_CONTROL_NR_43               equ #43     ;Enables or disables ULANext interpretation of attribute values and toggles active palette.
PALETTE_VALUE_9BIT_NR_44            equ #44     ;Holds the additional blue color bit for RGB333 color selection.

nxtspr_bmp
db #ff,#ff, #ff,#ff, #ff,#ff, #ff,#f1
db #ff,#ff, #ff,#ff, #ff,#f1, #ff,#12
db #ff,#ff, #ff,#f1, #ff,#12, #f1,#23
db #ff,#ff, #ff,#f1, #ff,#12, #f1,#24
db #ff,#f1, #ff,#12, #f1,#23, #12,#34
db #ff,#f2, #ff,#23, #f2,#34, #23,#44
db #ff,#12, #f1,#23, #12,#34, #23,#45
db #f1,#23, #12,#34, #23,#45, #34,#55

nxtpal  ld hl,fulcolr
        nextreg PALETTE_CONTROL_NR_43,%00100001         ;select sprites first palette
        xor a
        nextreg PALETTE_INDEX_NR_40,a
        ld b,6
nxtpal1 ld e,(hl):inc hl            ;e=GGGGBBBB
        ld a,(hl):inc hl            ;a=0000RRRR
        rrca                        ;a=x0000RRR
        rl e:rla:rl e:rla:rl e:rla  ;a=00RRRGGG
        rl e                        ;e=BBBBxxxx
        rl e:rla:rl e:rla           ;a=RRRGGGBB
        nextreg PALETTE_VALUE_9BIT_NR_44,a
        ld a,e
        rlca
        and 1                       ;a=0000000B
        nextreg PALETTE_VALUE_9BIT_NR_44,a
        ld a,b
        cp 2
        jr nz,nxtpal2
        inc hl:inc hl
nxtpal2 djnz nxtpal1
        nextreg PALETTE_CONTROL_NR_43,%00010001         ;select layer 2 first palette
        ret

nxtspr  ld hl,nxtspr_bmp
        ld ixl,8
nxtspr1 ld a,9
        sub ixl
        ld bc,SPRITE_STATUS_SLOT_SELECT_P_303B
        out (c),a
        ld c,SPRITE_PATTERN_P_5B

        ld ixh,4
nxtspr2 call nxtspr4
        dec ixh
        jr nz,nxtspr2
        ld ixh,4
nxtspr3 dec hl:dec hl
        call nxtspr4
        dec hl:dec hl
        dec ixh
        jr nz,nxtspr3
        ld d,64
        call nxtspr5
        ld de,8
        add hl,de
        dec ixl
        jr nz,nxtspr1
        ret

nxtspr4 ld d,(hl)
        outi
        ld a,(hl)
        outi
        rrca:rrca:rrca:rrca
        out (c),a
        ld a,d
        rrca:rrca:rrca:rrca
        out (c),a
        ld de,#04ff
nxtspr5 out (c),e
        dec d
        jr nz,nxtspr5
        ret


;----------------------------------------------------------------------------;
; V9990 register and port defines                                            ;
;----------------------------------------------------------------------------;

; Port defines
G9K_CPC_BASE            EQU     #FF00

G9K_VRAM                EQU     #60     ; R/W
G9K_PALETTE             EQU     #61     ; R/W
G9K_CMD_DATA            EQU     #62     ; R/W
G9K_REG_DATA            EQU     #63     ; R/W
G9K_REG_SELECT          EQU     #64     ; W
G9K_STATUS              EQU     #65     ; R
G9K_INT_FLAG            EQU     #66     ; R/W
G9K_SYS_CTRL            EQU     #67     ; W
G9K_OUTPUT_CTRL         EQU     #6F     ; R/W

; Bit defines G9K_SYS_CTRL
G9K_SYS_CTRL_SRS        EQU     2       ; Power on reset state
G9K_SYS_CTRL_MCKIN      EQU     1       ; Select MCKIN terminal
G9K_SYS_CTRL_XTAL       EQU     0       ; Select XTAL

; Register defines
G9K_WRITE_ADDR          EQU     0       ; W
G9K_READ_ADDR           EQU     3       ; W
G9K_SCREEN_MODE0        EQU     6       ; R/W
G9K_SCREEN_MODE1        EQU     7       ; R/W
G9K_CTRL                EQU     8       ; R/W
G9K_INT_ENABLE          EQU     9       ; R/W
G9K_INT_V_LINE_LO       EQU     10      ; R/W   
G9K_INT_V_LINE_HI       EQU     11      ; R/W
G9K_INT_H_LINE          EQU     12      ; R/W   
G9K_PALETTE_CTRL        EQU     13      ; W
G9K_PALETTE_PTR         EQU     14      ; W
G9K_BACK_DROP_COLOR     EQU     15      ; R/W
G9K_DISPLAY_ADJUST      EQU     16      ; R/W
G9K_SCROLL_LOW_Y        EQU     17      ; R/W
G9K_SCROLL_HIGH_Y       EQU     18      ; R/W
G9K_SCROLL_LOW_X        EQU     19      ; R/W
G9K_SCROLL_HIGH_X       EQU     20      ; R/W
G9K_SCROLL_LOW_Y_B      EQU     21      ; R/W
G9K_SCROLL_HIGH_Y_B     EQU     22      ; R/W
G9K_SCROLL_LOW_X_B      EQU     23      ; R/W
G9K_SCROLL_HIGH_X_B     EQU     24      ; R/W
G9K_PAT_GEN_TABLE       EQU     25      ; R/W
G9K_LCD_CTRL            EQU     26      ; R/W
G9K_PRIORITY_CTRL       EQU     27      ; R/W
G9K_SPR_PAL_CTRL        EQU     28      ; W
G9K_SC_X                EQU     32      ; W
G9K_SC_Y                EQU     34      ; W
G9K_DS_X                EQU     36      ; W
G9K_DS_Y                EQU     38      ; W
G9K_NX                  EQU     40      ; W
G9K_NY                  EQU     42      ; W
G9K_ARG                 EQU     44      ; W
G9K_LOP                 EQU     45      ; W
G9K_WRITE_MASK          EQU     46      ; W
G9K_FC                  EQU     48      ; W
G9K_BC                  EQU     50      ; W
G9K_OPCODE              EQU     52      ; W

; Register Select options
G9K_DIS_INC_READ        EQU     64
G9K_DIS_INC_WRITE       EQU     128

; Bit defines G9K_SCREEN_MODE0 (register 6)
G9K_SCR0_STANDBY        EQU     192     ; Stand by mode
G9K_SCR0_BITMAP         EQU     128     ; Select Bit map mode
G9K_SCR0_P2             EQU     64      ; Select P1 mode
G9K_SCR0_P1             EQU     0       ; Select P1 mode
G9K_SCR0_DTCLK          EQU     32      ; Master Dot clock not divided
G9K_SCR0_DTCLK2         EQU     16      ; Master Dot clock divided by 2
G9K_SCR0_DTCLK4         EQU     0       ; Master Dot clock divided by 4
G9K_SCR0_XIM2048        EQU     12      ; Image size = 2048
G9K_SCR0_XIM1024        EQU     8       ; Image size = 1024
G9K_SCR0_XIM512         EQU     4       ; Image size = 512
G9K_SCR0_XIM256         EQU     0       ; Image size = 256
G9K_SCR0_16BIT          EQU     3       ; 16 bits/dot
G9K_SCR0_8BIT           EQU     2       ; 8 bits/dot
G9K_SCR0_4BIT           EQU     1       ; 4 bits/dot
G9K_SCR0_2BIT           EQU     0       ; 2 bits/dot

; Bit defines G9K_SCREEN_MODE1 (register 7)
G9K_SCR1_C25M           EQU     64      ; Select 640*480 mode
G9K_SCR1_SM1            EQU     32      ; Selection of 263 lines during non interlace , else 262
G9K_SCR1_SM             EQU     16      ; Selection of horizontal frequency 1H=fsc/227.5
G9K_SCR1_PAL            EQU     8       ; Select PAL, else NTSC
G9K_SCR1_EO             EQU     4       ; Select of vertical resolution of twice the non-interlace resolution
G9K_SCR1_IL             EQU     2       ; Select Interlace
G9K_SCR1_HSCN           EQU     1       ; Select High scan mode

; Bit defines G9K_CTRL    (Register 8)
G9K_CTRL_DISP           EQU     128     ; Display VRAM
G9K_CTRL_DIS_SPD        EQU     64      ; Disable display sprite (cursor)
G9K_CTRL_YSE            EQU     32      ; /YS Enable
G9K_CTRL_VWTE           EQU     16      ; VRAM Serial data bus control during digitization
G9K_CTRL_VWM            EQU     8       ; VRAM write control during digitization
G9K_CTRL_DMAE           EQU     4       ; Enable DMAQ output
G9K_CTRL_VRAM512        EQU     2       ; VRAM=512KB
G9K_CTRL_VRAM256        EQU     1       ; VRAM=256KB
G9K_CTRL_VRAM128        EQU     0       ; VRAM=128KB

; Bit defines G9K_INT_ENABLE (register 9)
G9K_INT_IECE            EQU     4       ; Command end interrupt enable control
G9K_INT_IEH             EQU     2       ; Display position interrupt enable
G9K_INT_IEV             EQU     1       ; Int. enable during vertical retrace line interval

; Bit Defines G9K_PALETTE_CTRL  (Register 13)
G9K_PAL_CTRL_YUV        EQU     192     ; YUV mode
G9K_PAL_CTRL_YJK        EQU     128     ; YJK mode
G9K_PAL_CTRL_256        EQU     64      ; 256 color mode
G9K_PAL_CTRL_PAL        EQU     0       ; Pallete mode
G9K_PAL_CTRL_YAE        EQU     32      ; Enable YUV/YJK RGB mixing mode

; Bit defines G9K_LOP           (Register 45)
G9K_LOP_TP              EQU     16
G9K_LOP_WCSC            EQU     12
G9K_LOP_WCNOTSC         EQU     3
G9K_LOP_WCANDSC         EQU     8
G9K_LOP_WCORSC          EQU     14
G9K_LOP_WCEORSC         EQU     6

; Bit defines G9K_ARG
G9K_ARG_MAJ             EQU     1
G9K_ARG_NEG             EQU     2
G9K_ARG_DIX             EQU     4
G9K_ARG_DIY             EQU     8

; Blitter Commands G9K_OPCODE    (Register 52)
G9K_OPCODE_STOP         EQU     #00     ; Command being excuted is stopped 
G9K_OPCODE_LMMC         EQU     #10     ; Data is transferred from CPU to VRAM rectangle area
G9K_OPCODE_LMMV         EQU     #20     ; VRAM rectangle area is painted out
G9K_OPCODE_LMCM         EQU     #30     ; VRAM rectangle area is transferred to CPU
G9K_OPCODE_LMMM         EQU     #40     ; Rectangle area os transferred from VRAM to VRAM
G9K_OPCODE_CMMC         EQU     #50     ; CPU character data is color-developed and transferred to VRAM rectangle area
G9K_OPCODE_CMMK         EQU     #60     ; Kanji ROM data is is color-developed and transferred to VRAM rectangle area
G9K_OPCODE_CMMM         EQU     #70     ; VRAM character data is color-developed and transferred to VRAM rectangle area 
G9K_OPCODE_BMXL         EQU     #80     ; Data on VRAM linear address is transferred to VRAM rectangle area
G9K_OPCODE_BMLX         EQU     #90     ; VRAM rectangle area is transferred to VRAM linear address 
G9K_OPCODE_BMLL         EQU     #A0     ; Data on VRAM linear address is transferred to VRAM linear address 
G9K_OPCODE_LINE         EQU     #B0     ; Straight line is drawer on X-Y co-ordinates
G9K_OPCODE_SRCH         EQU     #C0     ; Border color co-ordinates on X-Y are detected
G9K_OPCODE_POINT        EQU     #D0     ; Color code on specified point on X-Y is read out
G9K_OPCODE_PSET         EQU     #E0     ; Drawing is executed at drawing point on X-Y co-ordinates
G9K_OPCODE_ADVN         EQU     #F0     ; Drawing point on X-Y co-ordinates is shifted

; Bit defines G9K_STATUS
G9K_STATUS_TR           EQU     128
G9K_STATUS_VR           EQU     64
G9K_STATUS_HR           EQU     32
G9K_STATUS_BD           EQU     16
G9K_STATUS_MSC          EQU     4
G9K_STATUS_EO           EQU     2
G9K_STATUS_CE           EQU     1

; Mode select defines for SetScreenMode
G9K_MODE_P1             EQU     0       ; Pattern mode 0 256 212
G9K_MODE_P2             EQU     1       ; Pattern mode 1 512 212
G9K_MODE_B1             EQU     2       ; Bitmap mode 1 256 212
G9K_MODE_B2             EQU     3       ; Bitmap mode 2 384 240
G9K_MODE_B3             EQU     4       ; Bitmap mode 3 512 212
G9K_MODE_B4             EQU     5       ; Bitmap mode 4 768 240
G9K_MODE_B5             EQU     6       ; Bitmap mode 5 640 400 (VGA)
G9K_MODE_B6             EQU     7       ; Bitmap mode 6 640 480 (VGA)
G9K_MODE_B7             EQU     8       ; Bitmap mode 7 1024 212 (Undocumented v9990 mode)

; Fixed VRAM addresses

G9K_CURSOR0_ATTRIB      EQU     #7FE00
G9K_CURSOR1_ATTRIB      EQU     #7FE08

G9K_CURSOR0_PAT_DATA    EQU     #7FF00
G9K_CURSOR1_PAT_DATA    EQU     #7FF80

G9K_RED                 EQU     32
G9K_GREEN               EQU     1024
G9K_BLUE                EQU     1


;### G9KCMD -> Sends 17byte command to G9K
;### Input      HL=command
g9kcmd  ld bc,g9kcmd2
        ld a,G9K_DS_X                       ;MSX/EP
        out (G9K_REG_SELECT),a
        ld bc,17*256+G9K_REG_DATA
g9kcmd1 in a,(G9K_STATUS)
        rra
        jr c,g9kcmd1
        otir
        ret

g9kcmd2 ld a,G9K_DS_X                       ;CPC
        ld bc,G9K_CPC_BASE+G9K_REG_SELECT
        out (c),a
        ld c,G9K_STATUS
g9kcmd3 in a,(c)
        rra
        jr c,g9kcmd3
        ld c,G9K_REG_DATA
        inc b:outi:inc b:outi:inc b:outi:inc b:outi
        inc b:outi:inc b:outi:inc b:outi:inc b:outi
        inc b:outi:inc b:outi:inc b:outi:inc b:outi
        inc b:outi:inc b:outi:inc b:outi:inc b:outi
        inc b:outi
        ret


;==============================================================================
;### SUB-ROUTINEN #############################################################
;==============================================================================

;### DSKSRV -> Desktop Service nutzen
;### Eingabe    A=Dienst, DE,HL = Parameter
;### Ausgabe    DE,HL = Parameter
dsksrvn db 0
dsksrv  ld c,MSC_DSK_DSKSRV
        ld (dsksrvn),a
        push af
        call SyDesktop_SendMessage
        pop af
        cp 1
        jr z,dsksrv1
        cp 3
        jr z,dsksrv1
        cp 5
        ret nz
dsksrv1 call SyDesktop_WaitMessage
        cp MSR_DSK_DSKSRV
        jr nz,dsksrv1
        ld a,(dsksrvn)
        cp (iy+1)
        jr nz,dsksrv1
        ld e,(iy+2)
        ld d,(iy+3)
        ld l,(iy+4)
        ld h,(iy+5)
        ret
SyDesktop_SendMessage
        ld iy,prgmsgb
        ld (iy+0),c
        ld (iy+1),a
        ld (iy+2),e
        ld (iy+3),d
        ld (iy+4),l
        ld (iy+5),h
        db #dd:ld h,2       ;2 is the number of the desktop manager process
        ld a,(prgprzn)
        db #dd:ld l,a
        rst #10
        ret
SyDesktop_WaitMessage
        ld iy,prgmsgb
SyDWMs1 db #dd:ld h,2       ;2 is the number of the desktop manager process
        ld a,(prgprzn)
        db #dd:ld l,a
        rst #08             ;wait for a desktop manager message
        db #dd:dec l
        jr nz,SyDWMs1
        ld a,(iy+0)
        ret

;### MSGGET -> Message für Programm abholen
;### Ausgabe    CF=0 -> keine Message vorhanden, CF=1 -> IXH=Absender, (recmsgb)=Message, A=(recmsgb+0), IY=recmsgb
;### Veraendert 
msgget  ld a,(prgprzn)
        db #dd:ld l,a           ;IXL=Rechner-Prozeß-Nummer
        db #dd:ld h,2
        ld iy,prgmsgb           ;IY=Messagebuffer
        rst #18                 ;Message holen -> IXL=Status, IXH=Absender-Prozeß
        or a
        db #dd:dec l
        ret nz
        ld iy,prgmsgb
        ld a,(iy+0)
        or a
        jp z,prgend
        scf
        ret

;### MSGSND -> Message an Desktop-Prozess senden
;### Eingabe    C=Kommando, B/E/D/L/H=Parameter1/2/3/4/5
msgsnd  ld a,(dskprzn)
msgsnd1 db #dd:ld h,a
        ld a,(prgprzn)
        db #dd:ld l,a
        ld iy,prgmsgb
        ld (iy+0),c
        ld (iy+1),b
        ld (iy+2),e
        ld (iy+3),d
        ld (iy+4),l
        ld (iy+5),h
        rst #10
        ret


;==============================================================================
;### DATEN-TEIL ###############################################################
;==============================================================================

prgdatbeg

        dw 0    ;MSX border is always colour 1
fulcolr dw #000,#800,#f00,#f80,#ff0,#ff8,#fff,#fff,#fff,#fff:ds 14
        dw 0
fulcolg dw #000,#080,#0f0,#8f0,#ff0,#ff8,#fff,#fff,#fff,#fff:ds 14
        dw 0
fulcolb dw #000,#008,#00f,#08f,#0ff,#8ff,#fff,#fff,#fff,#fff:ds 14

configtit   db "3D Starfield Screensaver Setup",0
configtxt0a db "Settings",0
configtxt0b db "About",0
configtxt0c db "3D Starfield for SymbOS (v1.7)",0
configtxt0d db "(c)2005-2023 by Prodatron/SymbiosiS",0
configtxt1  db "Number of Stars",0
configtxt1a db "16",0,"32",0,"64",0
configtxt2  db "Flight speed",0
configtxt2a db "1",0, "2",0, "4",0, "6",0
configtxt3  db "Star colour",0
configtxt3a db "Blue",0
configtxt3b db "Red",0
configtxt3c db "Green",0

prgtxtok    db "OK",0
prgtxtcnc   db "Cancel",0

staxps  equ 0
stayps  equ 1
stazps  equ 2
staclr  equ 3   ;alte Löschmaske
staadr  equ 4   ;alte Adresse
stapen  equ 6   ;Pen
stamsk  equ 7   ;neue Maske
stapos  equ 8   ;neue Adresse
stalen  equ 10
stamax  equ 64
stamem  ds stalen*stamax

scrlptadr   equ #fe80
scrlpt
db 256-200,#52,11,51    ;200 lines (display screen area)
db 256-051,#12,63, 0    ; 51 lines, size of the bottom border
db 256-004,#10, 6,63    ;  4 lines, sync on
db 256-001,#90,63,32    ;  1 line, sync switch of at half line; Nick generates IRQ here
db 256-004,#12, 6,63    ;  4 empty lines (VBLANK)
db 256-052,#13,63, 0    ; 52 lines, size of top border, reload flag set

;### STAEPM -> Mode 0 und Farben setzen (EP)
staepm  ld hl,scrlpt
        res 7,h
        set 6,h
        ld de,scrlptadr
        db #dd:ld l,6
        xor a
        ld b,a
staepm1 ld c,4
        ldir
        ld b,12
staepm2 ld (de),a
        inc de
        djnz staepm2
        db #dd:dec l
        jr nz,staepm1
        ld hl,#c000
        ld (16*0+scrlptadr+4),hl
        ld a,#e8
        out (#82),a
        ld a,#0f
        out (#83),a
        set 6,a
        out (#83),a
        set 7,a
        out (#83),a
staepm3 ld hl,0
        res 7,h
        set 6,h
        ld b,8
        ld ix,scrlptadr+8
staepm4 ld e,(hl)
        inc hl
        ld d,(hl)
        inc hl
        ld c,e
        rr d            ;d0-2   =red
        rr e:rr e       ;e0-1   =blue
        rl c:rl c:rl c  ;c0-1,cf=green
             rla        ;g0
        rr d:rla        ;r0
        rr e:rla        ;b0
        rr c:rla        ;g1
        rr d:rla        ;r1
        rr e:rla        ;b1
        rr c:rla        ;g2
        rr d:rla        ;r2
        ld (ix+0),a
        inc ix
        djnz staepm4
        ret

;### STACLN -> Löscht den Bildschirm (CPC,EP,NC)
stacln  ld bc,#3fff     ;cpc
stacln3 xor a
stacln4 ld hl,#c000
        ld de,#c001
        ld (hl),a
        ei
        ldir
        ret
stacln1 ld bc,16000-1   ;ep
        jr stacln3
stacln2 ld bc,#3fff     ;nc
        ld a,-1
        jr stacln4

;### STADRWA -> Plottet alle Sterne (CPC+PCW+EP+NC)
;### Verändert  AF,BC,DE,HL,IX,IXL
stadrwa ld iyl,0
        ld de,stamem
        ei
        res 7,d
        set 6,d
        db #dd:ld l,e
        db #dd:ld h,d
        ld bc,stalen
stadrw1 ld l,(ix+staadr+0)
        ld h,(ix+staadr+1)
        ld a,(ix+staclr)
stadrw6 and (hl)
        ld (hl),a
        ld l,(ix+stapos+0)
        ld h,(ix+stapos+1)
        ld (ix+staadr+0),l
        ld (ix+staadr+1),h
        ld a,(ix+stamsk)
        ld (ix+staclr),a
        ld d,(ix+stapen)
stadrw7 and (hl)
stadrw8 or d
        ld (hl),a
        add ix,bc
        dec iyl
        jr nz,stadrw1
        ret


;==============================================================================
;### TRANSFER-TEIL ############################################################
;==============================================================================

prgtrnbeg
;### PRGPRZS -> Stack für Programm-Prozess
        ds 128
prgstk  ds 6*2
        dw prgprz
prgprzn db 0
prgmsgb ds 14

stadat  ds 5

;### DUMMY-FENSTER ############################################################

prgwindat dw #0001,4,1000,1000,100,100,0,0,100,100,100,100,100,100,prgicnsml,prgwinobj,0,0,prgwingrp,0,0:ds 136+14
prgwingrp db 1,0:dw prgwinobj,0,0,0,0,0,0
prgwinobj dw 00,255*256+00,00,0,0,100,100,0     ;00=Hintergrund

;### CONFIG FENSTER ###########################################################

configwin   dw #1501,0,059,035,200,102,0,0,200,102,200,102,200,102,prgicnsml,configtit,0,0,configgrp,0,0:ds 136+14
configgrp   db 21,0:dw configdat,0,0,256*21+20,0,0,00
configdat
dw      00,         0,2,          0,0,1000,1000,0       ;00=Hintergrund
dw      00,255*256+ 3,configdsc0a,00, 01,200,45,0       ;01=Rahmen "Settings"
dw      00,255*256+ 1,configdsc1, 08, 11, 54, 8,0       ;02=Beschreibung "Anzahl"
dw      00,255*256+18,configrad1a,78, 11, 20, 8,0       ;03=Radio 16
dw      00,255*256+18,configrad1b,98, 11, 20, 8,0       ;04=Radio 32
dw      00,255*256+18,configrad1c,118,11, 20, 8,0       ;05=Radio 64
dw      00,255*256+ 1,configdsc2, 08, 21, 54, 8,0       ;06=Beschreibung "Speed"
dw      00,255*256+18,configrad2a,78, 21, 20, 8,0       ;07=Radio 1
dw      00,255*256+18,configrad2b,98, 21, 20, 8,0       ;08=Radio 2
dw      00,255*256+18,configrad2c,118,21, 20, 8,0       ;09=Radio 4
dw      00,255*256+18,configrad2d,138,21, 20, 8,0       ;10=Radio 6
dw      00,255*256+ 1,configdsc3, 08, 31, 54, 8,0       ;11=Beschreibung "Farbe"
dw      00,255*256+18,configrad3a,78, 31, 32, 8,0       ;12=Radio Blue
dw      00,255*256+18,configrad3b,110,31, 32, 8,0       ;13=Radio Red
dw      00,255*256+18,configrad3c,142,31, 32, 8,0       ;14=Radio Green
dw      00,255*256+ 3,configdsc0b,00, 45,200,42,0       ;15=Rahmen "Misc"
dw      00,255*256+ 8,prgicnbig  ,08, 55, 24,24,0       ;16=Grafik Screensaver
dw      00,255*256+ 1,configdsc0c,37, 57,144, 8,0       ;17=Beschreibung "About 1"
dw      00,255*256+ 1,configdsc0d,37, 67,144, 8,0       ;18=Beschreibung "About 2"
dw  cfgoky,255*256+16,prgtxtok,   99, 87, 48,12,0       ;19="Ok"    -Button
dw  cfgcnc,255*256+16,prgtxtcnc, 149, 87, 48,12,0       ;20="Cancel"-Button

configdsc0a dw configtxt0a,2+4
configdsc0b dw configtxt0b,2+4
configdsc0c dw configtxt0c,2+4
configdsc0d dw configtxt0d,2+4

configdsc1  dw configtxt1,2+4
configrad1k ds 4
configrad1a dw cfganzt,configtxt1a+0,256*16+2+4,configrad1k
configrad1b dw cfganzt,configtxt1a+3,256*32+2+4,configrad1k
configrad1c dw cfganzt,configtxt1a+6,256*64+2+4,configrad1k

configdsc2  dw configtxt2,2+4
configrad2k ds 4
configrad2a dw cfgspdt,configtxt2a+0,256*1+2+4,configrad2k
configrad2b dw cfgspdt,configtxt2a+2,256*2+2+4,configrad2k
configrad2c dw cfgspdt,configtxt2a+4,256*4+2+4,configrad2k
configrad2d dw cfgspdt,configtxt2a+6,256*6+2+4,configrad2k

configdsc3  dw configtxt3,2+4
configrad3k ds 4
configrad3a dw cfgcolt,configtxt3a,  256*2+2+4,configrad3k
configrad3b dw cfgcolt,configtxt3b,  256*0+2+4,configrad3k
configrad3c dw cfgcolt,configtxt3c,  256*1+2+4,configrad3k

cfganzt db 32       ;Anzahl Sterne (nur 16, 32 oder 64 möglich)
cfgspdt db 2        ;Sternen-Speed (1-8)
cfgcolt db 2        ;0=Rot, 1=Grün, 2=Blau
cfglokt db 0        ;1=System sperren

cfgsf2flg   db 0    ;Hardware -> Flag, ob SYMBiFACE vorhanden (+1=Maus, +2=RTC, +4=IDE, +8=GFX9000)
cfgdskvir   db 0    ;virtual desktop (0=no virtual desktop, Bit[0-3] -> X-resolution, 1=512, 2=1000, Bit[4-7] -> Y-resolution, not yet defined)
cfgicnanz   db 4    ;Desktop  -> Anzahl Icons
cfgmenanz   db 1    ;Desktop  -> Anzahl Startmenu-Programm-Einträge
cfglstanz   db 0    ;Desktop  -> Anzahl Taskleisten-Shortcuts
cfgcpctyp   db 0    ;Hardware -> CPC-Typ (0=464, 1=664, 2=6128, 3=464Plus, 4=6128Plus +16=WinCPC, +48=TurboCPC)

prgtrnend

relocate_table
relocate_end
