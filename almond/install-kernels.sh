#!/usr/bin/env bash
set -eu

JAVA_REFS=(
  "--add-opens=java.base/java.lang=ALL-UNNAMED"
  "--add-opens=java.base/java.lang.invoke=ALL-UNNAMED"
  "--add-opens=java.base/java.lang.reflect=ALL-UNNAMED"
  "--add-opens=java.base/java.io=ALL-UNNAMED"
  "--add-opens=java.base/java.net=ALL-UNNAMED"
  "--add-opens=java.base/java.nio=ALL-UNNAMED"
  "--add-opens=java.base/java.util=ALL-UNNAMED"
  "--add-opens=java.base/java.util.concurrent=ALL-UNNAMED"
  "--add-opens=java.base/java.util.concurrent.atomic=ALL-UNNAMED"
  "--add-opens=java.base/jdk.internal.ref=ALL-UNNAMED"
  "--add-opens=java.base/sun.nio.ch=ALL-UNNAMED"
  "--add-opens=java.base/sun.security.action=ALL-UNNAMED"
  "-Djdk.reflect.useDirectMethodHandle=false"
)

[ -z "$SCALA_VERSIONS" ] && { echo "SCALA_VERSIONS is empty" ; exit 1; }
[ -z "$ALMOND_VERSION" ] && { echo "ALMOND_VERSION is empty" ; exit 1; }

for SCALA_FULL_VERSION in ${SCALA_VERSIONS}; do
  SCALA_MAJOR_VERSION=${SCALA_FULL_VERSION%.*}
  SCALA_MAJOR_VERSION_TRIMMED=$(echo "${SCALA_MAJOR_VERSION}" | tr -d .)
  KERNEL_ID="scala${SCALA_MAJOR_VERSION_TRIMMED}"

  echo "Installing almond ${ALMOND_VERSION} for Scala ${SCALA_FULL_VERSION}"

  coursier bootstrap \
      -r jitpack \
      -i user -I user:sh.almond:scala-kernel-api_${SCALA_FULL_VERSION}:${ALMOND_VERSION} \
      sh.almond:scala-kernel_${SCALA_FULL_VERSION}:${ALMOND_VERSION} \
      --default=true --sources \
      -o almond

  ./almond --install \
    --log info \
    --metabrowse \
    --id "$KERNEL_ID" \
    --display-name "Scala ${SCALA_MAJOR_VERSION}" \
    --toree-compatibility \

  rm -f almond

  KERNEL_JSON="/home/jovyan/.local/share/jupyter/kernels/${KERNEL_ID}/kernel.json"

  if [ -f "$KERNEL_JSON" ]; then
     echo "Patching $KERNEL_JSON with Java refs..."

     tmp=$(mktemp)
     jq --argjson refs "$(printf '%s\n' "${JAVA_REFS[@]}" | jq -R . | jq -s .)" \
        '.argv = [.argv[0]] + $refs + .argv[1:]' \
        "$KERNEL_JSON" > "$tmp" && mv "$tmp" "$KERNEL_JSON"
    else
     echo "Warning: Could not find $KERNEL_JSON"
    fi

  coursier bootstrap org.scalameta:metals_2.13:1.6.5 --force-fetch -o /opt/conda/metals -f

 echo '{"LanguageServerManager":{"language_servers":{"metals":{"version":2,"argv":["/opt/conda/metals"],"languages":["scala"],"mime_types":["text/x-scala"]}}}}' >> /opt/conda/etc/jupyter/jupyter_server_config.d/metals-ls.json

done