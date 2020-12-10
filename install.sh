#! /usr/bin/env bash


install_mulle_clang()
{
   local provider
   local url
   local filename

   provider="github"

   case "${MULLE_UNAME}" in
      darwin)
         brew install codeon-gmbh/software/mulle-clang
         return $?
      ;;

      linux)
         LSB_RELEASE="`lsb_release -c -s`"
         case "$LSB_RELEASE" in
            focal|bullseye)
               LSB_RELEASE="focal"
               provider="codeon"
            ;;

            bionic|buster)
               LSB_RELEASE="bionic"
            ;;

            xenial|stretch)
               LSB_RELEASE="xenial"
            ;;
         esac
      ;;

      *)
         echo "Unsupported OS ${MULLE_UNAME}" >&2
         exit 1
      ;;
   esac

   case "${GITHUB_REF}" in
      */prerelease|*/*-prerelease)
         version="11.0.0.0"
         repo="mulle-clang-project"
         rc="-RC2"
      ;;

      *)
         # soon or already obsolete
         version="10.0.0.2"
         repo="mulle-clang"
         rc=""
      ;;
   esac

   filename="${repo}-${version}${rc}-${LSB_RELEASE}-amd64.deb"

   case "${provider}" in
      codeon)
         url="http://download.codeon.de/dists/$LSB_RELEASE/main/binary-amd64"
      ;;

      github)
         # https://github.com/Codeon-GmbH/mulle-clang/releases/download/10.0.0.2/mulle-clang-10.0.0.2-bionic-amd64.deb
         url="https://github.com/Codeon-GmbH/${repo}/releases/download/${version}${rc}"
      ;;
   esac

   url="${url}/${filename}"

   sudo curl -L -O "${url}" &&
   sudo dpkg --install "${filename}"
}


MULLE_UNAME="`uname | tr '[A-Z]' '[a-z]'`"
MULLE_UNAME="${MULLE_UNAME%%_*}"
MULLE_UNAME="${MULLE_UNAME%64}"


install_mulle_clang
