# NCMB for CLI

## サンプル

### データ取得

```
./ncmb.sh -a b34...01e \
         -c 489...462 \
         -w '{"hello":"ncmb"}' \
         -m GET \
         -p Example \
         -l 100
```

## Response

```json
{
  "results": [
    {
      "objectId": "A4yjZ5varfoRnivP",
      "createDate": "2018-01-24T07:18:07.257Z",
      "updateDate": "2018-01-24T07:18:07.258Z",
      "acl": {
        "*": {
          "read": true,
          "write": true
        }
      },
      "users": [],
      "photoObjectId": "s4Ht2IBE5hRBc599",
      "messages": [
        {
          "profileImage": "img/user.png",
          "username": "test3",
          "comment": "いいね！"
        }
      ]
    }
  ]
}
```

### データ登録

```
./ncmb.sh \
  -a b34...01e \
  -c 489...462 \
  -p Example \
  -d '{"name":"test"}' \
  -m POST
```

### データ更新

```
./ncmb.sh \
  -a b34...01e \
  -c 489...462 \
  -p Example \
  -i AAA
  -d '{"name":"test"}' \
  -m PUT
```

### データ削除

```
./ncmb.sh \
  -a b34...01e \
  -c 489...462 \
  -p Example \
  -i AAA
  -m DELETE
```

## Usage

- **-a**  
アプリケーションキー
- **-c**  
クライアントキー
- **-w**  
絞り込み条件（JSON指定）
- **-p**  
クラス名
- **-m**  
HTTPメソッド（大文字指定）
- **-l**  
取得件数
- **-s**  
スキップ件数
- **-i**  
対象データ（更新、削除時のみ指定）
- **-d**  
データ（新規作成、更新時のみ指定）

## License

MIT
