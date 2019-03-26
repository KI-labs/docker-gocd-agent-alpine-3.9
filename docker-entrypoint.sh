#!/bin/bash

# Copyright 2018 ThoughtWorks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { echo "$ $@" 1>&2; "$@" || die "cannot $*"; }

[ -z "${VOLUME_DIR}" ] && VOLUME_DIR="/godata"

AGENT_WORK_DIR="/go"

# no arguments are passed so assume user wants to run the gocd server
# we prepend "/go-agent/agent.sh" to the argument list
if [[ $# -eq 0 ]] ; then
  set -- /go-agent/agent.sh "$@"
fi

# these 3 vars are used by `/go-agent/agent.sh`, so we export
export AGENT_WORK_DIR
export GO_AGENT_SYSTEM_PROPERTIES="${GO_AGENT_SYSTEM_PROPERTIES}${GO_AGENT_SYSTEM_PROPERTIES:+ }-Dgo.console.stdout=true"
export AGENT_BOOTSTRAPPER_JVM_ARGS="${AGENT_BOOTSTRAPPER_JVM_ARGS}${AGENT_BOOTSTRAPPER_JVM_ARGS:+ }-Dgo.console.stdout=true"

try exec "$@"
