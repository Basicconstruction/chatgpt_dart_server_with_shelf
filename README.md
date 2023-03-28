A server app built using [Shelf](https://pub.dev/packages/shelf),
目前可使用的作用  
    简要的非流式传输服务器   
认证方式:
    以post方式提交 username和password字段。然后就可以使用
接下来的api。  
    api使用: post或get方法提交  
类似于  
{
"message": [
{
"role": "assistant",
"content": "How i can help you?"
},
{
"role": "user",
"content": "how can i get a american phone in china!"
}
]
}
的数据，然后服务器就会去请求openai的服务器获得数据后返回给客户。