# Назва Docker-образу
IMAGE ?= stm32-build

# Забороняємо MSYS2/MinGW змінювати Linux-шляхи у Windows
export MSYS_NO_PATHCONV=1

ifeq ($(OS),Windows_NT)
    # Отримуємо абсолютний шлях у Windows-форматі для монтування -v
    CUR_DIR := $(shell pwd -W 2>/dev/null || cd)
    USER_IDS =
else
    CUR_DIR := $(shell pwd)
    USER_IDS = --user $(shell id -u):$(shell id -g)
endif

.PHONY: all build clean rebuild flash

all: build

build:
	docker run --rm $(USER_IDS) -v "$(CUR_DIR)":/workspace -w /workspace $(IMAGE) make -C firmware all

clean:
	docker run --rm $(USER_IDS) -v "$(CUR_DIR)":/workspace -w /workspace $(IMAGE) make -C firmware clean

rebuild: clean build

flash: build
	cmd /c copy /Y firmware\\build\\*.bin D:\\