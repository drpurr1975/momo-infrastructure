#!/bin/bash

# Рекурсивно ищем файлы Chart.yaml
find . -type f -name "Chart.yaml" | while read -r chart_file; do
    chart_dir=$(dirname "$chart_file")
    
    # Извлекаем имя чарта и версию из Chart.yaml
    chart_name=$(grep -E '^name:' "$chart_file" | awk '{print $2}')
    version=$(grep -E '^version:' "$chart_file" | awk '{print $2}')
    
    if [[ -z "$chart_name" || -z "$version" ]]; then
        echo "[ERROR] Не удалось определить имя или версию для $chart_file"
        continue
    fi
    
    echo "[INFO] Обрабатываем чарт: $chart_name (версия: $version)"
    
    # Упаковываем Helm-чарт
    helm package "$chart_dir"
    
    # Находим сгенерированный архив
    package_file="${chart_name}-${version}.tgz"
    
    if [[ ! -f "$package_file" ]]; then
        echo "[ERROR] Архив $package_file не найден!"
        continue
    fi
    
    echo "[INFO] Загружаем $package_file на Nexus"
    
    curl -u "$NEXUS_USERNAME:$NEXUS_PASSWORD" --upload-file "$package_file" "$NEXUS_HELM_REPO"
    
    if [[ $? -eq 0 ]]; then
        echo "[INFO] Успешно загружен: $package_file"
    else
        echo "[ERROR] Ошибка загрузки: $package_file"
    fi

done