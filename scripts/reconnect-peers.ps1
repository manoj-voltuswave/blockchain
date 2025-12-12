# reconnect-peers.ps1 - Updated with correct enode IDs

Write-Host "Reconnecting all peers..." -ForegroundColor Yellow

# Current enode IDs (after re-initialization)
$node1_enode = "enode://bacf86b2c979e41b0cd5c76cbd0f91c2f6b9825e367574d40f92ff220c8b3cafd371974724bf7007c2ad0dcc544a0d04e1052cd788b485869dc16764bf250123@172.25.0.101:30303"
$node2_enode = "enode://49d038000237a5a46566fd026dc543ba1320051a32e80079d9eaea2e9617912769bfc76af6020b50fd1be81574835c29a6ad1cf9734985ff449f2b74fe0d09ee@172.25.0.102:30303"
$rpc_enode = "enode://8e40bb7d0aec29170825ea98d4151b402a65b2179abc83268fde39f3d1a219c2370ef08297163eda40dd5d74cad0d4104a226670e6e36e75bc2ce34745e3c8a3@172.25.0.103:30303"

docker exec geth-node1 geth attach --exec "admin.addPeer('$node2_enode')" /root/.ethereum/geth.ipc | Out-Null
docker exec geth-node1 geth attach --exec "admin.addPeer('$rpc_enode')" /root/.ethereum/geth.ipc | Out-Null
docker exec geth-node2 geth attach --exec "admin.addPeer('$node1_enode')" /root/.ethereum/geth.ipc | Out-Null
docker exec geth-node2 geth attach --exec "admin.addPeer('$rpc_enode')" /root/.ethereum/geth.ipc | Out-Null
docker exec geth-rpc-node geth attach --exec "admin.addPeer('$node1_enode')" /root/.ethereum/geth.ipc | Out-Null
docker exec geth-rpc-node geth attach --exec "admin.addPeer('$node2_enode')" /root/.ethereum/geth.ipc | Out-Null

Start-Sleep -Seconds 3

$peers1 = docker exec geth-node1 geth attach --exec "admin.peers.length" /root/.ethereum/geth.ipc 2>$null
$peers2 = docker exec geth-node2 geth attach --exec "admin.peers.length" /root/.ethereum/geth.ipc 2>$null
$peersRpc = docker exec geth-rpc-node geth attach --exec "admin.peers.length" /root/.ethereum/geth.ipc 2>$null

Write-Host ""
Write-Host "✓ Peers reconnected!" -ForegroundColor Green
Write-Host "  Validator 1: $peers1 peers" -ForegroundColor Cyan
Write-Host "  Validator 2: $peers2 peers" -ForegroundColor Cyan
Write-Host "  RPC Node:    $peersRpc peers" -ForegroundColor Cyan
Write-Host ""
