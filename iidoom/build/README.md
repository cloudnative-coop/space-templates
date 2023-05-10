# doom-docker-nix

This is a learning repo with the intent of creating a docker image loaded with nix and with doom emacs pre-installed.

## Current progress

We have a docker image with nix, some initial packages, and /emacs/ installed but not yet doom-emacs

# Usage

``` sh
docker build -t doomnix .
docker run -ti doomnix
```

This will pop you into a nix shell that only has a few packages installed, like cowsay, lolcat, and emacs.

## Where are these packagescoming from?

We have three nix files that are used to start things up, and are mostly there for illustration (e.g. this could likely be done with 2 file in a different configuration).

`shell.nix` is the booting file.  In our Docker file we run `nix-shell shell.nix`. This is what creates the shell we boot into with all the pre-installed images

`shell.nix` imports `default.nix` and `zach.nix`.  Both of these use the buildEnv attribute to set up the actual packages we use.  I created the two files to experiment/show that you can import multiple files, and so can scope your .nix work to a relevant part so that it doesn't get too confusing to read.

There is also an `emacs.nix` file that is not yet included cos I cna't guarantee
it works. It's building emacs from head from github, following [Heinrich
Hartmann's guide](https://www.heinrichhartmann.com/posts/2021-08-08-nix-emacs/)

When this works, it'll be added to the shell.nix imports so that we are using the latest,greatest emacs.


