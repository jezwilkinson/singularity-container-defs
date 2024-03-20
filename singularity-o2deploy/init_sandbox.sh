#!/bin/bash

singularity build  --force --docker-login --fix-perms --fakeroot --sandbox sandboxo2/  definition_o2sandboxcontainer.def

