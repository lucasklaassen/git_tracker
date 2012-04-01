# GitTracker [![Build Status](https://secure.travis-ci.org/highgroove/git_tracker.png)](http://travis-ci.org/highgroove/git_tracker)

*GitTracker*, or *git-tracker*, is a Git hook that will scan your current
branch name looking for something it recognizes as a [Pivotal Tracker][pt]
story number. If it finds one, it will automagically add it, in the [special
format][pt-format], to your commit message.

## Installation

You need to get the `git-tracker` executable on your system.

### RubyGems

Currently, this is the only option, but I plan to have a standalone version
ready soon.

```bash
$ gem install git_tracker
```

Once you have the `git-tracker` executable on your system you need to install
the hook into your local Git repository.

```bash
# from inside a local Git repository
$ git-tracker install
```

This will put the `prepare-commit-msg` hook in the `/path/to/repo/.git/hooks`
directory and make it executable.

**NOTE:** This will need to be done for each repository that you wish to use
the hook.

## Usage

With the hook installed in a repository, create branches being sure to include
the Pivotal Tracker story number in the branch name.

```bash
$ git checkout -b a_useful_and_helpful_name_#8675309
```

When you commit, Git will fire the hook which will find the story number in the
branch name and prepare your commit message so that it include the story number
in the special Pivotal Tracker syntax.

```bash
# on branch named `best_feature_ever-#8675309`
$ git commit
```

Will result in a commit message something like: *(notice the two empty lines at
the top)*

```diff


[#8675309]
# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
# On branch best_feature_ever-#8675309
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
# new file:   feature.rb
#

```

You should then add a [useful and responsible commit message][tpope]. :heart:

### Passing commit messages via command line

If you pass a commit message on the command line the hook will still add the
story number, preceded by an empty line, to the end of your message.

```bash
# on branch named `best_feature_ever-#8675309`
$ git commit -m'Look at this rad code, yo!'
```

Results in this commit message:

```
Look at this rad code, yo!

[#8675309]
```

However, if you include the story number in the Pivotal Tracker format in your
commit message, the hook will do nothing.

```bash
# on branch named `best_feature_ever-#8675309`
$ git commit -m'[#8675309] Look at this rad code, yo!'
```

Results in this commit message:


```
[#12356] Look at this rad code, yo!
```

## Contributing :octocat:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


[pt]: https://www.pivotaltracker.com/
[pt-format]: https://www.pivotaltracker.com/help/api?version=v3#scm_post_commit_message_syntax
[tpope]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
