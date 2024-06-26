#!/bin/sh
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

SRCLANG=en
LIST_LANG="ar ca de_DE es fr_FR it_IT ja_JP ko_KR nb_NO nl_NL pl pt_BR ru_RU zh_CN hu"

DIRECTORY_RESOURCES="../../ui/l10n"
WORKDIR="./work-dir"

AL2_STRING="// Licensed to the Apache Software Foundation (ASF) under one\n// or more contributor license agreements.  See the NOTICE file\n// distributed with this work for additional information\n// regarding copyright ownership.  The ASF licenses this file\n// to you under the Apache License, Version 2.0 (the\n// \"License\"); you may not use this file except in compliance\n// with the License.  You may obtain a copy of the License at\n//\n//   http://www.apache.org/licenses/LICENSE-2.0\n//\n// Unless required by applicable law or agreed to in writing,\n// software distributed under the License is distributed on an\n// \"AS IS\" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY\n// KIND, either express or implied.  See the License for the\n// specific language governing permissions and limitations\n// under the License.\n"

doInit()
{
        tx init
        tx set --auto-remote ${ARGUMENTS}
}

doMakeWdir()
{
        mkdir -p ${WORKDIR}
}

doCheckInit()
{
        if [ ! -f ./.tx/config ]; then
                echo "Error: Transifex project isn't init. Please run $0 init-transifex URL-transifex-project" >&2
                exit 2
        fi
}

doUploadL10NLangs()
{
        # l10n languages
        for CODELANG in ${LIST_LANG} ; do
                if [ -f "${DIRECTORY_RESOURCES}/${CODELANG}.json" ]; then
                        grep -v "^\s*//" ${DIRECTORY_RESOURCES}/${CODELANG}.js | sed -e 's/var dictionary = //' -e "\$s/;$//" > ${WORKDIR}/${CODELANG}.json
                        tx set -r ${ARGUMENTS} -l ${CODELANG} ${WORKDIR}/${CODELANG}.json
                        tx push -t -r ${ARGUMENTS} -l ${CODELANG}
                else
                        echo "Warning: the resource file for language ${CODELANG} doesn't exist."
                fi
        done
}

doDownloadL10NLangs()
{
        # prepare l10n languages
        for CODELANG in ${LIST_LANG} ; do
                if [ -f "${DIRECTORY_RESOURCES}/${CODELANG}.js" ]; then
                        grep -v "^\s*//" ${DIRECTORY_RESOURCES}/${CODELANG}.js | sed -e 's/var dictionary = //' -e "\$s/;$//" > ${WORKDIR}/${CODELANG}.json
                        tx set -r ${ARGUMENTS} -l ${CODELANG} ${WORKDIR}/${CODELANG}.json
                else
                        echo "\nWarning: the resource file for language ${CODELANG} doesn't exist."
                        echo "Run this command to force get this language from transifex:"
                        echo "\ntx set -r ${ARGUMENTS} -l ${CODELANG} ${WORKDIR}/${CODELANG}.json\n"
                fi
        done

        # get all resource files from transifex
        tx pull -f -r ${ARGUMENTS}

        # l10n languages
        for CODELANG in ${LIST_LANG} ; do
                if [ -f "${WORKDIR}/${CODELANG}.json" ]; then
                        sed -e 's/":"/": "/' \
                                -e 's/^/    /g' \
                                -e '1s/^    {/var dictionary = {\n    /' \
                                -e '$s/\}$/\n\};/' \
                                -e "1s~^~${AL2_STRING}~" \
                                ${WORKDIR}/${CODELANG}.json > ${DIRECTORY_RESOURCES}/${CODELANG}.js
                else
                        echo "Warning: the resource file for language ${CODELANG} doesn't exist on transifex"
                fi
        done
}

doUploadSourceLang()
{
        # Source language
        if [ -f ${DIRECTORY_RESOURCES}/${SRCLANG}.js ]; then
                grep -v "^\s*//" ${DIRECTORY_RESOURCES}/${SRCLANG}.js | sed -e 's/var dictionary = //' -e "\$s/;$//" > ${WORKDIR}/${SRCLANG}.json
                tx set --source -r ${ARGUMENTS} -l ${SRCLANG} ${WORKDIR}/${SRCLANG}.json
                tx push -s -r ${ARGUMENTS}
        else
                echo "Warning: the source language doesn't exist!"
        fi
}

doDownloadSourceLang()
{
        # get all resource files from transifex
        tx pull -s -r ${ARGUMENTS}
        # Source language
        if [ -f "${WORKDIR}/${SRCLANG}.json" ]; then
                sed -e 's/":"/": "/' \
                        -e 's/^/    /g' \
                        -e '1s/^    {/var dictionary = {\n    /' \
                        -e '$s/\}$/\n\};/' \
                        -e "1s~^~${AL2_STRING}~" \
                        ${WORKDIR}/${SRCLANG}.json > ${DIRECTORY_RESOURCES}/${SRCLANG}.js
        else
                echo "Warning: the source language hasn't been retrieve!"
        fi
}

if [ $# -ne 2 ]; then
        COMMAND="error"
else
        COMMAND="$1"
        ARGUMENTS="$2"
        doMakeWdir
fi

case "$COMMAND" in
        upload-source-language)
                doCheckInit
                doUploadSourceLang
                ;;

        download-source-language)
                doCheckInit
                doDownloadSourceLang
                ;;

        upload-l10n-languages)
                doCheckInit
                doUploadL10NLangs
                ;;

        download-l10n-languages)
                doCheckInit
                doDownloadL10NLangs
                ;;

        init-transifex)
                doInit
                ;;

        *|error)
                echo "Usage: $0 [ upload-source-language | download-source-language | upload-l10n-languages | download-l10n-languages ] transifex-resource" >&2
                echo "\n\tExemple: $0 download-l10n-languages CloudStack_UI.410_messagesjson\n" >&2
                echo "Usage: $0 init-transifex URL-transifex-project" >&2
                echo "\n\tExemple: $0 init-transifex https://www.transifex.com/projects/p/CloudStack_UI/\n" >&2
                exit 1
                ;;
esac
