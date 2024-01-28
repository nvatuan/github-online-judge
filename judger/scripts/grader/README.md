# `/grader`
Here list grading scripts for the submissions. Grading scripts are what we will use to determine
if your program output is correct or not.

## Grader type:
Below list some grader types:
### `absolute_equal.sh`
Status: Available
#### Description
- This script does string absolute compare between participant output and judge output.
- Whitespace characters will not be tolerated, and texts will be compared as-is.
- Your program is correct if your output matches exactly like the judge's output.

#### Grade Usage
```bash
source absolute_equal.sh
do_grading <YOUR_OUTPUT_FILE> <JUDGE_OUTPUT_FILE>
```


### `token_equal.sh`
Status: To be added
#### Description
- Tokenize your output and the judge output by whitespaces.
- Then do sequential compare the two list of tokens.

#### Grade Usage
```bash
source token_equal.sh
do_grading <YOUR_OUTPUT_FILE> <JUDGE_OUTPUT_FILE>
```


### `unordered_token_equal.sh`
Status: To be added
#### Description
- Tokenize your output and the judge output by whitespaces.
- Sorts two list of tokens
- If two lists are equal, your program is correct.

## Implementation Details
### Grading
Your script you have function `do_grading`, which accepts two argument:
1. `$1` is the absolute path to your program output file.
2. `$2` is the absolute path to the judge output file.

### Scoring:
Grader is a script that either succeed or fail. (by specifying exitcode).
If the grader has exitcode of 0, your program is ACCEPTED. 

#### Note:
In the future, we may add arbitrary scoring like a integer or float.
But for now, we only support ACCEPTED (AC) or WRONG_ANSWER (WA).
