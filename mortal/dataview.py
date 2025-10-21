import json
import gzip

path = "dataset/2024/2024010100gm-00a9-0000-0d9240dd.mjson"

with gzip.open(path, "rt", encoding="utf-8") as f:
    for i, line in enumerate(f):
        if i >= 5:  # 只看前5条
            break
        obj = json.loads(line)
        print(f"[{i+1}] {json.dumps(obj, ensure_ascii=False, indent=2)}")
