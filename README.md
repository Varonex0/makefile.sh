# makefile.sh
Made by **@Varonex_0**.
Simulates makefile through a shell script (may be bash compatible).

## How to use?
Create a `run.sh` script & copy/paste the code content, or download `run.sh` from here.
The script must be located **at the root** of your project:

* Project_Root
  * **run.sh**
  * *src\**
  * *include\**

*Mandatory folders are written with a \**

## Config
The script is configurable, everything is explained with comments.

* `IDIR`: Include path from project root. Contains all .h/.hpp files.Create it **manually**.
* `SDIR`: Source path from project root. Contains all .c/.cpp files. Create it **manually**.
* `BDIR`: Folder containing the generated executable file. The creation is automatic.
* `ODIR`: Folder containing the generated object files. The creation is automatic.

* `FILE_EXT`: Extention of source files. (`c` or `cpp`).
* `HEADER_EXT`: Extention of header files. (`h` or `hpp`).

* `main`: Name of the root program.
* `exec`: Name of the generated executable file. Put extention if necessary (`.exe` for Windows users).

* `DATATIME`: Name of the generated file that keeps track of the last time the script was used. The file is hidden. If you set `datatime`, it will be named `.datatime.log`.

## Issues
If you experience any issues, please let me know by writing a comment. You may try to:
* Delete the `.datatime.log` file (the file name is exactly `.${DATATIME}.log`, depending on the settings you have put).
* Delete both the `bin` & `obj` generated folders (**with** their content).
