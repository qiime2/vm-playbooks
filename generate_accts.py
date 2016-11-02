#!/usr/bin/env python

import csv
import json
import os
import random
import sys

from passlib.hash import sha512_crypt


ADJECTIVES = ['bluesy', 'blurry', 'breezy', 'cloudy', 'cozy', 'cranky',
              'foggy', 'grumpy', 'hasty', 'jumpy', 'lovely', 'messy', 'pretty',
              'queasy', 'scaly', 'shaky', 'silly', 'sleepy', 'snazzy',
              'squeaky', 'stealthy', 'thirsty', 'wheezy', 'woozy', 'zippy']

ANIMALS = ['akita', 'albatross', 'alligator', 'angelfish', 'ant', 'anteater',
           'antelope', 'armadillo', 'axolotl', 'baboon', 'badger', 'bandicoot',
           'barracuda', 'bat', 'beagle', 'bear', 'bee', 'beetle', 'bird',
           'bison', 'bloodhound', 'boar', 'bobcat', 'bonobo', 'buffalo',
           'bulldog', 'bullfrog', 'butterfly', 'buzzard', 'camel', 'capybara',
           'cat', 'caterpillar', 'catfish', 'cattle', 'centipede', 'chameleon',
           'cheetah', 'chicken', 'chinchilla', 'chipmunk', 'cockroach',
           'cougar', 'cow', 'coyote', 'crab', 'crocodile', 'deer', 'dodo',
           'dog', 'dolphin', 'donkey', 'dragon', 'duck', 'eagle', 'echidna',
           'eel', 'elephant', 'emu', 'ferret', 'fish', 'flamingo', 'fox',
           'frog', 'gecko', 'gerbil', 'giraffe', 'goat', 'goose', 'gorilla',
           'grasshopper', 'guppy', 'hamster', 'hedgehog', 'horse',
           'hummingbird', 'hyena', 'iguana', 'jaguar', 'jellyfish', 'kangaroo',
           'koala', 'lemming', 'lemur', 'leopard', 'lion', 'lizard', 'llama',
           'lobster', 'lynx', 'magpie', 'mammoth', 'meerkat', 'mole',
           'mongoose', 'monkey', 'moose', 'mouse', 'newt', 'ocelot', 'octopus',
           'ostrich', 'otter', 'owl', 'oyster', 'panda', 'penguin', 'pig',
           'quail', 'quokka', 'quoll', 'rabbit', 'raccoon', 'rat', 'reindeer',
           'salamander', 'scorpion', 'seahorse', 'seal', 'shark', 'sheep',
           'shrew', 'shrimp', 'skunk', 'sloth', 'slug', 'snail', 'spider',
           'squid', 'squirrel', 'stoat', 'swan', 'tarantula', 'termite',
           'tiger', 'toad', 'turkey', 'turtle', 'wallaby', 'walrus', 'warthog',
           'wasp', 'weasel', 'whale', 'wolf', 'wombat', 'yak', 'zebra']

CHARS = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ23456789'

def _make_name():
    name = []
    for list_ in (ADJECTIVES, ANIMALS):
        part = None
        while not part or (part in name):
            part = random.choice(list_)
        name.append(part)
    return '-'.join(name)

def generate_names(count=1):
    usernames = []
    for i in range(count):
        username = None
        while not username or (username in usernames):
            username = _make_name()
        usernames.append(username)
    return usernames

def generate_password(size=6):
    vals = [CHARS[ord(os.urandom(1)) % len(CHARS)] for i in range(size)]
    return ''.join(vals)

if __name__=='__main__':
    host_data = json.loads(sys.argv[1])
    accts_per_host = int(sys.argv[2])
    count = int(host_data[0]['exact_count'])
    names = generate_names(count * accts_per_host)
    csv_users = []
    json_users = []
    for i, name in enumerate(names):
        password = generate_password()
        password_hash = sha512_crypt.encrypt(password)
        group = 'worker%d' % int((i / accts_per_host))
        uid = i + 2000
        csv_record = {
            'name': name,
            'password': password,
            'group': group,
        }
        csv_users.append(csv_record)
        json_record = {
            'name': name,
            'hash': password_hash,
            'group': group,
            'uid': uid,
        }
        json_users.append(json_record)
    with open('roster.csv', 'w') as fh:
        w = csv.DictWriter(fh, ['name', 'password', 'group'])
        w.writeheader()
        w.writerows(csv_users)
    with open('roster.json', 'w') as fh:
        json.dump(json_users, fh)
