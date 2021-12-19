install_package() {
  # See if packages are installed and install them.
  package=${1}
  echo "*********************************************************"
  echo "* Requesting ${package}"
  status=$(dpkg-query -W -f='${Status} ${Version}\n' "${package}" 2>/dev/null | wc -l)
  if [ "${status}" -eq 0 ]; then
    echo "* Installing ${package}"
    echo "*********************************************************"
    sudo apt-get -yq install "${package}"
  else
    echo "* Already installed !!!"
    echo "*********************************************************"
  fi
}

echo
install_package man
