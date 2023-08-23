## 1. Middleware installation

This project is a distributed project and relies on a lot of middleware, so it is necessary to build the middleware before starting the background project.

For middleware installation reference, you can see `Development Environment Setup` to install the corresponding middleware.

## 2. Import the project

### 2.1 Install jdk + maven + git

Use gitee to download open source projects.

Open the project with IDEA.


Use `ctrl + shift + r` to globally replace `34.126.131.177` as the middleware server ip.

## 3. Set the idea memory

Starting all the projects in the idea is very difficult. So you need to modify the configuration of the idea so that it can have enough memory to start the project.

### 3.1 Reduce the memory occupied by jar startup

Edit the virtual machine configuration, change the memory of each service to 512M, `-Xms512m -Xms512m -Xss256k`, if the machine is really not enough memory, you can reduce 512 appropriately, but reduce it to a certain extent, such as 256m will cause the java virtual machine to Frequent garbage collection will be more stuck, so 512m is recommended.

![image-20210706101932640](../img/开发文档/idea配置-1.png)

![image-20210706101954376](../img/开发文档/idea配置-2.png)

### 3.2 Increase the memory available for idea

Edit the idea configuration, increase the memory, at least 2G, according to the needs, you can appropriately increase to improve the fluency.

```vmoptions
-Xms512m
-Xmx2048m
-XX:ReservedCodeCacheSize=512m
-XX:+UseConcMarkSweepGC
-XX:SoftRefLRUPolicyMSPerMB=100
```

![image-20210706102108314](../img/开发文档/ideavm配置-1.png)

![image-20210706102135990](../img/开发文档/ideavm配置-2.png)

After the configuration is complete, restart the idea, and all projects can be started at this time.

## 4. Start the project

![image-20210706102545837](../img/开发文档/必须启动的服务.png)

The red boxes in the figure are the items that must be started, the others are started on demand, and it is recommended to start all of them.

