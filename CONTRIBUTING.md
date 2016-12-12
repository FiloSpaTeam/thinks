# How to contribute

There are a few guidelines that we
need contributors to follow so that we can have a chance of keeping on
top of things.

## Core / logic

New functionality is implemented by models (if you need the use of database).
Logic functionalities can be implemented by helpers (lightweight functionality)
or with libs (with modules).We want to follow as possible the RESTful 
implementation.

If you are unsure of whether your contribution should be implemented, comment 
or open a new task on [Thinks](https://thinksoftware.herokuapp.com) and wait for team response.

## Getting Started

* Make sure you have a [GitHub account](https://github.com/signup/free)
* Make sure you have a [Thinks account](https://thinksoftware.herokuapp.com)
* Submit a task (on ThinkSoftware) for your issue/implementation, assuming one does not already exist.
  * Clearly describe the issue/implementation including steps to reproduce when it is a bug.
  * Make sure you fill in the earliest version that you know has the issue.
* Fork the repository on GitHub and do your best

## Submitting Changes

* Push your changes to a topic branch in your fork of the repository.
* Submit a pull request to the testing branch in the thinks repository, at the moment you can use master branch.
* Update task on ThinkSoftware explaining, on the operations, that the code is ready to be merged.
* Link the pull request in the operations of tasks.
* Wait for merging.
* When merged you can close task on ThinkSoftware and accept right comment.

### Code beauty

An important point is: respect the readability of the code. We love good code and well written code. We can wait, we don't need to run, we need to have better in a better way.
  
  
## Testing platforms

We are using Heroku due to simplify testing and production (but we don't like him, we are constantly searching for a good and free as in freedom alternative, that allow us to work "fastly").
Master branch is directly connected to [Thinks](https://thinksoftware.herokuapp.com) so any accepted Pull Request is directly tested on TravisCI and later pushed to platform.

Enjoy!

# Additional Resources

* [Project/Team management (Thinks)](https://thinksoftware.herokuapp.com)
* [TravisCI](https://travis-ci.org/FiloSpaTeam/thinks)
* [General GitHub documentation](https://help.github.com/)
* [GitHub pull request documentation](https://help.github.com/send-pull-requests/)
