parse_json() {
  node -pe "JSON.parse(process.argv[1]).$1" $2
}
