#!/usr/bin/env python3
# Copyright 2020 SkyWater PDK Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

# Originally written by Tim 'mithro' Ansell
# Slightly modified for Github Actions use by Amr Gouhar (agorararmard)

import datetime
import os
import pprint
import subprocess
import sys
import tempfile
import textwrap
import argparse

now = datetime.datetime.utcnow()
now = now.replace(microsecond=0)

subprocess.check_call(['git', 'reset', '--hard'])
subprocess.check_call(['git', 'submodule', 'update', '--init'])

parser = argparse.ArgumentParser(
        description="Update submodules and create a commit")
parser.add_argument('--libraries_dir', '-l', action='store', default='libraries',
                help="Libraries Directory")

args = parser.parse_args()

libdir = os.path.abspath(args.libraries_dir)

changes = []

for lib in sorted(os.listdir(libdir)):
    ldir = os.path.join(libdir, lib)
    for v in sorted(os.listdir(ldir)):
        submod = os.path.join(ldir, v)

        if v == 'latest':
            branch = 'master'
        else:
            assert v.startswith('v'), v
            branch = 'branch-'+v[1:]

        gitdir = os.path.join(submod, '.git')
        assert os.path.exists(gitdir), gitdir

        print('\n\n')
        print(v + " " + submod + " "+ branch)
        print('\n')
        subprocess.call(      ['git', 'branch', '-D', branch], cwd=submod)
        subprocess.call(      ['git', 'branch', '-D', 'origin/'+branch], cwd=submod)
        # Need unshallow and tags so git-describe works
        subprocess.check_call(['git', 'remote', '-v'], cwd=submod)
        subprocess.call(      ['git', 'fetch',              'origin', '--prune', '--prune-tags'], cwd=submod)
        subprocess.call(      ['git', 'fetch', '--progress', 'origin', '--unshallow'], cwd=submod)
        subprocess.check_call(['git', 'fetch', '--progress', 'origin', '--tags'], cwd=submod)
        subprocess.check_call(['git', 'fetch', '--progress', 'origin', '+{0}:remotes/origin/{0}'.format(branch)], cwd=submod)

        old_version = subprocess.check_output(['git', 'describe'], cwd=submod).decode('utf-8').strip()

        subprocess.check_call(['git', 'status'], cwd=submod)
        subprocess.check_call(['git', 'branch', '-av'], cwd=submod)
        subprocess.check_call(['git', 'reset', '--hard', 'origin/'+branch], cwd=submod)

        new_version = subprocess.check_output(['git', 'describe'], cwd=submod).decode('utf-8').strip()
        print(old_version + '-->' + new_version)

        log = subprocess.check_output(['git', 'log', '--graph', '--pretty=short', '--decorate=short', '--decorate-refs=remotes/origin', '--shortstat', old_version+'..'+new_version], cwd=submod).decode('utf-8')

        print('\n\n\n\n')
        print(lib + ' ' + v)
        print('\n')
        print('-'*10)
        print('-'*10)
        print('\n')
        print(subprocess.check_output(['git', 'log', '--pretty=short', '--decorate=short', '--decorate-refs=remotes/origin', old_version+'..'+new_version], cwd=submod).decode('utf-8'))
        print('\n')
        print('-'*10)
        print('\n')
        print(log)
        print('-'*10)

        changes.append((lib, v, old_version, new_version))
        subprocess.check_call(['git', 'add', v], cwd=ldir)


def get_submod_info():
    output = subprocess.check_output(['git', 'submodule', 'summary']).decode('utf-8')
    output = output.replace('\n\n\n', '\n\n')
    output = output.strip()
    return textwrap.indent(output, ' ')

print('\n\n')
print('-'*75)
subprocess.check_call(['git', 'status'])
print('-'*75)
pprint.pprint(changes)
print('-'*75)

output = ['Updating submodules on {} UTC'.format(now), '']

for lib, ver, ov, nv in changes:
    if ov == nv:
        continue
    output.append('''\
 - Updating [`{lib}` {ver}](https://github.com/google/skywater-pdk-libs-{lib}/compare/{ov}..{nv}) to {nv}'''.format(
     lib=lib, ver=ver, ov=ov, nv=nv))

output.append('')
output.append(get_submod_info())

print('\n'.join(output))


with tempfile.NamedTemporaryFile('w') as f:
    f.write('\n'.join(output))
    f.flush()
    subprocess.check_call(['git', 'commit', '--signoff', '--file={}'.format(f.name)])

