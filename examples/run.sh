#!/bin/bash

if [ -z "$GHC_CONTEXT_CONSTRAINTS" ];
then
  echo "Error: GHC_CONTEXT_CONSTRAINTS not set.  Set to the location of your ghc executable compiled with the ContextConstraints extension."
  exit 1
fi

if [ $# -eq 1 ];
then
  src="$1"
  debug="false"
else
  src="$2"
  debug="true"
fi

dir="$(dirname "$src")"
base="$(basename "$src")"
ghc=$GHC_CONTEXT_CONSTRAINTS
fdebug="-ddump-tc-trace"

cd "$dir"

exe="$(echo $base | sed 's/\.*hs//')"

function cleanup
{
  rm -f "$exe" "$exe.hi" "$exe.o"
}

if [ $debug == "false" ]
then 
  # only run tests that have expected OUTPUT sections
  check="OUTPUT"
else
  # run anything with a main
  check='^main\s*='
fi

if [ -z "$(grep $check "$base")" ]
then
  exit 0
fi

echo "-------------------- Testing $src"
cleanup

$ghc -v0 --make "$base" 
if [ $? -eq 0 ]
then
  exec "./$exe" > /tmp/actual
  grep -A1000 OUTPUT "$base" | grep -v OUTPUT | grep -v "\-}" | sed '/^\s*$/d' > /tmp/expected
  diff -y --suppress-common-lines /tmp/expected /tmp/actual
elif [ $debug == "true" ]
then
  echo
  echo "Compilation Failed: Loading trace..."
  $ghc $fdebug --make "$base" &> /tmp/error
  less /tmp/error
fi
# cleanup

