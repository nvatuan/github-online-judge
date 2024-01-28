# Github Online Judge
An online judge powered entirely on Github!

## Status
- This repo is still a Work In Progress, so things you are seeing here is just Proof-Of-Concept of how this may work.

## How to submit
- Create your `main.go` file in `challenge_xx/submit/` folder.
- Then watch the CI runs :)

## Envisioned Roadmap
- [x] There can be many problems, with each-own testdata
- [x] There can be submissions of many languages. (Py, Go, Ruby,...)
- [x] There can be customization of how a problem should be graded (achieved through `/judger/scripts/grader` and problem `meta.yaml`)
- [x] Be able to Judge code submission upon PR
- [ ] Github comments (feedback) to PR whether a code judgement is a success or failure.
  - Give feedback for "Test Case failure", "Wrong answer", "Run Time exception", etc..

- [ ] Archive PR submission into a centralized code-base per problem
  - Currently, when making submission via `challenge_xx/submit/main.py`, the program stays there.
  - It'd be great if we can clean up after merge. Eg. move the program, rename it after the author, and archive it somewhere.

- [ ] Scoreboard
  - Upon merging and accepted solution, we can add this submission author to a scoreboard.md file
  - We should think of how the scoring should be manage, taking code-plagiarism into account, since everything is public.

- [ ] Add support for popular languages
  - Python, C++, Ruby, JS, etc.
  - Java uhmmm idk

- [ ] 