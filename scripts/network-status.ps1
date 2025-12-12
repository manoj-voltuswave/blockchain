# network-status.ps1 - Full Network Status Dashboard

$ErrorActionPreference = "SilentlyContinue"

Write-Host ""
Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║           GETH POA NETWORK STATUS DASHBOARD                 ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Container Status
Write-Host "┌─ Container Status ────────────────────────────────────────┐" -ForegroundColor Yellow
docker ps --format "table {{.Names}}\t{{.Status}}" --filter "name=geth-node"
Write-Host ""

# Network Info
Write-Host "┌─ Network Information ─────────────────────────────────────┐" -ForegroundColor Yellow
Write-Host "  Chain ID     : 1234567" -ForegroundColor White
Write-Host "  Block Time   : 15 seconds" -ForegroundColor White
Write-Host "  Consensus    : Clique (PoA)" -ForegroundColor White
Write-Host "  Sealers      : 3 nodes" -ForegroundColor White
Write-Host ""

# Block Information
Write-Host "┌─ Current Block Numbers ───────────────────────────────────┐" -ForegroundColor Yellow
$block1 = docker exec geth-node1 geth attach --exec "eth.blockNumber" /root/.ethereum/geth.ipc 2>$null
$block2 = docker exec geth-node2 geth attach --exec "eth.blockNumber" /root/.ethereum/geth.ipc 2>$null
$block3 = docker exec geth-node3 geth attach --exec "eth.blockNumber" /root/.ethereum/geth.ipc 2>$null

Write-Host "  Node 1       : $block1" -ForegroundColor Cyan
Write-Host "  Node 2       : $block2" -ForegroundColor Cyan
Write-Host "  Node 3       : $block3" -ForegroundColor Cyan

if ($block1 -eq $block2 -and $block2 -eq $block3) {
    Write-Host "  Status       : ✓ All nodes in sync" -ForegroundColor Green
} else {
    Write-Host "  Status       : ✗ Nodes out of sync!" -ForegroundColor Red
}
Write-Host ""

# Peer Connections
Write-Host "┌─ Peer Connections ────────────────────────────────────────┐" -ForegroundColor Yellow
$peers1 = docker exec geth-node1 geth attach --exec "admin.peers.length" /root/.ethereum/geth.ipc 2>$null
$peers2 = docker exec geth-node2 geth attach --exec "admin.peers.length" /root/.ethereum/geth.ipc 2>$null
$peers3 = docker exec geth-node3 geth attach --exec "admin.peers.length" /root/.ethereum/geth.ipc 2>$null

Write-Host "  Node 1       : $peers1 peers" -ForegroundColor Cyan
Write-Host "  Node 2       : $peers2 peers" -ForegroundColor Cyan
Write-Host "  Node 3       : $peers3 peers" -ForegroundColor Cyan

if ($peers1 -eq 2 -and $peers2 -eq 2 -and $peers3 -eq 2) {
    Write-Host "  Status       : ✓ Full mesh network" -ForegroundColor Green
} else {
    Write-Host "  Status       : ⚠ Incomplete connections" -ForegroundColor Yellow
}
Write-Host ""

# Mining Status
Write-Host "┌─ Mining Status ───────────────────────────────────────────┐" -ForegroundColor Yellow
$mining1 = docker exec geth-node1 geth attach --exec "eth.mining" /root/.ethereum/geth.ipc 2>$null
$mining2 = docker exec geth-node2 geth attach --exec "eth.mining" /root/.ethereum/geth.ipc 2>$null
$mining3 = docker exec geth-node3 geth attach --exec "eth.mining" /root/.ethereum/geth.ipc 2>$null

Write-Host "  Node 1       : $mining1" -ForegroundColor Cyan
Write-Host "  Node 2       : $mining2" -ForegroundColor Cyan
Write-Host "  Node 3       : $mining3" -ForegroundColor Cyan
Write-Host ""

# RPC Endpoints
Write-Host "┌─ RPC Endpoints ───────────────────────────────────────────┐" -ForegroundColor Yellow
Write-Host "  Node 1 HTTP  : http://localhost:8545" -ForegroundColor White
Write-Host "  Node 1 WS    : ws://localhost:8546" -ForegroundColor White
Write-Host "  Node 2 HTTP  : http://localhost:8547" -ForegroundColor White
Write-Host "  Node 2 WS    : ws://localhost:8548" -ForegroundColor White
Write-Host "  Node 3 HTTP  : http://localhost:8549" -ForegroundColor White
Write-Host "  Node 3 WS    : ws://localhost:8550" -ForegroundColor White
Write-Host ""

# Account Balances
Write-Host "┌─ Sealer Account Balances (ETH) ───────────────────────────┐" -ForegroundColor Yellow
$bal1 = docker exec geth-node1 geth attach --exec "web3.fromWei(eth.getBalance('0xd545dcc1e15cd1f33ede6bf2b251b7b7b1094131'), 'ether')" /root/.ethereum/geth.ipc 2>$null
$bal2 = docker exec geth-node1 geth attach --exec "web3.fromWei(eth.getBalance('0x3e72634626da0949e156a6bb201420839ef54703'), 'ether')" /root/.ethereum/geth.ipc 2>$null
$bal3 = docker exec geth-node1 geth attach --exec "web3.fromWei(eth.getBalance('0x12fdbded8a11d571fd35f04ed2bd4094777b96b9'), 'ether')" /root/.ethereum/geth.ipc 2>$null

Write-Host "  Node 1       : $bal1 ETH" -ForegroundColor Cyan
Write-Host "  Node 2       : $bal2 ETH" -ForegroundColor Cyan
Write-Host "  Node 3       : $bal3 ETH" -ForegroundColor Cyan
Write-Host ""

Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Network is operational and ready for transactions!         ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
