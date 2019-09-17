# NCMB for CLI

## Example

```
./sig.sh -a b34...01e \
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

## License

MIT
