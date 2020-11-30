#! /usr/bin/env bash

OTHER_PROJECTS="${OTHER_PROJECTS}
mulle-c/mulle-c-developer;latest
mulle-sde/mulle-test;latest"
SDE_PROJECTS="${SDE_PROJECTS}
mulle-sde-developer;latest" 

export SDE_PROJECTS
export OTHER_PROJECTS

MULLE_UNAME="`uname | tr '[A-Z]' '[a-z]'`"
MULLE_UNAME="${MULLE_UNAME%%_*}"
MULLE_UNAME="${MULLE_UNAME%64}"


install_mulle_sde()
{
   curl -L -O 'https://raw.githubusercontent.com/mulle-sde/mulle-sde/release/bin/installer-all' && \
   chmod 755 installer-all && \
   ./installer-all ~ no
}



install_mulle_clang()
{
   local provider
   
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

   case "${provider}" in 
      codeon)
         sudo curl -L -O "http://download.codeon.de/dists/$LSB_RELEASE/main/binary-amd64/mulle-clang-10.0.0.2-$LSB_RELEASE-amd64.deb" || return 1
      ;;
      
      github)
         sudo curl -L -O "http:github.com/Codeon-GmbH/mulle-clang/releases/download/10.0.0.2/mulle-clang-10.0.0.2-$LSB_RELEASE-amd64.deb" || return 1
      ;;
   esac      
        
   sudo dpkg --install mulle-clang-10.0.0.2-${LSB_RELEASE}-amd64.deb   
}


install_mulle_clang &&
install_mulle_sde
