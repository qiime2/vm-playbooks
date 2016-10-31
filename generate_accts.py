#!/usr/bin/env python

import json
import sys

import random_name


host_data = json.loads(sys.argv[1])
accts_per_host = 8
count = int(host_data[0]['exact_count'])
names = random_name.generate(count * accts_per_host)
print(names)
