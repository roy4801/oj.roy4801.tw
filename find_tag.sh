#!/bin/bash

grep -inr "$1" --include ./source/_posts/\*.md | grep -v '[題目]' | grep -v 'title:'
