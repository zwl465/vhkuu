# 指定创建的基础镜像
FROM alpine:latest
# 作者描述信息
LABEL maintainer "danxiaonuo <danxiaonuo@danxiaonuo.me>"
# 语言设置
ENV LANG zh_CN.UTF-8
# 时区设置
ENV TZ=Asia/Shanghai
# 修改源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
# 更新源
RUN apk upgrade
# 同步时间
RUN apk add -U tzdata \
&& ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
&& echo ${TZ} > /etc/timezone
# 安装相关依赖
RUN apk add --no-cache --virtual .build-deps ca-certificates curl
# 增加脚本
ADD configure.sh /configure.sh
# 授权脚本权限
RUN chmod +x /configure.sh
# 运行v2ray
CMD /configure.sh
