#!/bin/bash

gsutil mb -p pr-training gs://austin-lifecycle-bucket

gsutil lifecycle set lifecycle.json gs://austin-lifecycle-bucket
gsutil lifecycle get gs://austin-lifecycle-bucket
