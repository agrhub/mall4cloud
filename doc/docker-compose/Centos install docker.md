## Centos install Docker

Since March 2017, docker has been divided into two branch versions based on the original: Docker CE and Docker EE.

Docker CE is the free version for the community, and Docker EE is the enterprise version, which emphasizes security, but requires paid use.

This article introduces the installation and use of Docker CE.

Remove an old version:

```shell
$ sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine
```

Install some necessary system tools:

```shell
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

Add software source information:

```shell
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
```

Update the yum cache:

```shell
# centos 7
sudo yum makecache fast
# CentOS 8没有fast这个命令
sudo yum makecache
```

Install Docker-ce:

```shell
sudo yum -y install docker-ce
```

Check the installed docker version

```shell
docker version
```

Start the Docker background service

```shell
sudo systemctl start docker
```

boot

```shell
sudo systemctl enable docker
```


## Mirror acceleration

In view of domestic network problems, the subsequent pulling of Docker images is very slow, and we may need to configure accelerators to solve it.

You can use Alibaba Cloud's docker image address: https://7qyk8phi.mirror.aliyuncs.com

The new version of Docker uses `/etc/docker/daemon.json` (Linux, if not, please create a new one).

Please add to this configuration file:

(If you don't have this file, please create one first)

```json
{
  "registry-mirrors": ["https://7qyk8phi.mirror.aliyuncs.com"]
}
```

restart docker

```shell
sudo systemctl daemon-reload
sudo systemctl restart docker
```

### Check if the accelerator is valid

After configuring the accelerator, if pulling the image is still very slow, please manually check whether the accelerator configuration takes effect, and execute `docker info` on the command line. If you see the following from the result, the configuration is successful.

```shell
Registry Mirrors:
 https://7qyk8phi.mirror.aliyuncs.com/
```

### Download docker-compose

```shell
#运行此命令以下载 Docker Compose 的当前稳定版本
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#对二进制文件应用可执行权限
sudo chmod +x /usr/local/bin/docker-compose
#测试安装
docker-compose --version
#若有docker-compose version 1.29.2, build 5becea4c，则安装成功
```

