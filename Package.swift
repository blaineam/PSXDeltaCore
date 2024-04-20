// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PSXDeltaCore",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PSXDeltaCore",
            targets: ["PSXDeltaCore"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
//        .package(url: "https://github.com/rileytestut/DeltaCore.git", .branch("main"))
        .package(path: "../DeltaCore"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PSXDeltaCore",
            dependencies: ["DeltaCore", "LibMednafen", "PSXSwift", "PSXBridge"],
            exclude: [
                "Resources/Controller Skin/info.json",
                "Resources/Controller Skin/iphone_portrait.pdf",
                "Resources/Controller Skin/iphone_landscape.pdf",
                "Resources/Controller Skin/iphone_edgetoedge_portrait.pdf",
                "Resources/Controller Skin/iphone_edgetoedge_landscape.pdf",
                "Resources/Controller Skin/portrait_thumbstick.pdf",
                "Resources/Controller Skin/thumbstick_landscape.pdf"
            ],
            resources: [
                .copy("Resources/Controller Skin/Standard.deltaskin"),
                .copy("Resources/Standard.deltamapping"),
            ]
        ),
        .target(
            name: "PSXSwift",
            dependencies: ["DeltaCore"]
        ),
        .target(
            name: "PSXBridge",
            dependencies: ["DeltaCore", "LibMednafen", "PSXSwift"],
            publicHeadersPath: "",
            cSettings: [
                .headerSearchPath("../LibMednafen/"), // this fixes the <mednafen> issue
                .headerSearchPath("../LibMednafen/include"),
                .headerSearchPath("../LibMednafen/include/minilzo_external"),
                .headerSearchPath("../LibMednafen/include/minilzo_internal"),
                .headerSearchPath("../LibMednafen/include/trio_external"),
//                .headerSearchPath("../LibMednafen/mednafen"),
                .headerSearchPath("../LibMednafen/mednafen/hw_cpu"),
                .headerSearchPath("../LibMednafen/mednafen/hw_misc"),
                .headerSearchPath("../LibMednafen/mednafen/hw_sound"),
                .headerSearchPath("../LibMednafen/mednafen/hw_video"),
//                .headerSearchPath("../LibMednafen/mednafen/trio"),
                .headerSearchPath("../LibMednafen/libsndfile"),

                .define("MEDNAFEN_VERSION", to: "\"1.26.1\""),
                .define("PACKAGE", to: "\"mednafen\""),
                .define("MEDNAFEN_VERSION_NUMERIC", to: "0x00102601"),
//                .define("WANT_GB_EMU"),
//                .define("WANT_GBA_EMU"),
//                .define("WANT_LYNX_EMU"),
//                .define("WANT_NES_EMU"),
//                .define("WANT_NGP_EMU"),
//                .define("WANT_PCE_FAST_EMU"),
//                .define("WANT_PCE_EMU"),
//                .define("WANT_PCFX_EMU"),
                .define("WANT_PSX_EMU"),
//                .define("WANT_SS_EMU"),
//                .define("WANT_SNES_EMU"),
//                .define("WANT_SNES_FAUST_EMU"),
//                .define("WANT_VB_EMU"),
//                .define("WANT_WSWAN_EMU"),
                .define("HAVE_MKDIR"),
                .define("HAVE_PTHREAD_COND_TIMEDWAIT_RELATIVE_NP"),
                .define("SIZEOF_DOUBLE", to: "8"),
                .define("SIZEOF_CHAR", to: "1"),
                .define("SIZEOF_SHORT", to: "2"),
                .define("SIZEOF_INT", to: "4"),
                .define("SIZEOF_LONG", to: "8"),
                .define("SIZEOF_LONG_LONG", to: "8"),
                .define("SIZEOF_OFF_T", to: "8"),
                .define("SIZEOF_VOID_P", to: "8"),
                .define("SIZEOF_SIZE_T", to: "8"),
                .define("SIZEOF_PTRDIFF_T", to: "8"),
                .define("PSS_STYLE", to: "1"),
//                .define("WANT_FANCY_SCALERS", to: "1"),
//                .define("MPC_FIXED_POINT"),
//                .define("ARCH_ARM"),
//                .define("STDC_HEADERS"),
//                .define("__STDC_LIMIT_MACROS"),
                .define("ICONV_CONST="),
                .define("LSB_FIRST"),
                
                
//                .unsafeFlags([
//                    "-DHAVE_UNISTD_H",
//                    "-DMEDNAFEN_VERSION=\"1.26.1\"",
//                    "-DPACKAGE=\"mednafen\"",
//                    "-DMEDNAFEN_VERSION_NUMERIC=0x00102601",
//                    "-DHAVE_LROUND",
//                    "-DHAVE_STDINT_H",
//                    "-DHAVE_STDLIB_H",
//                    "-DHAVE_SYS_PARAM_H",
//                    "-DNDEBUG",
//                    "-funroll-loops",
//                    "-fPIC",
//                    "-Wall",
//                    "-Wno-sign-compare",
//                    "-Wno-unused-variable",
//                    "-Wno-unused-function",
//                    "-Wno-uninitialized",
//                    "-Wno-strict-aliasing",
//                    "-Wno-aggressive-loop-optimizations",
//                    "-fno-fast-math",
//                    "-fomit-frame-pointer",
//                    "-fsigned-char",
//                    "-DWANT_STEREO_SOUND",
//                    "-DSTDC_HEADERS",
//                    "-D__STDC_LIMIT_MACROS",
//                    "-D__LIBRETRO__",
//                    "-DINLINE=\"inline\"",
//                ]),
            ]
//            cxxSettings: [
//                .unsafeFlags(["-fmodules", "-fcxx-modules"])
//            ]
        ),
        .target(
            name: "LibMednafen",
            dependencies:["libsndfile", "libvorbis", "libvorbisenc"],
            exclude: [
                "mednafen/apple2",
                "mednafen/wswan", // the existence of main.cpp causes collisions
                "mednafen/cdplay/Makefile.am.inc",
                "mednafen/cdrom/Makefile.am.inc",
                "mednafen/cdrom/scsicd-pce-commands.inc",
                "mednafen/cdrom/scsicd_cdda_filter.inc",
                "mednafen/cheat_formats/Makefile.am.inc",
                "mednafen/compress/Makefile.am.inc",
                "mednafen/cputest/Makefile.am.inc",
                "mednafen/cputest/ppc_cpu.c",
                "mednafen/cputest/README",
                "mednafen/cputest/x86_cpu.c",
                "mednafen/demo/Makefile.am.inc",
                "mednafen/desa68",
                "mednafen/drivers",
                "mednafen/drivers_dos",
                "mednafen/drivers_libxxx",
                "mednafen/gb",
                "mednafen/gba",
                "mednafen/hash/Makefile.am.inc",
                "mednafen/hw_cpu/6502/Core6502.inc",
                "mednafen/hw_cpu/m68k/gen.cpp",
                "mednafen/hw_cpu/m68k/m68k_instr.inc",
                "mednafen/hw_cpu/Makefile.am.inc",
                "mednafen/hw_cpu/v810/v810_cpuD.cpp",
                "mednafen/hw_cpu/v810/v810_oploop.inc",
                "mednafen/hw_cpu/z80-fuse/opcodes_base.c",
                "mednafen/hw_cpu/z80-fuse/z80_cb.c",
                "mednafen/hw_cpu/z80-fuse/z80_ddfd.c",
                "mednafen/hw_cpu/z80-fuse/z80_ddfdcb.c",
                "mednafen/hw_cpu/z80-fuse/z80_ed.c",
                "mednafen/hw_misc/Makefile.am.inc",
                "mednafen/hw_sound/gb_apu/Gb_Apu.cpp",
                "mednafen/hw_sound/gb_apu/Gb_Apu_State.cpp",
                "mednafen/hw_sound/gb_apu/Gb_Oscs.cpp",
                "mednafen/hw_sound/Makefile.am.inc",
                "mednafen/hw_sound/sms_apu/Sms_Apu.cpp",
                "mednafen/hw_sound/ym2413/emu2413.cpp",
                "mednafen/hw_sound/ym2612/Ym2612_Emu.cpp",
                "mednafen/hw_sound/ym2612/ym2612_opeg.inc",
                "mednafen/hw_video/Makefile.am.inc",
                "mednafen/lynx",
                "mednafen/Makefile.am",
                "mednafen/Makefile.in",
                "mednafen/md",
                "mednafen/minilzo/Makefile.am.inc",
                "mednafen/minilzo/README.LZO",
                "mednafen/minilzo/README.MEDNAFEN",
                "mednafen/mpcdec/!VERSION",
                "mednafen/mpcdec/AUTHORS",
                "mednafen/mpcdec/ChangeLog",
                "mednafen/mpcdec/CMakeLists.txt",
                "mednafen/mpcdec/COPYING",
                "mednafen/mpcdec/Makefile.am.inc",
                "mednafen/mpcdec/mpc_reader.c",
                "mednafen/mpcdec/README",
                "mednafen/mthreading/Makefile.am.inc",
                "mednafen/mthreading/MThreading_Win32.cpp",
                "mednafen/nes",
                "mednafen/net/Makefile.am.inc",
                "mednafen/net/Net_POSIX.cpp",
                "mednafen/net/Net_WS2.cpp",
                "mednafen/ngp",
                "mednafen/pce",
                "mednafen/pce_fast",
                "mednafen/pcfx",
                "mednafen/psx/debug.cpp",
                "mednafen/psx/gpu_common.inc",
                "mednafen/psx/Makefile.am.inc",
                "mednafen/psx/notes/MULTITAP",
                "mednafen/psx/notes/PROBLEMATIC-GAMES",
                "mednafen/psx/notes/PSX-TODO",
                "mednafen/psx/notes/SOURCES",
                "mednafen/psx/notes/SPU-IRQ",
                "mednafen/psx/notes/tristep.cpp",
                "mednafen/psx/spu_fir_table.inc",
                "mednafen/psx/spu_reverb.inc",
                "mednafen/qtrecord.cpp",
                "mednafen/quicklz/Makefile.am.inc",
                "mednafen/resampler/Makefile.am.inc",
                "mednafen/sexyal",
                "mednafen/sms",
                "mednafen/snes",
                "mednafen/snes_faust",
                "mednafen/SNSFLoader.cpp",
                "mednafen/sound/Makefile.am.inc",
                "mednafen/sound/okiadpcm_generate.cpp",
                "mednafen/sound/OwlResampler_altivec.inc",
                "mednafen/sound/OwlResampler_neon.inc",
                "mednafen/sound/OwlResampler_sse.inc",
                "mednafen/sound/OwlResampler_x86.inc",
                "mednafen/sound/SwiftResampler_altivec.inc",
                "mednafen/sound/SwiftResampler_generic.inc",
                "mednafen/sound/SwiftResampler_neon.inc",
                "mednafen/sound/SwiftResampler_sse2.inc",
                "mednafen/sound/SwiftResampler_x86.inc",
                "mednafen/SPCReader.cpp",
                "mednafen/ss",
                "mednafen/SSFLoader.cpp",
                "mednafen/string/Makefile.am.inc",
                "mednafen/tremor/!!!VERSION",
                "mednafen/tremor/COPYING",
                "mednafen/tremor/Makefile.am.inc",
                "mednafen/trio/CHANGES",
                "mednafen/trio/Makefile.am.inc",
                "mednafen/trio/MEDNAFEN-MODIFICATIONS",
                "mednafen/vb",
//                "mednafen/vb/debug.cpp",
//                "mednafen/vb/Makefile.am.inc",
//                "mednafen/vb/vip_draw.inc",
                "mednafen/video/font-data-12x13.c",
                "mednafen/video/font-data-18x18.c",
                "mednafen/video/Makefile.am.inc",
                "mednafen/video/README.FONTS",
                "mednafen/win32-common.cpp",
            ],
            sources: [
                "libsndfile",
//                "stubs.mm",
//                "thread.cpp",
                "mednafen/cdplay/cdplay.cpp",
                "mednafen/cdrom/CDAccess.cpp",
                "mednafen/cdrom/CDAccess_CCD.cpp",
                "mednafen/cdrom/CDAccess_Image.cpp",
                "mednafen/cdrom/CDAFReader.cpp",
                "mednafen/cdrom/CDAFReader_MPC.cpp",
                "mednafen/cdrom/CDAFReader_SF.cpp",
                "mednafen/cdrom/CDAFReader_Vorbis.cpp",
                "mednafen/cdrom/CDInterface.cpp",
                "mednafen/cdrom/CDInterface_MT.cpp",
                "mednafen/cdrom/CDInterface_ST.cpp",
                "mednafen/cdrom/CDUtility.cpp",
                "mednafen/cdrom/crc32.cpp",
                "mednafen/cdrom/galois.cpp",
                "mednafen/cdrom/l-ec.cpp",
                "mednafen/cdrom/lec.cpp",
                "mednafen/cdrom/recover-raw.cpp",
                "mednafen/cdrom/scsicd.cpp",
                "mednafen/cheat_formats/gb.cpp",
                "mednafen/cheat_formats/psx.cpp",
                "mednafen/cheat_formats/snes.cpp",
                "mednafen/compress/GZFileStream.cpp",
                "mednafen/compress/ZIPReader.cpp",
                "mednafen/compress/ZLInflateFilter.cpp",
                "mednafen/cputest/cputest.c",
                "mednafen/debug.cpp",
                "mednafen/demo/demo.cpp",
                "mednafen/endian.cpp",
                "mednafen/error.cpp",
                "mednafen/ExtMemStream.cpp",
                "mednafen/file.cpp",
                "mednafen/FileStream.cpp",
                "mednafen/general.cpp",
                "mednafen/git.cpp",
                "mednafen/hash/crc.cpp",
                "mednafen/hash/md5.cpp",
                "mednafen/hash/sha1.cpp",
                "mednafen/hash/sha256.cpp",
                "mednafen/hw_cpu/m68k/m68k.cpp",
                "mednafen/hw_cpu/v810/v810_cpu.cpp",
                "mednafen/hw_cpu/v810/v810_fp_ops.cpp",
                "mednafen/hw_cpu/z80-fuse/z80.cpp",
                "mednafen/hw_cpu/z80-fuse/z80_ops.cpp",
                "mednafen/hw_misc/arcade_card/arcade_card.cpp",
                "mednafen/hw_sound/pce_psg/pce_psg.cpp",
                "mednafen/hw_video/huc6270/vdc.cpp",
                "mednafen/IPSPatcher.cpp",
//                "mednafen/lynx/c65c02.cpp",
//                "mednafen/lynx/cart.cpp",
//                "mednafen/lynx/memmap.cpp",
//                "mednafen/lynx/mikie.cpp",
//                "mednafen/lynx/ram.cpp",
//                "mednafen/lynx/rom.cpp",
//                "mednafen/lynx/susie.cpp",
//                "mednafen/lynx/system.cpp",
                "mednafen/mednafen.cpp",
                "mednafen/memory.cpp",
                "mednafen/MemoryStream.cpp",
                "mednafen/mempatcher.cpp",
                "mednafen/minilzo/minilzo.c",
                "mednafen/movie.cpp",
                "mednafen/mpcdec/crc32.c",
                "mednafen/mpcdec/huffman.c",
                "mednafen/mpcdec/mpc_bits_reader.c",
                "mednafen/mpcdec/mpc_decoder.c",
                "mednafen/mpcdec/mpc_demux.c",
                "mednafen/mpcdec/requant.c",
                "mednafen/mpcdec/streaminfo.c",
                "mednafen/mpcdec/synth_filter.c",
                "mednafen/mthreading/MThreading_POSIX.cpp",
                "mednafen/MTStreamReader.cpp",
                "mednafen/NativeVFS.cpp",
                "mednafen/net/Net.cpp",
                "mednafen/netplay.cpp",
//                "mednafen/ngp/bios.cpp",
//                "mednafen/ngp/biosHLE.cpp",
//                "mednafen/ngp/dma.cpp",
//                "mednafen/ngp/flash.cpp",
//                "mednafen/ngp/gfx.cpp",
//                "mednafen/ngp/gfx_scanline_colour.cpp",
//                "mednafen/ngp/gfx_scanline_mono.cpp",
//                "mednafen/ngp/interrupt.cpp",
//                "mednafen/ngp/mem.cpp",
//                "mednafen/ngp/neopop.cpp",
//                "mednafen/ngp/rom.cpp",
//                "mednafen/ngp/rtc.cpp",
//                "mednafen/ngp/sound.cpp",
//                "mednafen/ngp/T6W28_Apu.cpp",
//                "mednafen/ngp/TLCS-900h/TLCS900h_disassemble.cpp",
//                "mednafen/ngp/TLCS-900h/TLCS900h_disassemble_dst.cpp",
//                "mednafen/ngp/TLCS-900h/TLCS900h_disassemble_extra.cpp",
//                "mednafen/ngp/TLCS-900h/TLCS900h_disassemble_reg.cpp",
//                "mednafen/ngp/TLCS-900h/TLCS900h_disassemble_src.cpp",
//                "mednafen/ngp/TLCS-900h/TLCS900h_interpret.cpp",
//                "mednafen/ngp/TLCS-900h/TLCS900h_interpret_dst.cpp",
//                "mednafen/ngp/TLCS-900h/TLCS900h_interpret_reg.cpp",
//                "mednafen/ngp/TLCS-900h/TLCS900h_interpret_single.cpp",
//                "mednafen/ngp/TLCS-900h/TLCS900h_interpret_src.cpp",
//                "mednafen/ngp/TLCS-900h/TLCS900h_registers.cpp",
//                "mednafen/ngp/Z80_interface.cpp",
//                "mednafen/pce/hes.cpp",
//                "mednafen/pce/huc.cpp",
//                "mednafen/pce/huc6280.cpp",
//                "mednafen/pce/input.cpp",
//                "mednafen/pce/input/gamepad.cpp",
//                "mednafen/pce/input/mouse.cpp",
//                "mednafen/pce/mcgenjin.cpp",
//                "mednafen/pce/pce.cpp",
//                "mednafen/pce/pcecd.cpp",
//                "mednafen/pce/tsushin.cpp",
//                "mednafen/pce/vce.cpp",
//                "mednafen/pceinput/tsushinkb.cpp",
//                "mednafen/pcfx/fxscsi.cpp",
//                "mednafen/pcfx/huc6273.cpp",
//                "mednafen/pcfx/idct.cpp",
//                "mednafen/pcfx/input.cpp",
//                "mednafen/pcfx/input/gamepad.cpp",
//                "mednafen/pcfx/input/mouse.cpp",
//                "mednafen/pcfx/interrupt.cpp",
//                "mednafen/pcfx/king.cpp",
//                "mednafen/pcfx/pcfx.cpp",
//                "mednafen/pcfx/rainbow.cpp",
//                "mednafen/pcfx/soundbox.cpp",
//                "mednafen/pcfx/timer.cpp",
                "mednafen/player.cpp",
                "mednafen/PSFLoader.cpp",
                "mednafen/psx/cdc.cpp",
                "mednafen/psx/cpu.cpp",
                "mednafen/psx/dis.cpp",
                "mednafen/psx/dma.cpp",
                "mednafen/psx/frontio.cpp",
                "mednafen/psx/gpu.cpp",
                "mednafen/psx/gpu_line.cpp",
                "mednafen/psx/gpu_polygon.cpp",
                "mednafen/psx/gpu_sprite.cpp",
                "mednafen/psx/gte.cpp",
                "mednafen/psx/input/dualanalog.cpp",
                "mednafen/psx/input/dualshock.cpp",
                "mednafen/psx/input/gamepad.cpp",
                "mednafen/psx/input/guncon.cpp",
                "mednafen/psx/input/justifier.cpp",
                "mednafen/psx/input/memcard.cpp",
                "mednafen/psx/input/mouse.cpp",
                "mednafen/psx/input/multitap.cpp",
                "mednafen/psx/input/negcon.cpp",
                "mednafen/psx/irq.cpp",
                "mednafen/psx/mdec.cpp",
                "mednafen/psx/psx.cpp",
                "mednafen/psx/sio.cpp",
                "mednafen/psx/spu.cpp",
                "mednafen/psx/timer.cpp",
//                "mednafen/qtrecord.cpp",
                "mednafen/quicklz/quicklz.c",
                "mednafen/resampler/resample.c",
                "mednafen/settings.cpp",
                "mednafen/sound/Blip_Buffer.cpp",
                "mednafen/sound/DSPUtility.cpp",
                "mednafen/sound/Fir_Resampler.cpp",
                "mednafen/sound/okiadpcm.cpp",
                "mednafen/sound/OwlResampler.cpp",
                "mednafen/sound/Stereo_Buffer.cpp",
                "mednafen/sound/SwiftResampler.cpp",
                "mednafen/sound/WAVRecord.cpp",
//                "mednafen/ss/cart.cpp",
//                "mednafen/ss/cart/ar4mp.cpp",
//                "mednafen/ss/cart/backup.cpp",
//                "mednafen/ss/cart/cs1ram.cpp",
//                "mednafen/ss/cart/debug.cpp",
//                "mednafen/ss/cart/extram.cpp",
//                "mednafen/ss/cart/rom.cpp",
//                "mednafen/ss/cdb.cpp",
//                "mednafen/ss/db.cpp",
//                "mednafen/ss/input/3dpad.cpp",
//                "mednafen/ss/input/gamepad.cpp",
//                "mednafen/ss/input/gun.cpp",
//                "mednafen/ss/input/jpkeyboard.cpp",
//                "mednafen/ss/input/keyboard.cpp",
//                "mednafen/ss/input/mission.cpp",
//                "mednafen/ss/input/mouse.cpp",
//                "mednafen/ss/input/multitap.cpp",
//                "mednafen/ss/input/wheel.cpp",
//                "mednafen/ss/scu_dsp_gen.cpp",
//                "mednafen/ss/scu_dsp_jmp.cpp",
//                "mednafen/ss/scu_dsp_misc.cpp",
//                "mednafen/ss/scu_dsp_mvi.cpp",
//                "mednafen/ss/smpc.cpp",
//                "mednafen/ss/sound.cpp",
//                "mednafen/ss/ss.cpp",
//                "mednafen/ss/vdp1.cpp",
//                "mednafen/ss/vdp1_line.cpp",
//                "mednafen/ss/vdp1_poly.cpp",
//                "mednafen/ss/vdp1_sprite.cpp",
//                "mednafen/ss/vdp2.cpp",
//                "mednafen/ss/vdp2_render.cpp",
                "mednafen/state.cpp",
                "mednafen/state_rewind.cpp",
                "mednafen/Stream.cpp",
                "mednafen/string/escape.cpp",
                "mednafen/string/string.cpp",
                "mednafen/tests.cpp",
                "mednafen/Time.cpp",
                "mednafen/tremor/bitwise.c",
                "mednafen/tremor/block.c",
                "mednafen/tremor/codebook.c",
                "mednafen/tremor/floor0.c",
                "mednafen/tremor/floor1.c",
                "mednafen/tremor/framing.c",
                "mednafen/tremor/info.c",
                "mednafen/tremor/mapping0.c",
                "mednafen/tremor/mdct.c",
                "mednafen/tremor/registry.c",
                "mednafen/tremor/res012.c",
                "mednafen/tremor/sharedbook.c",
                "mednafen/tremor/synthesis.c",
                "mednafen/tremor/vorbisfile.c",
                "mednafen/tremor/window.c",
                "mednafen/trio/trio.c",
                "mednafen/trio/trionan.c",
                "mednafen/trio/triostr.c",
//                "mednafen/vb/input.cpp",
//                "mednafen/vb/timer.cpp",
//                "mednafen/vb/vb.cpp",
//                "mednafen/vb/vip.cpp",
//                "mednafen/vb/vsu.cpp",
                "mednafen/video/Deinterlacer.cpp",
                "mednafen/video/Deinterlacer_Blend.cpp",
                "mednafen/video/Deinterlacer_Simple.cpp",
                "mednafen/video/font-data.cpp",
                "mednafen/video/png.cpp",
                "mednafen/video/primitives.cpp",
                "mednafen/video/resize.cpp",
                "mednafen/video/surface.cpp",
                "mednafen/video/tblur.cpp",
                "mednafen/video/text.cpp",
                "mednafen/video/video.cpp",
                "mednafen/VirtualFS.cpp",
            ],
            cSettings: [
                .headerSearchPath(""), // this fixes the <mednafen/*.h/m/cpp> local-vs-system header load issue, somehow
                .headerSearchPath("include"),
                .headerSearchPath("include/minilzo_external"),
                .headerSearchPath("include/minilzo_internal"),
                .headerSearchPath("include/trio_external"),
//                .headerSearchPath("mednafen"),
                .headerSearchPath("mednafen/hw_cpu"),
                .headerSearchPath("mednafen/hw_misc"),
                .headerSearchPath("mednafen/hw_sound"),
                .headerSearchPath("mednafen/hw_video"),
//                .headerSearchPath("mednafen/trio"),
                .headerSearchPath("libsndfile"),
                
                .define("MEDNAFEN_VERSION", to: "\"1.26.1\""),
                .define("PACKAGE", to: "\"mednafen\""),
                .define("MEDNAFEN_VERSION_NUMERIC", to: "0x00102601"),
//                .define("WANT_GB_EMU"),
//                .define("WANT_GBA_EMU"),
//                .define("WANT_LYNX_EMU"),
//                .define("WANT_NES_EMU"),
//                .define("WANT_NGP_EMU"),
//                .define("WANT_PCE_FAST_EMU"),
//                .define("WANT_PCE_EMU"),
//                .define("WANT_PCFX_EMU"),
                .define("WANT_PSX_EMU"),
//                .define("WANT_SS_EMU"),
//                .define("WANT_SNES_EMU"),
//                .define("WANT_SNES_FAUST_EMU"),
//                .define("WANT_VB_EMU"),
//                .define("WANT_WSWAN_EMU"),
                .define("HAVE_MKDIR"),
                .define("HAVE_PTHREAD_COND_TIMEDWAIT_RELATIVE_NP"),
                .define("SIZEOF_DOUBLE", to: "8"),
                .define("SIZEOF_CHAR", to: "1"),
                .define("SIZEOF_SHORT", to: "2"),
                .define("SIZEOF_INT", to: "4"),
                .define("SIZEOF_LONG", to: "8"),
                .define("SIZEOF_LONG_LONG", to: "8"),
                .define("SIZEOF_OFF_T", to: "8"),
                .define("SIZEOF_VOID_P", to: "8"),
                .define("SIZEOF_SIZE_T", to: "8"),
                .define("SIZEOF_PTRDIFF_T", to: "8"),
                .define("PSS_STYLE", to: "1"),
//                .define("WANT_FANCY_SCALERS", to: "1"),
//                .define("MPC_FIXED_POINT"),
//                .define("ARCH_ARM"),
//                .define("STDC_HEADERS"),
//                .define("__STDC_LIMIT_MACROS"),
                .define("ICONV_CONST="),
                .define("LSB_FIRST"),

//                .unsafeFlags([
//                    "-DHAVE_UNISTD_H",
//                    "-DMEDNAFEN_VERSION=\"1.26.1\"",
//                    "-DPACKAGE=\"mednafen\"",
//                    "-DMEDNAFEN_VERSION_NUMERIC=0x00102601",
//                    "-DHAVE_LROUND",
//                    "-DHAVE_STDINT_H",
//                    "-DHAVE_STDLIB_H",
//                    "-DHAVE_SYS_PARAM_H",
//                    "-DNDEBUG",
//                    "-funroll-loops",
//                    "-fPIC",
//                    "-Wall",
//                    "-Wno-sign-compare",
//                    "-Wno-unused-variable",
//                    "-Wno-unused-function",
//                    "-Wno-uninitialized",
//                    "-Wno-strict-aliasing",
//                    "-Wno-aggressive-loop-optimizations",
//                    "-fno-fast-math",
//                    "-fomit-frame-pointer",
//                    "-fsigned-char",
//                    "-DWANT_STEREO_SOUND",
//                    "-DSTDC_HEADERS",
//                    "-D__STDC_LIMIT_MACROS",
//                    "-D__LIBRETRO__",
//                    "-DINLINE=\"inline\"",
//                ]),
                
                
            ],
            linkerSettings: [
                .linkedLibrary("iconv")
            ]
        ),
        .binaryTarget(name: "libsndfile", path: "artifacts/libsndfile.xcframework"),
        .binaryTarget(name: "libvorbis", path: "artifacts/libvorbis.xcframework"),
        .binaryTarget(name: "libvorbisenc", path: "artifacts/libvorbisenc.xcframework"),
    ],
    cLanguageStandard: .gnu11,
    cxxLanguageStandard: .gnucxx14
)

//Package(
//    name: String,
//    platforms: [SupportedPlatform]? = nil,
//    products: [Product] = [],
//    dependencies: [Package.Dependency] = [],
//    targets: [Target] = [],
//    swiftLanguageVersions: [SwiftVersion]? = nil,
//    cLanguageStandard: CLanguageStandard? = nil,
//    cxxLanguageStandard: CXXLanguageStandard? = nil
//)
//
//
//.target(
//    name: String,
//    dependencies: [Target.Dependency],
//    path: String?,
//    exclude: [String],
//    sources: [String]?,
//    resources: [Resource]?,
//    publicHeadersPath: String?,
//    cSettings: [CSetting]?,
//    cxxSettings: [CXXSetting]?,
//    swiftSettings: [SwiftSetting]?,
//    linkerSettings: [LinkerSetting]?
//)
