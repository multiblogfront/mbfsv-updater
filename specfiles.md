# Files and Folders of Special Important to a Compliant Project
All filenames and directory names here specified
are in relation to the main directory of the Git repository.
They either are required to be tracked by Git or
required to be exempt by __.gitignore__ from Git tracking.

## mbfsv\-build
This directory must be _ignored_ by Git.

## mbfsv\-build/tmp
This directory, being within a directory ignored by Git,
is implicitly ignored by Git as well.

Deleted and re\-created before the run of __update\-struct.sh__
and then deleted again (but not again recreated) _after_
then run of of said script.

It is for temporary files used by the script.

## mbfsv\-build/err
This directory, being within a directory ignored by Git,
is implicitly ignored by Git as well.

Deleted and re\-created before the run of __update\-struct.sh__
and then left alone _after_ the run of said script.
It is meant to contain information that the __mbfsv\-updater__
program might need.

## mbfsv\-build/err/proceed.flag
This file, being within a directory ignored by Git,
is implicitly ignored by Git as well.

This file is created by the __update\-struct.sh__ script
if the run is a success \- but not if the run is a failure.
It is the presence or absence of this file
that __mbfsv\-updater__ uses to determine whether or not
the run of __update\-struct.sh__ was a success.

## mbfsv\-build/err/fail.json
This file, being within a directory ignored by Git,
is implicitly ignored by Git as well.

The __update\-struct.sh__
creates this file upon failure \-
unless the failure was so abysmal that
even the process of creating this file fails.
It is a JSON object (or hash) that
provides __mbfsv\-updater__
with detailed information about the failure.

## special\-versions.dat
This file must be _tracked_ by Git.

This is a simple text file in which each line contains
a Unix timestamp
followed by a colon
followed by a Git revision\-ID.
The Git revision\-ID represents an upgrade stop
(where certain maintenance tasks are needed to be
performed before the upgrade can proceed any further)
and the timestamp indicates when that Git revision
was "blessed" as an upgrade stop (in case a project
has multiple components that need to be upgraded
synchronously).

## update\-struct.sh
This file must be _tracked_ by Git.

This shell script must be run at least once _successfully_
at each upgrade\-stop in the upgrade process.

A failed run of this script generally is an indication
that there's something that you need to do
before the upgrade is ready to proceed.

Details of the interface of this script (including how
it specifies success or failure) are yet to be worked out.
