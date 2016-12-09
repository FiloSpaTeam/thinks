# How to contribute

Third-party patches are essential for keeping Thinks great. We simply can't
access the huge number of platforms and myriad configurations for running
Thinks. We want to keep it as easy as possible to contribute changes that
get things working in your environment. There are a few guidelines that we
need contributors to follow so that we can have a chance of keeping on
top of things.

## Thinks Core vs Modules

New functionality is implemented by models (if you need the use of database).
Logic functionalities can be implemented by helpers (lightweight functionality)
or with libs (with modules).We want to follow as possible the RESTful 
implementation.

If you are unsure of whether your contribution should be implemented, comment 
or open a new task on [Thinks](https://thinksoftware.herokuapp.com).

## Getting Started

* Make sure you have a [GitHub account](https://github.com/signup/free)
* Make sure you have a [Thinks account](https://thinksoftware.herokuapp.com)
* Submit a task for your issue, assuming one does not already exist.
  * Clearly describe the issue including steps to reproduce when it is a bug.
  * Make sure you fill in the earliest version that you know has the issue.
* Fork the repository on GitHub
* Short commit can be better

## Making Changes

* Create a topic branch from where you want to base your work.
  * This is usually the master branch.
  * Only target release branches if you are certain your fix must be on that
    branch.
  * To quickly create a topic branch based on master; `git checkout -b
    fix/master/my_contribution master`. Please avoid working directly on the
    `master` branch.
* Make commits of logical units.
* Check for unnecessary whitespace with `git diff --check` before committing.
* Make sure your commit messages are in the proper format.

````
    (TKS-1234) Make the example in CONTRIBUTING imperative and concrete

    Without this patch applied the example commit message in the CONTRIBUTING
    document is not a concrete example.  This is a problem because the
    contributor is left to imagine what the commit message should look like
    based on a description rather than an example.  This patch fixes the
    problem by making the example concrete and imperative.

    The first line is a real life imperative statement with a ticket number
    from our issue tracker on Thinks. The body describes the behavior without the patch,
    why this is a problem, and how the patch fixes the problem when applied.
````

* Make sure you have added the necessary tests for your changes.
* Run _all_ the tests to assure nothing else was accidentally broken.

## Making Trivial Changes

### Documentation

Like above.

````
    (TKS-1234) Add documentation commit example to CONTRIBUTING

    There is no example for contributing a documentation commit
    to the Thinks repository. This is a problem because the contributor
    is left to assume how a commit of this nature may appear.

    The first line is a real life imperative statement with a ticket number
    from our issue tracker on Thinks. The body describes the nature of
    the new documentation or comments added.
````

## Submitting Changes

* Push your changes to a topic branch in your fork of the repository.
* Submit a pull request to the repository in the thinks repository.
* Update your Thinks ticket creating a new operation that explains you have submitted code and now is ready for testing (Status: In Progress).
  * Include a link to the pull request in the ticket.
* After feedback has been given we expect responses within two weeks. After two
  weeks we may close the pull request if it isn't showing any activity.
  
  
## Testing platforms

We are using Heroku due to simplify testing and production.
Master branch is directly connected to [Thinks](https://thinksoftware.herokuapp.com) so any accepted Pull Request is directly tested on TravisCI and later pushed to platform.

Enjoy!

# Additional Resources

* [Project/Team management (Thinks)](https://thinksoftware.herokuapp.com)
* [General GitHub documentation](https://help.github.com/)
* [GitHub pull request documentation](https://help.github.com/send-pull-requests/)
