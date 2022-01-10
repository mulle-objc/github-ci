#! /usr/bin/env bash

install_mulle_clang()
{
   local provider
   local url
   local filename
   local packagename
   local rc

   provider="github"
   version="13.0.0.1"
   repo="mulle-clang-project"
   packagename="mulle-clang"
   rc=""  # change at release back to ""

   case "${MULLE_UNAME}" in
      darwin)
         case "${GITHUB_REF}" in
            */prerelease|*/*-prerelease)
               brew install mulle-objc/prerelease/mulle-clang-project
               return $?
            ;;
            
            *)
               brew install mulle-objc/software/mulle-clang-project
               return $?
            ;;            
         esac      
      ;;

      linux)
         LSB_RELEASE="${LSB_RELEASE:-`lsb_release -c -s`}"
         case "$LSB_RELEASE" in
            focal|bullseye|20\.*) # broken catthehacker image fix for act
               codename="bullseye"
            ;;

            bionic|buster|18\.*)
               codename="buster"
            ;;

            *)
               echo "Unsupported debian/ubuntu release \"${LSB_RELEASE}\"" >&2
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
         # rc="-RC2" # could be -RC2 or so, it's inconvenient
      ;;
   esac

   # https://github.com/Codeon-GmbH/mulle-clang-project/releases/download/11.0.0.0-RC2/mulle-clang-11.0.0.0-buster-amd64.deb
   filename="${packagename}-${version}-${codename}-amd64.deb"

   case "${provider}" in
      github)
         # https://github.com/Codeon-GmbH/mulle-clang/releases/download/10.0.0.2/mulle-clang-10.0.0.2-bionic-amd64.deb
         # https://github.com/Codeon-GmbH/mulle-clang-project/releases/download/11.0.0.0-RC2/mulle-clang-11.0.0.0-buster-amd64.deb
         url="https://github.com/mulle-cc/${repo}/releases/download/${version}${rc}"
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
