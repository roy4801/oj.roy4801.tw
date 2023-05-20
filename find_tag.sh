#!/bin/bash

grep -inr "$1" --include ./source/_posts/\*.md
