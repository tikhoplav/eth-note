FROM rust:alpine as builder
RUN apk add --no-cache \
		build-base \
		gcc \
	&& rustup toolchain install nightly-x86_64-unknown-linux-musl \
	&& cargo install mdbook
