```shell-session
$ terraform init
$ terraform apply
$ terraform show -json | jq '.values.root_module.resources[] | select(.type == "aws_instance") | .values | {host: .tags.Name, id: .id}'
{
  "host": "k8s-master1",
  "id": "i-0e874b53471b26cd9"
}
{
  "host": "k8s-worker1",
  "id": "i-0d859a70d7fc04f63"
}
{
  "host": "k8s-worker2",
  "id": "i-002dc9e8ce02c0620"
}
```
