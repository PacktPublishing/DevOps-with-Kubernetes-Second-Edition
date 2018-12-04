#!/bin/bash

trap "exit 0" INT QUIT TERM

is_gitrepo() {
    git status || EXIT_CODE=$? && true
    [ $EXIT_CODE = 0 ] && return 0
    return 1
}

init_git_repo() {
    git clone "${REMOTE_GIT_REPO}" "${WORK_PATH}"
    cd "${WORK_PATH}"
}

check_if_git_updated() {
    git fetch origin "${WATCH_BRANCH}" --depth 1
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse "@{u}")

    [ "${LOCAL}" != "${REMOTE}" ] && return 1
    return 0
}

apply_to_kube() {
    kubectl apply -f "${TEMPLATE_PATH}"/"${RELEASE_TARGET_CONTROLLER_TEMPLATE}" -n "${RELEASE_TARGET_NAMESPACE}"
    kubectl rollout status -f "${TEMPLATE_PATH}"/"${RELEASE_TARGET_CONTROLLER_TEMPLATE}" -n "${RELEASE_TARGET_NAMESPACE}" --timeout 5m
}

# for git
WORK_PATH=${WORK_PATH}
TEMPLATE_PATH=${TEMPLATE_PATH}
REMOTE_GIT_REPO=${REMOTE_GIT_REPO}
WATCH_BRANCH=${WATCH_BRANCH}

# for kubectl
RELEASE_TARGET_NAMESPACE=${RELEASE_TARGET_NAMESPACE}
RELEASE_TARGET_CONTROLLER_TEMPLATE=${RELEASE_TARGET_CONTROLLER_TEMPLATE}


git config --global user.name "CD Agent"
git config --global user.email "cd_agent@example.com"

if ! is_gitrepo && [ ! -d "${WORK_PATH}" ]; then
    echo "Initialization needed, pulling..."
    init_git_repo
fi

cd "${TEMPLATE_PATH}"

while :; do
    git checkout "${WATCH_BRANCH}" || true
    check_if_git_updated
    if [ "$?" = 1 ]; then
        echo "$(date): Update detected. Applying..."
        git pull origin --rebase=preserve --allow-unrelated-histories
        apply_to_kube
    else
        echo "$(date): No update detected."
    fi
    sleep 30
done
