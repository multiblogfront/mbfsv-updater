# mbfsv-updater latest_versions
A submodule of mbfsv-updater designed that retrieves the necessary information
about the latest remote version of the project.

## Usage

    mbfsv-updater latest_versions [-repo <repository>] [-brnc <branch>] [-repo <repository>] [-brnc <branch>]

### Options

#### \-repo _<repository>_

Specifies the (in GIT's own format) the repository that is referenced.
The default is the origin remote of the local repository.

#### \-brnc _<branch>_

Specifies the branch who's information is to be retrieved.
The default is the current branch in the local repository.

