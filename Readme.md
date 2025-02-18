# momo-store

## Описание проекта

Проект состоит из двух репозиториев:

1. **CI/CD для фронтенда и бэкенда** — сборка, версионирование и хранение артефактов в GitLab Container Registry.
2. **Развёртывание инфраструктуры** — автоматизированное создание инфраструктуры в Яндекс Облаке с помощью Terraform и деплой приложения с использованием Helm.

Все **секреты** хранятся в **переменных GitLab CI/CD**.  
Деплой осуществляется через **Terraform** для создания **managed-кластера**, настройки **Ingress-NGINX** и **Cert-Manager**.  
Контейнеры с последними версиями **фронтенда** и **бэкенда** загружаются из **GitLab** и разворачиваются через **Helm**.

Helm-чарты **версионируются вручную** и хранятся в **Nexus**, откуда деплоятся **Prometheus, Grafana** и само приложение после выполнения Terraform-скриптов.

---

## Развёртывание приложения

### 1. Подготовка окружения

✅ Установите:
- [`Terraform`](https://developer.hashicorp.com/terraform/downloads)
- [`Helm`](https://helm.sh/docs/intro/install/)
- [`kubectl`](https://kubernetes.io/docs/tasks/tools/)
- [`GitLab CLI`](https://gitlab.com/gitlab-org/cli)

✅ Настройте переменные **GitLab CI/CD** для хранения всех **секретов**.  
✅ Подготовьте **Nexus** для хранения **Helm-чартов**.

### 2. Деплой инфраструктуры

Выполните в репозитории **инфраструктуры**:

```sh
terraform init
terraform apply -auto-approve 
```
Это создаст кластер в Яндекс Облаке и настроит Ingress, Cert-Manager.

### 3. Деплой приложения
После успешного создания инфраструктуры выполните:

sh
Copy
Edit
helm repo add nexus https://nexus.example.com/repository/helm
helm upgrade --install momo-store nexus/momo-store -f values.yaml
Устройство репозитория
📁 Репозиторий CI/CD
plaintext
Copy
Edit
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
docker-compose.yml # Локальный запуск
📁 Репозиторий инфраструктуры
plaintext
Copy
Edit
terraform/     # Конфигурация Terraform для managed-кластера
  ├── main.tf        # Основная конфигурация
  ├── provider.tf    # Настройки провайдера
  ├── variables.tf   # Переменные
  ├── versions.tf    # Ограничения по версиям

kubernetes/    # Манифесты для деплоя
  ├── backend/      # Backend (ConfigMap, Deployment, Service, Secrets)
  ├── frontend/     # Frontend (ConfigMap, Deployment, Ingress, Service, Secrets)

momo-store-chart/  # Helm-чарты
  ├── charts/backend/      # Helm-чарт backend
  ├── charts/frontend/     # Helm-чарт frontend
  ├── charts/grafana/      # Helm-чарт Grafana
  ├── charts/prometheus/   # Helm-чарт Prometheus

.gitlab-ci.yml  # Пайплайны для автоматического деплоя
🛠️ Правила внесения изменений в инфраструктуру
Все изменения в инфраструктуре вносятся через MR в репозиторий инфраструктуры.
Все изменения тестируются в отдельной ветке перед мёрджем в main.
После одобрения изменений выполните:
sh
Copy
Edit
terraform apply
🔄 Релизный цикл и версионирование
Приложение: версии контейнеров соответствуют X.Y.Z, где:
X — мажорные изменения,
Y — минорные улучшения,
Z — исправления багов.
Helm-чарты: версия задаётся вручную и хранится в Nexus.
Terraform-инфраструктура: изменения фиксируются в git tag перед каждым terraform apply.