# syntax=docker/dockerfile:1.4-labs

FROM nvcr.io/nvidia/pytorch:23.05-py3 as libriichi_build

RUN apt update -y
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN apt install -y python3.10

WORKDIR /
COPY Cargo.toml Cargo.lock .
COPY libriichi libriichi
COPY exe-wrapper exe-wrapper

RUN source $HOME/.cargo/env && cargo build -p libriichi --lib --release

# -----
FROM nvcr.io/nvidia/pytorch:23.05-py3

RUN apt update -y
RUN apt install -y python3.10
RUN pip install torch
RUN pip install toml tqdm tensorboard

WORKDIR /mortal
COPY mortal .
COPY --from=libriichi_build /target/release/libriichi.so .

# ENV MORTAL_CFG config.toml
# COPY <<'EOF' config.toml
# [control]
# state_file = '/mnt/mortal.pth'

# [resnet]
# conv_channels = 192
# num_blocks = 40
# enable_bn = true
# bn_momentum = 0.99
# EOF

VOLUME /mnt

ENTRYPOINT ["bash"]
