# Stage 1: Extract RSA/DES keys from TP-Link firmware
FROM debian:bookworm-slim AS key-extractor

RUN apt-get update && apt-get install -y --no-install-recommends \
        wget \
        ca-certificates \
        binwalk \
        squashfs-tools \
        p7zip-full \
        lzop \
        build-essential \
        git \
        liblzma-dev \
        liblzo2-dev \
        zlib1g-dev \
        binutils \
        binutils-mips-linux-gnu \
        xxd \
        python3 \
        python3-pip \
    && pip3 install jefferson ubi-reader --break-system-packages \
    && rm -rf /var/lib/apt/lists/*

# sasquatch: patched squashfs-tools that handles TP-Link's non-standard LZMA
# squashfs variants — binwalk calls it automatically when present.
# Patch build.sh to strip -Werror before make (fails on modern GCC).
RUN git clone --depth=1 https://github.com/devttys0/sasquatch /tmp/sasquatch \
    && python3 -c "p='/tmp/sasquatch/build.sh'; t=open(p).read(); t=t.replace('make && \$SUDO make install','sed -i \"s/-Werror//\" Makefile && echo \"CFLAGS += -fcommon\" >> Makefile && make && \$SUDO make install'); open(p,'w').write(t)" \
    && cd /tmp/sasquatch && bash build.sh \
    && rm -rf /tmp/sasquatch

# binwalk exits 3 on partial extraction (some components unsupported); that is
# acceptable here — we only need nvrammanager/slpupgrade from the squashfs.
# Also inject --run-as=root: binwalk 2.3+ refuses to run extractors as root
# without this explicit flag. Wrap it so set -e in extract_keys.sh doesn't
# abort on exit code 3.
RUN printf '#!/bin/sh\n/usr/bin/binwalk --run-as=root "$@"\nrc=$?\n[ "$rc" -eq 3 ] && exit 0 || exit "$rc"\n' \
    > /usr/local/bin/binwalk && chmod +x /usr/local/bin/binwalk

WORKDIR /build

COPY extract_keys.sh .

# "yes" = quiet binwalk mode; answers the interactive prompt in extract_keys.sh
RUN echo "yes" | bash extract_keys.sh


# Stage 2: Compile the C application
FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        libssl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

COPY Makefile .
COPY src/ ./src/
COPY --from=key-extractor /build/include/ ./include/

RUN make


# Stage 3: Minimal runtime image
FROM debian:bookworm-slim AS runtime

# libssl3 provides libcrypto; openssl package provides the legacy provider
# (legacy.so) required for EVP_des_cbc() used in switch firmware decryption
RUN apt-get update && apt-get install -y --no-install-recommends \
        libssl3 \
        openssl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /build/bin/tp-link-decrypt /usr/local/bin/tp-link-decrypt

ENTRYPOINT ["/usr/local/bin/tp-link-decrypt"]
