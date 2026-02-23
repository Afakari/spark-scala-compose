# Spark Scala Notebook

Jupyter notebook image for `scala` + `spark` using Almond kernels, Toree compatibility, and Metals language server.

---

## Features

- Multiple Scala kernels supported
- Default Scala: **2.12.21**
- Add more versions via build args
- IDE features (Metals)
- Java 17 runtime
- Optional local Ivy cache

---

## Build

```bash
docker build \
  --build-arg ALMOND_VERSION=0.14.5 \
  --build-arg SCALA_VERSIONS="2.12.21 2.13.18" \
  .
```

---

## Build Args

| Arg            | Purpose                        |
| -------------- | ------------------------------ |
| ALMOND_VERSION | Almond kernel version          |
| SCALA_VERSIONS | Space-separated Scala versions |
| LOCAL_IVY      | include local ivy artifacts    |

---

## Login

Default password:

```
test
```

Change it in `jupyter_server_config.py`.

---

## What Happens Inside

- Installs Java 17 + Coursier
- Downloads Almond kernel(s)
- Registers them in Jupyter
- Injects JVM flags for Java 17 compatibility
- Installs Metals language server

---

## Multiple Scala Versions

Example:

```
SCALA_VERSIONS="2.12.21 2.13.18"
```

Creates kernels:

```
Scala 2.12
Scala 2.13
```
