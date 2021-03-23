# Credit http://stackoverflow.com/a/2514279
# Credit https://gist.github.com/jasonrudolph/1810768#file-git-branches-by-commit-date-sh
for branch in `git branch -r | grep -v HEAD`;do echo -e `git show --format="%ci %cr" $branch | head -n 1` \\t$branch; done | sort -r