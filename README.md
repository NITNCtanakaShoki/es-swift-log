## Commands

### ユーザー作成

```shell
# esl create-user <username>
esl create-user user1
```

## ユーザー削除

```shell
# els delete-user <username>
esl delete-user user1
```

## 全ユーザー削除

```shell
# esl delete-all-users
esl delete-all-users
```

## 計測

```shell
esl measure user1 user2 --until 1000000 --stream --chunk-10 --chunk-100 --chunk-1000 --chunk-10000 --paging-offset-10 --paging-offset-100 --paging-offset-1000 --paging-offset-10000 --paging-last-10 --paging-last-100 --paging-last-1000 --paging-last-10000 --paging-last-async-10 --paging-last-async-100 --paging-last-async-1000 --paging-last-async-10000
```