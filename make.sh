#!/bin/sh

# This file was created by Varonex_0 on 08/01/2024.
# Its objective is to be easily able to compile & run a program without any makefile.

# Of course, it will only recompile files that were not / need to be recompiled.
# This file is meant to be used with GCC compiler.

# Courtesy of Varonex_0.

# CONFIGURATION
# =============

IDIR="./include" #include path (headers)
SDIR="./src" #source path (.c // .cpp files)
BDIR="./bin" #where the binary file is located after linking
ODIR="./obj" #where obj files are located when compiling

FILE_EXT="" #Source file extention. CAN leave it blank. ("c" or "cpp", DO NOT ADD THE DOT)
HEADER_EXT="h" #Header file extention ("h" or "hpp", DO NOT ADD THE DOT)

main="main" #Name of the "main" program
exec="exec.exe" #Name of binary file (include file extention.)

DATATIME="datatime" #Name of the generated log that keeps track of the date and time of the last compilation.

# DO NOT MODIFY PAST THIS LINE
# =============

TIME=$(date +%s)
HEADER_CHANGED=""

clear

# Extention automatic control
if [ -z "$FILE_EXT" ]; then
  if [ -f "$SDIR/$main.c" ]; then
    echo "Chosen file extention is c..."
    FILE_EXT="c"

  elif [ -f "$SDIR/$main.cpp" ]; then
    echo "Chosen file extention is cpp..."
    FILE_EXT="cpp"

  else
    echo "File extention not found. Did you forget to implement \"$SDIR/$main.c/cpp\"? Cannot resolve issue."
    exit
  fi
fi

# File ext control
if [ "$FILE_EXT" = "c" ]; then
  CC="gcc"

elif [ "$FILE_EXT" = "cpp" ]; then
  CC="g++"

else
  echo "File extention invalid. \"c\" or \"cpp\" expected. Got \"$FILE_EXT\"."
  exit
fi

#File integrity
echo "Clearing files..."

#ODIR check
if [ ! -d "$ODIR" ]; then
  mkdir "$ODIR"
fi

#BDIR check
if [ ! -d "$BDIR" ]; then
  mkdir "$BDIR"
fi

#vars init
has_converted=0

OLD_TIME=-1
if [ -f ".$DATATIME.log" ]; then
  OLD_TIME=$(head -1 ".$DATATIME.log")
fi

#include checkup
echo "Checking inclusions..."

for header in $(ls "$IDIR" | grep -E ".+\.$HEADER_EXT$"); do
  file_name=$(echo "$header" | cut -d"." -f1)
  
  LAST_TIME_HEADER=$(date -r "$IDIR/$header" +%s)

  #If header edit time ge old_time, we add it to HEADER_CHANGED list
  if [ "$LAST_TIME_HEADER" -ge "$OLD_TIME" ]; then

    #Be correct with spacing
    if [ -z "$HEADER_CHANGED" ]; then
      HEADER_CHANGED="${HEADER_CHANGED}${file_name}"
    else
      HEADER_CHANGED="${HEADER_CHANGED} ${file_name}"
    fi
  fi
done

#.o file conversion
echo "Building .o files..."

#ODIR fillup
for src in $(ls "$SDIR" | grep -E ".+\.$FILE_EXT$"); do
  file_name=$(echo "$src" | cut -d"." -f1)

  #Last modified check
  LAST_TIME_SRC=$(date -r "$SDIR/$src" +%s)

  #Check header upd
  header_res=0
  for headerName in $HEADER_CHANGED; do
    grep_res=$(grep -E "^#include +(<|\")$headerName(\.h)?)>|\") *$" "$SDIR/$src")
    if [ grep_res != "" ]; then
      header_res=1
      break
    fi
  done

  #If file newer than last run, or header newer than last run, or .o doesn't exist
  if [ "$header_res" -eq 1 -o "$LAST_TIME_SRC" -ge "$OLD_TIME" -o ! -f "$ODIR/$file_name.o" ]; then
    has_converted=1

    #rm file
    if [ -f "$ODIR/$file_name.o" ]; then
      rm "$ODIR/$file_name.o"
    fi

    #Compilation & linking
    echo "Compiling $src..."
    "$CC" -c "$SDIR/$src" -o "$ODIR/$file_name.o" -I"$IDIR" -Wall
  fi
done

echo "Building binary..."

#bin creation
if [ ! -f "$BDIR/$exec" -o "$has_converted" -eq 1 ]; then
  "$CC" -o "$BDIR/$exec" $(echo "$ODIR/*.o")
fi

echo "$TIME" > ".$DATATIME.log"

#main check
if [ -f "$SDIR/$main.$FILE_EXT" -a -f "$BDIR/$exec" ]; then
  printf "Success, executed in $(echo "`date +%s`-$TIME" | bc) seconds.\n\n"

  chmod 700 "$BDIR/$exec"
  "$BDIR/$exec"

elif [ ! -f "$SDIR/$main.$FILE_EXT" ]; then
  echo "No \"$main.$FILE_EXT\" found in \"$SDIR\" directory. Cannot run project."

else
  echo "\"$BDIR/$exec\" not found."
fi
