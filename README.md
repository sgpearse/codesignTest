# codesignTest
Minimal demonstration for codesigning arm64 MacOS applications with CMake's Unix Makefile generator, and still receiving the "App is damaged and can't be opened" error.

This generates a .dmg image of a c++ program that just prints "codesignTest".  The binary that is distributed with the .dmg is codesigned with the script named `macCodeSign.cmake`.  The .dmg requires manual codesigning as outlined below.

Reproducing this will require a valid Developer ID Application certificate signed with a private key, and the modification of the User ID in `macCodeSign.cmake` from "DQ4ZFL4KLF" to what is on your computer.

To reproduce you can download the .dmg in [this repository's Releases](https://github.com/sgpearse/codesignTest/releases), and then verify that the binary and .dmg are codesigned with `codesign -dv --verbose=4 </Applications/codesignTest.app/Contents/MacOS/codesigntest or ~/Downloads/codesignTest-0.1.1-Darwin.dmg>`.  Or, you can genereate the .dmg by doing the following:

MacOS build version: 12.6.3
MacOS test version: 13.5.2

```
git clone https://github.com/sgpearse/codesignTest.git
cd codesignTest && mkdir build && cd build
rm -rf * && cmake -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_COMPILER=clang .. && make && make installer
```

Codesign the .dmg file itself.  Replace the User ID with your own:

```codesign --force --verbose=2 --sign "DQ4ZFL4KLF" codesignTest-0.1.1-Darwin.dmg```

Transfer the .dmg to another arm64 MacOS system to observe the "damaged" error, despite the signature seeming to be valid: 

```
cisl-ridgeland:~ pearse$ codesign -dv --verbose=4 /Applications/codesignTest.app/Contents/MacOS/codesignTest
Executable=/Applications/codesignTest.app/Contents/MacOS/codesignTest
Identifier=codesignTest
Format=bundle with Mach-O thin (arm64)
CodeDirectory v=20400 size=496 flags=0x0(none) hashes=10+2 location=embedded
VersionPlatform=1
VersionMin=786432
VersionSDK=787200
Hash type=sha256 size=32
CandidateCDHash sha256=df158907d48f1eb3f5ef7b145d43d114bff0c6c3
CandidateCDHashFull sha256=df158907d48f1eb3f5ef7b145d43d114bff0c6c3e2564197c4a69594500f7f66
Hash choices=sha256
CMSDigest=df158907d48f1eb3f5ef7b145d43d114bff0c6c3e2564197c4a69594500f7f66
CMSDigestType=2
Executable Segment base=0
Executable Segment limit=16384
Executable Segment flags=0x1
Page size=4096
Launch Constraints:
None
CDHash=df158907d48f1eb3f5ef7b145d43d114bff0c6c3
Signature size=9045
Authority=Developer ID Application: University Corporation for Atmospheric Research (DQ4ZFL4KLF)
Authority=Developer ID Certification Authority
Authority=Apple Root CA
Timestamp=Nov 1, 2023 at 9:43:36 AM
Info.plist=not bound
TeamIdentifier=DQ4ZFL4KLF
Sealed Resources=none
Internal requirements count=1 size=172
```

![image](https://github.com/sgpearse/codesignTest/assets/9522770/fec52f51-56c4-48e6-8c03-3c7e6a6ccb4d)
