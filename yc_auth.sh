apk update
apk add bash curl
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
yc config set service-account-key /tmp/yc-sa-key.json
yc config set cloud-id $YC_CLOUD_ID
yc config set folder-id $YC_FOLDER_ID