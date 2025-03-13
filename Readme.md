# momo-store
---
<!-- ### Пельменная №2 <https://momo-store.koolthing.click>
### Prometheus <https://prometheus.koolthing.click>
### Grafana <https://grafana.koolthing.click> -->

## Описание проекта

Проект состоит из двух репозиториев:

1. **CI/CD для фронтенда и бэкенда** — сборка, версионирование и хранение артефактов в GitLab Container Registry.

### CI/CD Repo <https://github.com/drpurr1975/momo-store.git>

2. **Развёртывание инфраструктуры** — автоматизированное создание инфраструктуры в Яндекс Облаке с помощью Terraform и деплой приложения с использованием Helm.

### Infrastructure Repo <https://github.com/drpurr1975/momo-infrastructure.git>

Необходимые **секреты и другие переменные** для сборки **фронтенда и бэкенда**, а также для **автоматического развертывания инфраструктуры** хранятся в **GitLab CI/CD**.

Деплой осуществляется через **Terraform** для создания **managed-кластера**, настройки **Ingress-NGINX** и **Cert-Manager**.  
Контейнеры с последними версиями **фронтенда** и **бэкенда** загружаются из **GitLab** и разворачиваются через **Helm**.

Helm-чарты **версионируются вручную** и хранятся в **Nexus**, откуда деплоятся **Prometheus, Grafana** и само приложение после выполнения Terraform-скриптов.

---

## Развёртывание приложения

### 1. Подготовка окружения

Требуется минимальная подготовка окружения для деплоя.
Вся инфраструктура описана IaC и разворачивается почти полностью автоматически.

✅ Установите:
1. [`Terraform`](https://developer.hashicorp.com/terraform/downloads)
2. [`Helm`](https://helm.sh/docs/intro/install/)
3. [`kubectl`](https://kubernetes.io/docs/tasks/tools/)

✅ Настройте переменные **GitLab CI/CD** и **Инфраструктуры** для хранения **секретов и репозиториев**.  
✅ Подготовьте **Nexus** для хранения **Helm-чартов**.
✅ Сконфигурируйте **Яндекс Облако**, авторизуйтесь и сгенеруйте **.kube/config**.

### 2. Деплой инфраструктуры

Перед автоматическим деплоем инфраструктуры необходимо создать *облако*, *пользователя* и *каталог* в Яндекс Облаке, сгенерировать *ключ* и *токен* и задать все в переменных CI/CD.

Выполните в репозитории **инфраструктуры**:

```bash
terraform validate
terraform plan -out="planfile" -var="cloud_id=$YC_CLOUD_ID" -var="folder_id=$YC_FOLDER_ID"
terraform apply -auto-approve "planfile"
```
Это создаст кластер в Яндекс Облаке и настроит Ingress, Cert-Manager.

### 3. Деплой приложения
Перед деплоем необходимо задать необходимые *секреты* и *переменные* **GitLab** и **SonarQube** в настройках CI/CD.

После успешного создания инфраструктуры выполните:

```bash
helm repo add nexus $NEXUS_HELM_REPO --username $NEXUS_USERNAME --password $NEXUS_PASSWORD
helm repo update
helm upgrade --install momo-store --namespace="default" --atomic --timeout 30m nexus/momo-store-chart
```
---

## Устройство репозитория
### 📁 Репозиторий CI/CD
```text
backend/      # Код backend-приложения (Go)
  ├── cmd/api/       # Основной код API
  ├── internal/      # Внутренние библиотеки
  ├── Dockerfile     # Сборка контейнера
  ├── go.mod, go.sum # Зависимости Go

frontend/     # Код frontend-приложения (Vue.js)
  ├── src/          # Исходники Vue
  ├── public/       # Статические файлы
  ├── Dockerfile    # Сборка контейнера

.gitlab-ci.yml     # Пайплайны для GitLab CI/CD
.ci-templates      # Шаблоны пайплайнов
```

### 📁 Репозиторий инфраструктуры
```text
terraform/     # Конфигурация Terraform для managed-кластера
  ├── main.tf        # Основная конфигурация
  ├── provider.tf    # Настройки провайдера
  ├── variables.tf   # Переменные
  ├── versions.tf    # Ограничения по версиям

momo-store-chart/  # Helm-чарты
  ├── charts/backend/      # Helm-чарт backend
  ├── charts/frontend/     # Helm-чарт frontend
  ├── charts/grafana/      # Helm-чарт Grafana
  ├── charts/prometheus/   # Helm-чарт Prometheus

.gitlab-ci.yml  # Пайплайны для автоматического деплоя инфраструктуры
.yc_auth.sh     # Скрипт авторизации в Яндекс Облаке
```
---

## 🛠️ Правила внесения изменений в инфраструктуру
Все изменения в инфраструктуре вносятся через MR в репозиторий инфраструктуры.
Все изменения тестируются в отдельной ветке перед мёрджем в master.
После одобрения изменений выполните:

```bash
terraform apply -var="cloud_id=$YC_CLOUD_ID" -var="folder_id=$YC_FOLDER_ID"
```
---

## 🔄 Релизный цикл и версионирование
Приложение: Контейнеры версионируются по **${CI_PIPELINE_ID}** с добавлением тега **latest** для последней сборки.
Инфраструктура: Версионируется по Semver вручную в чартах и субчартах **Helm** и хранится в **Nexus**.