# workflow-github-
Registro apagamento geral 
  - name: Prepare and archive master, generate bundle
    run: |
      set -euo pipefail
      TIMESTAMP=$(date -u +"%Y%m%dT%H%M%SZ")
      OUT=output
      SNAP_DIR="$OUT/repo_snapshot"
      rm -rf "$OUT" "$SNAP_DIR"
      mkdir -p "$SNAP_DIR"
      echo "Archiving repository master at $TIMESTAMP" > "$OUT/summary.txt"
      echo "Repository: $GITHUB_REPOSITORY" >> "$OUT/summary.txt"
      echo "Timestamp: $TIMESTAMP" >> "$OUT/summary.txt"
      # try to archive origin/master, fallback to master
      if git rev-parse --verify origin/master >/dev/null 2>&1; then
        git archive --format=tar origin/master | tar -x -C "$SNAP_DIR" || true
      else
        git archive --format=tar master | tar -x -C "$SNAP_DIR" || true
      fi
      tar -czf "$OUT/master_${TIMESTAMP}.tar.gz" -C "$SNAP_DIR" . || true
      # collect some metadata
      git -C "$SNAP_DIR" log --pretty=format:"%H | %an | %ad | %s" -n 50 > "$OUT/commits_recent.txt" || true
      echo "Collected commits (last 50) in commits_recent.txt" >> "$OUT/summary.txt"
      # generate simple plaintext report
      cat >> "$OUT/summary.txt" <<EOF