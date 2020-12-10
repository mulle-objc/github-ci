#! /usr/bin/env bash


install_mulle_clang()
{
   local provider
   local url
   local filename
   local rc
   
   provider="github"
   version="11.0.0.0"
   repo="mulle-clang-project"
   rc=""
   
   case "${MULLE_UNAME}" in
      darwin)
         brew install codeon-gmbh/software/mulle-clang
         return $?
      ;;

      linux)
         LSB_RELEASE="`lsb_release -c -s`"
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
         rc="-RC2"
      ;;
   esac

   filename="${repo}-${version}${rc}-${codename}-amd64.deb"

   case "${provider}" in
      codeon)
         url="http://download.codeon.de/dists/${codename}/main/binary-amd64"
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
