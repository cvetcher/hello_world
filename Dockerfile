# syntax=docker/dockerfile:1

ARG git_ref
ARG build_ref

FROM ruby:3.1.0 AS base

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,sharing=locked,target=/var/cache/apt --mount=type=cache,sharing=locked,target=/var/lib/apt <<_EOF_
        apt-get update -qq
_EOF_

WORKDIR /app




FROM base AS git

ARG git_ref
RUN --mount=type=bind,source=.,target=/src <<_EOF_
        (cd /src; git archive $git_ref) | tar xf - -C /app
_EOF_





FROM base AS build

RUN --mount=type=cache,sharing=locked,target=/var/cache/apt --mount=type=cache,sharing=locked,target=/var/lib/apt <<_EOF_
        apt-get install -y build-essential git openssl
        update-ca-certificates
_EOF_

COPY --from=git /app/Gemfile /app/Gemfile.lock ./
RUN bundle install




FROM base AS app

COPY --from=build --link /usr/local/bundle/ /usr/local/bundle/
COPY --from=git --link /app/ ./

