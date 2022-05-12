nodes:
- address: 127.0.0.1
  runners:

  - role: source
    function: CLIENT
    config: "CCONFIG"
    controlListen: "127.0.0.1:30001"
    nextHop: "127.0.0.1:55553"

  - role: sink
    function: SERVER
    config: "SCONFIG"
    controlListen: "127.0.0.1:30002"
    dataListen: "127.0.0.1:56662"

  - role: sender
    function: zeromq
    config: "general-config.yaml"
    controlListen: "127.0.0.1:30003"
    dataListen: "127.0.0.1:55553"
    nextHop: "127.0.0.1:55554,127.0.0.1:50001"

  - role: reciever
    function: zeromq
    config: "general-config.yaml"
    controlListen: "127.0.0.1:30004"
    dataListen: "127.0.0.1:55554,127.0.0.1:50001"
    nextHop: "127.0.0.1:56662"
