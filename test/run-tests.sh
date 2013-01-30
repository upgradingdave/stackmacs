#!/bin/bash

emacs -L ./ -batch -l ert -l test/stackmacs-test.el -f ert-run-tests-batch-and-exit
