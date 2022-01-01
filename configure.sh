#!/bin/sh
# Download and install v2ray
curl -L -H "Cache-Control: no-cache" -o /v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
mkdir /usr/bin/v2ray /etc/v2ray
touch /etc/v2ray/config.json
unzip /v2ray.zip -d /usr/bin/v2ray
chmod -R 775 /usr/bin/v2ray

# Remove v2ray and other useless files
rm -rf /v2ray.zip

# Xray new configuration
cat <<-EOF > /etc/v2ray/config.json
{
    "log":{
        "loglevel":"warning",
        "access":"/dev/null",
        "error":"/dev/null"
    },
    "stats":{
    },
    "api":{
        "services":[
            "StatsService"
        ],
        "tag":"api"
    },
    "policy":{
        "levels":{
            "1":{
                "handshake":4,
                "connIdle":300,
                "uplinkOnly":2,
                "downlinkOnly":5,
                "statsUserUplink":false,
                "statsUserDownlink":false
            }
        },
        "system":{
            "statsInboundUplink":true,
            "statsInboundDownlink":true
        }
    },
    "allocate":{
        "strategy":"always",
        "refresh":5,
        "concurrency":3
    },
    "inbounds":[
        {
            "port":${PORT},
            "protocol":"vmess",
            "settings":{
                "clients":[
                    {
                        "id":"f011c012-5f1d-418c-9494-d24d77a9d8f9",
                        "alterId":520,
                        "level":1,
                        "email":"danxiaonuo@danxiaonuo.me"
                    }
                ],
                "decryption":"none"
            },
            "streamSettings":{
                "network":"ws",
                "wsSettings":{
                    "path":"${V2_PATH}",
                    "headers":{
                        "Host":""
                    }
                }
            }
        }
    ],
    "outbounds":[
        {
            "protocol":"freedom",
            "settings":{
            }
        }
    ],
    "routing":{
        "settings":{
            "rules":[
                {
                    "inboundTag":[
                        "api"
                    ],
                    "outboundTag":"api",
                    "type":"field"
                }
            ]
        },
        "strategy":"rules"
    }
}
EOF

# Run v2ray
/usr/bin/v2ray/v2ray -config=/etc/v2ray/config.json
