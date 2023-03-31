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
验证方式：
    客户向服务器发送json格式的请求体（POST）  
        示例格式如下：  
{
"username": "key",
"password": "word"
}  
然后服务端同样使用json解码，如果登录成功，返回下面信息
{"message":"登录成功","$temporary_key":""}    
其中temporary_key为临时请求秘钥（特定于用户),session中加入该用户信息。  
之后用户获得这个临时请求秘钥信息，在请求时发送要请求的完整对话信息以及临时秘钥  
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
],
"temporary_key":"$temporary_key"
}  
