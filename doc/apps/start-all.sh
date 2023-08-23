#! /bin/sh
echo "Start auth service\n"
nohup java -jar mall4cloud-auth.jar > mall4cloud-auth.log &
sleep 30

echo "Start biz service\n"
nohup java -jar mall4cloud-biz.jar > mall4cloud-biz.log &
sleep 30

echo "Start gateway service\n"
nohup java -jar mall4cloud-gateway.jar > mall4cloud-gateway.log &
sleep 30

echo "Start leaf service\n"
nohup java -jar mall4cloud-leaf.jar > mall4cloud-leaf.log &
sleep 30

echo "Start multishop service\n"
nohup java -jar mall4cloud-multishop.jar > mall4cloud-multishop.log &
sleep 30

echo "Start order service\n"
nohup java -jar mall4cloud-order.jar > mall4cloud-order.log &
sleep 30

echo "Start payment service\n"
nohup java -jar mall4cloud-payment.jar > mall4cloud-payment.log &
sleep 30

echo "Start platform service\n"
nohup java -jar mall4cloud-platform.jar > mall4cloud-platform.log &
sleep 30

echo "Start product service\n"
nohup java -jar mall4cloud-product.jar > mall4cloud-product.log &
sleep 30

echo "Start rbac service\n"
nohup java -jar mall4cloud-rbac.jar > mall4cloud-rbac.log &
sleep 30

echo "Start search service\n"
nohup java -jar mall4cloud-search.jar > mall4cloud-search.log &
sleep 30

echo "Start user service\n"
nohup java -jar mall4cloud-user.jar > mall4cloud-user.log &
sleep 30
