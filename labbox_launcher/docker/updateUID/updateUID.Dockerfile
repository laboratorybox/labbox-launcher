# This code is based on source code the from ms-vscode-remote.remote-containers-0.101.1 extension
#
# Example Usage:
#
# The below script will create a new docker image called image-name-updateuid
# that is the same as the image-name image, except the uid/gid of the labbox
# user inside the container has been replaced to match the uid/gid of the
# user on the host.
#
# USER_ID="$(id -u)"
# GROUP_ID="$(id -g)"
# USER_INSIDE_CONTAINER="labbox"
# BASE_IMAGE="image-name" # docker image name
# NEW_IMAGE="image-name-updateuid"
# UPDATE_UID_DIR="path to directory of this updateUID.Dockerfile file"
# docker build \
#     -f ${UPDATE_UID_DIR}/updateUID.Dockerfile \
#     -t ${NEW_IMAGE} \
#     --build-arg BASE_IMAGE=${BASE_IMAGE} \
#     --build-arg REMOTE_USER=${USER_INSIDE_CONTAINER} \
#     --build-arg NEW_UID=${USER_ID} \
#     --build-arg NEW_GID=${GROUP_ID} \
#     --build-arg IMAGE_USER=root \
#     ${UPDATE_UID_DIR}
#
#
ARG BASE_IMAGE
FROM $BASE_IMAGE

USER root

ARG REMOTE_USER
ARG NEW_UID
ARG NEW_GID
RUN /bin/sh -c ' \
        eval $(sed -n "s/${REMOTE_USER}:[^:]*:\([^:]*\):\([^:]*\):[^:]*:\([^:]*\).*/OLD_UID=\1;OLD_GID=\2;HOME_FOLDER=\3/p" /etc/passwd); \
        eval $(sed -n "s/\([^:]*\):[^:]*:${NEW_UID}:.*/EXISTING_USER=\1/p" /etc/passwd); \
        eval $(sed -n "s/\([^:]*\):[^:]*:${NEW_GID}:.*/EXISTING_GROUP=\1/p" /etc/group); \
        if [ -z "$OLD_UID" ]; then \
                echo "Remote user not found in /etc/passwd ($REMOTE_USER)."; \
        elif [ "$OLD_UID" = "$NEW_UID" -a "$OLD_GID" = "$NEW_GID" ]; then \
                echo "UIDs and GIDs are the same ($NEW_UID:$NEW_GID)."; \
        elif [ "$OLD_UID" != "$NEW_UID" -a -n "$EXISTING_USER" ]; then \
                echo "User with UID exists ($EXISTING_USER=$NEW_UID)."; \
        elif [ "$OLD_GID" != "$NEW_GID" -a -n "$EXISTING_GROUP" ]; then \
                echo "Group with GID exists ($EXISTING_GROUP=$NEW_GID)."; \
        else \
                echo "Updating UID:GID from $OLD_UID:$OLD_GID to $NEW_UID:$NEW_GID."; \
                sed -i -e "s/\(${REMOTE_USER}:[^:]*:\)[^:]*:[^:]*/\1${NEW_UID}:${NEW_GID}/" /etc/passwd; \
                if [ "$OLD_GID" != "$NEW_GID" ]; then \
                        sed -i -e "s/\([^:]*:[^:]*:\)${OLD_GID}:/\1${NEW_GID}:/" /etc/group; \
                fi; \
                chown -R $NEW_UID:$NEW_GID $HOME_FOLDER; \
        fi; \
        '

ARG IMAGE_USER
USER $IMAGE_USER

## added by jfm
RUN /bin/sh -c "groupadd docker && usermod -aG docker ${REMOTE_USER} && newgrp docker && groups ${REMOTE_USER}"
USER ${REMOTE_USER}