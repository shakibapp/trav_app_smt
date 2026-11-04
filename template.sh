#!/usr/bin/env bash
# Feature Empty Boilerplate Generator for Riverpod Clean Architecture (Directories & Empty Files Only)
# Usage: ./template.sh <feature_name> (nested paths are supported, e.g. auth/splash)

set -e

FEATURE_NAME="$1"

if [ -z "$FEATURE_NAME" ]; then
    read -p "Enter feature name (e.g. user_profile): " FEATURE_NAME
fi

if [ -z "$FEATURE_NAME" ]; then
    echo "Error: Feature name cannot be empty."
    exit 1
fi

feature_path=$(echo "$FEATURE_NAME" | tr '[:upper:]' '[:lower:]' | tr '-' '_')

case "$feature_path" in
    /*|*..*)
        echo "Error: Feature name must be a relative path without '..'."
        exit 1
        ;;
esac

feature_name="${feature_path##*/}"

ROOT_DIR="$(pwd)"
while [ ! -f "$ROOT_DIR/pubspec.yaml" ] && [ "$ROOT_DIR" != "/" ]; do
    ROOT_DIR="$(dirname "$ROOT_DIR")"
done

if [ ! -f "$ROOT_DIR/pubspec.yaml" ]; then
    echo -e "\033[31mError: Could not locate pubspec.yaml project root!\033[0m"
    exit 1
fi

BASE_DIR="$ROOT_DIR/lib/riverpod-version/features/$feature_path"

echo "Creating Clean Architecture Riverpod directories at: $BASE_DIR"
mkdir -p "$BASE_DIR/domain/entities"
mkdir -p "$BASE_DIR/domain/repo"
mkdir -p "$BASE_DIR/domain/usecases"
mkdir -p "$BASE_DIR/data/models"
mkdir -p "$BASE_DIR/data/datasources"
mkdir -p "$BASE_DIR/data/repo"
mkdir -p "$BASE_DIR/presentation/provider"

# Create empty files (No pre-filled code, ready for you to code from scratch!)
touch "$BASE_DIR/domain/entities/${feature_name}_entity.dart"
touch "$BASE_DIR/domain/repo/${feature_name}_repo.dart"
touch "$BASE_DIR/domain/usecases/${feature_name}_use_case.dart"
touch "$BASE_DIR/data/models/${feature_name}_model.dart"
touch "$BASE_DIR/data/datasources/${feature_name}_remote_data_source.dart"
touch "$BASE_DIR/data/datasources/${feature_name}_local_data_source.dart"
touch "$BASE_DIR/data/repo/${feature_name}_repo_impl.dart"
touch "$BASE_DIR/presentation/provider/${feature_name}_notifier.dart"
touch "$BASE_DIR/presentation/${feature_name}_screen.dart"

echo -e "\033[32mSuccessfully created Riverpod Clean Architecture structure for: $feature_path\033[0m"
echo -e "Files created:"
echo -e "  ├── domain/entities/${feature_name}_entity.dart"
echo -e "  ├── domain/repo/${feature_name}_repo.dart"
echo -e "  ├── domain/usecases/${feature_name}_use_case.dart"
echo -e "  ├── data/models/${feature_name}_model.dart"
echo -e "  ├── data/datasources/${feature_name}_remote_data_source.dart"
echo -e "  ├── data/datasources/${feature_name}_local_data_source.dart"
echo -e "  ├── data/repo/${feature_name}_repo_impl.dart"
echo -e "  ├── presentation/provider/${feature_name}_notifier.dart"
echo -e "  └── presentation/${feature_name}_screen.dart"

