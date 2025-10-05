# Info
This is a fork of @watchfulip's tp-link-decrypt repo that I have (with permission) taken over maintenance of and have added support for TPLink/Omada network switch firmware.
I extracted the unencrypted firmware from an Omada switch SPI flash chip and discovered the keys. It turns out the same binaries are included in public TP-Link GPL releases and can be easily downloaded.
The below README has been edited from watchfulip/tp-link-decrypt and the original can be seen there.

# Credit
- @watchfulip watchfulip@protonmail.com Original extensive TPLink firmware research and code that started this project: https://watchfulip.github.io/28-12-24/tp-link_c210_v2.html
- @GxdTxnz 3 Jan 2025 Preinstall script and enhanced extract_keys script
- @tangrs 22 Sep 2025 Finding that the relevant binaries are published in TPLink GPL code dumps and how to extract keys from them: https://blog.tangrs.id.au/2025/09/22/decrypting-tplink-smart-switch-firmware/

# Instructions
1.  (optional)  Run ./preinstall.sh or nix-shell to satisfy dependencies

2.  Run ./extract_keys.sh  to extract RSA/DES keys from TP-Link Firmware we download from vendor

3.  Run make

Decrypt with   bin/tp-link-decrypt <fw file>

If you found this tool useful, feel free to let me or WatchfulIP watchfulip@protonmail.com know :)

NOTE:

This program uses libsecurity GPL code downloaded from https://static.tp-link.com/upload/gpl-code/2022/202211/20221130/c310v2_GPL.tar.bz2

TP-Link firmware links used:

- http://download.tplinkcloud.com/firmware/ax6000v2-up-ver1-1-2-P1[20230731-rel41066]_1024_nosign_2023-07-31_11.26.17_1693471186048.bin.rollback
- http://download.tplinkcloud.com/firmware/Tapo_C210v1_en_1.3.1_Build_221218_Rel.73283n_u_1679534600836.bin
- https://static.tp-link.com/resources/gpl/rtk-maple_gpl.tar.gz

-------------------------------------------------------------------------------

Great care has been taken not to infringe TP-Link's rights.

RSA & DES keys used for verification and decryption are taken from the firmware and other binary files TP-Link themselves publish.

This tool does not allow signed firmware to be created.  Thus, there is no danger of unauthorized hostile firmware being placed on devices facilitated by this software.

It is hoped this tool may be useful in itself permitting security researches to assist TP-Link with any vulnerabilties.

-------------------------------------------------------------------------------
