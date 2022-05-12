nodes:
- address: 127.0.0.1
  runners:

  - role: source
    function: CLIENT
    config: "CCONFIG"
    controlListen: "127.0.0.1:30001"
    nextHop: "127.0.0.1:55553"

  - role: sender
    function: zeromq
    config: "general-config.yaml"
    controlListen: "127.0.0.1:30003"
    dataListen: "127.0.0.1:55553"
    nextHop: "192.168.18.11:55554,192.168.18.12:50001"

- address: 192.168.18.12
  user: ubuntu
  password: ubuntu
  runners:

  - role: sink
    function: SERVER
    config: "SCONFIG"
    controlListen: "192.168.18.12:30002"
    dataListen: "127.0.0.1:56662"

  - role: reciever
    function: zeromq
    config: "general-config.yaml"
    controlListen: "192.168.18.12:30004"
    dataListen: "192.168.18.11:55554,192.168.18.12:50001"
    nextHop: "127.0.0.1:56662"



