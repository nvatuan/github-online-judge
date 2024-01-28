# `/executor`
This is for scripts to build program and execute them against test data input to retrieve participant's output.
This does not include judging (or comparing results). We use `/grader` for this.

Each bash script here will implements a build-exec workflow for each language.
For example `golang.sh` will define scripts to run a `.go` file, from start to end.

Each script should satisfy this interface:
- `spin_up()`
- `build($1: filepath)`
- `execute($1: filein)`
- `tear_down()`

### Note:
This interface can be improved so it is more multi-threaded friendly. Also, depends on each language
you may need to pass data between the steps in the workflow, so this is only proof-of-concept and not
final version. 
