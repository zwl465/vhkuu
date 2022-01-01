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
    "inbounds":[
        {
            "port":"${PORT}",
            "protocol":"vmess",
            "settings":{
                "clients":[
                    {
                        "id":"${UUID}",
                        "alterId":${ALTER_ID},
                        "level":1
                    }
                ]
            },
            "streamSettings":{
                "network":"ws",
                "wsSettings":{
                    "path":"${WSPATH}"
                }
            }
        }
    ],
    "outbounds":[
        {
            "protocol":"freedom",
            "settings":{

            },
            "tag":"allowed"
        },
        {
            "protocol":"blackhole",
            "settings":{

            },
            "tag":"blocked"
        }
    ],
    "routing":{
        "rules":[
            {
                "type":"field",
                "ip":[
                    "geoip:private"
                ],
                "outboundTag":"blocked"
            }
        ]
    }
}
EOF

# Run v2ray
export V2RAY_VMESS_AEAD_FORCED=false
/usr/bin/v2ray/v2ray -config=/etc/v2ray/config.json
