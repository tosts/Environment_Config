#!/bin/bash

for file in *rc; do
    ln -fs Environment_Config/$file ../\.$file
done
