#!/bin/bash

zip -qr input.zip example_inputs

curl -F input=@input.zip http://localhost:8080
