#! /usr/bin/env bash

install_mulle_clang()
{
   local provider
   local url
   local filename
   local packagename
   local rc

   provider="github"
   version="12.0.0.0"
   repo="mulle-clang-project"
   packagename="mulle-clang"
   rc=""  # change at release back to ""

   case "${MULLE_UNAME}" in
      darwin)
         case "${GITHUB_REF}" in
            */prerelease|*/*-prerelease)
               brew install codeon-gmbh/prerelease/mulle-clang-project
               return $?
            ;;
            
            *)
               brew install codeon-gmbh/software/mulle-clang-project
               return $?
            ;;            
         esac      
      ;;

      linux)
         LSB_RELEASE="${LSB_RELEASE:-`lsb_release -c -s`}"
         case "$LSB_RELEASE" in
            focal|bullseye)
               codename="bullseye"
            ;;

            bionic|buster)
               codename="buster"
            ;;

            *)
               echo "Unsupported debian/ubuntu release  ${LSB_RELEASE}" >&2
               exit 1
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
         rc="-RC2" # could be -RC2 or so, it's inconvenient
      ;;
   esac

   # https://github.com/Codeon-GmbH/mulle-clang-project/releases/download/11.0.0.0-RC2/mulle-clang-11.0.0.0-buster-amd64.deb
   filename="${packagename}-${version}-${codename}-amd64.deb"

   case "${provider}" in
      codeon)
         url="http://download.codeon.de/dists/${codename}/main/binary-amd64"
      ;;

      github)
         # https://github.com/Codeon-GmbH/mulle-clang/releases/download/10.0.0.2/mulle-clang-10.0.0.2-bionic-amd64.deb
         # https://github.com/Codeon-GmbH/mulle-clang-project/releases/download/11.0.0.0-RC2/mulle-clang-11.0.0.0-buster-amd64.deb
         url="https://github.com/Codeon-GmbH/${repo}/releases/download/${version}${rc}"
      ;;
   esac

   url="${url}/${filename}"

   echo "Downloading ${url} ..." >&2

   curl -L -O "${url}" &&
   sudo dpkg --install "${filename}"
}


MULLE_UNAME="`uname | tr '[A-Z]' '[a-z]'`"
MULLE_UNAME="${MULLE_UNAME%%_*}"
MULLE_UNAME="${MULLE_UNAME%64}"


install_mulle_clang
