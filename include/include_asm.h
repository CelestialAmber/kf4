#ifndef INCLUDE_ASM_H
#define INCLUDE_ASM_H

#if !defined(SPLAT) && !defined(M2CTX) && !defined(PERMUTER)
#ifndef INCLUDE_ASM
#define INCLUDE_ASM(TYPE, FOLDER, NAME) \
    __asm__( \
        ".section .text\n" \
        "    .set noat\n" \
        "    .set noreorder\n" \
        "    .include \"asm/nonmatchings/" FOLDER "/" #NAME ".s\"\n"  \
        "    .set reorder\n" \
        "    .set at\n" \
        "    .globl    " #NAME ".NON_MATCHING\n" \
        "    " #NAME ".NON_MATCHING" " = " #NAME "\n" \
    )
#endif
#ifndef INCLUDE_RODATA
#define INCLUDE_RODATA(TYPE, FOLDER, NAME) \
    __asm__( \
        ".section .rodata\n" \
        "    .include \"asm/nonmatchings/" FOLDER "/" #NAME ".s\"\n"     \
        ".section .text" \
    )
#endif
__asm__(".include \"include/macro.inc\"\n");
#else
#ifndef INCLUDE_ASM
#define INCLUDE_ASM(FOLDER, NAME)
#endif
#ifndef INCLUDE_RODATA
#define INCLUDE_RODATA(FOLDER, NAME)
#endif
#endif

#endif